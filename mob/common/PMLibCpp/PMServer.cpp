//
//  PMServer.cpp
//  PMLib
//
//  Created by Kevin Calcote on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#include "PMServer.h"
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <json/json.h>
#include <curl/curl.h>

namespace PMLibCpp
{
    //Base url of the API
    const std::string PMServer::baseApiUrl = "http://teamrecon.nayeem.co";
    //Instance is null to start
    PMServer* PMServer::instance = NULL;
    //Share handle init
    CURLSH* PMServer::shareHandle = NULL;
    //Queue mutex
    pthread_mutex_t PMServer::curlQueueMutex;
    //Progress callback mutex
    pthread_mutex_t PMServer::progressCallbackMutex;
    //Cookie sharing mutex
    pthread_mutex_t PMServer::cookieSharingMutex;
    //Initialize the api table
    PMServer::ApiType PMServer::apiCommands[MAX_API_COMMANDS] = 
    {
        /*     URL                               Type    */
        
        //Account addresses
        { baseApiUrl + "/acct/login",            POST    }, 
        { baseApiUrl + "/acct/logout",           POST    },
        { baseApiUrl + "/acct/register",         POST    },
        { baseApiUrl + "/acct/update_profile",   POST    },
        { baseApiUrl + "/acct/change_password",  POST    },
        { baseApiUrl + "/acct/user",             GET     },
        //Plate addresses
        { baseApiUrl + "/plate/get",             GET     },
        { baseApiUrl + "/plate/update_location", POST    },
        { baseApiUrl + "/plate/get_wall",        GET     },
        { baseApiUrl + "/plate/post",            POST    },
        { baseApiUrl + "/plate/delete",          POST    },
        { baseApiUrl + "/plate/assoc_user",      POST    },
        //Five star addresses
        { baseApiUrl + "/five_star/rate",        POST    },
        { baseApiUrl + "/five_star/get",         GET     },
        //Favorites addresses
        { baseApiUrl + "/favorite/add",          POST    },
        { baseApiUrl + "/favorite/remove",       POST    },
        { baseApiUrl + "/favorite/get",          GET     },
        { baseApiUrl + "/favorite/get_pending",  GET     },
        { baseApiUrl + "/favorite/confirm",      POST    },
        { baseApiUrl + "/favorite/check",        GET     },
        //Followers addresses
        { baseApiUrl + "/follower/add",          POST    },
        { baseApiUrl + "/follower/remove",       POST    },
        { baseApiUrl + "/follower/get",          GET     },
        { baseApiUrl + "/follower/check",        GET     },
        //Upload addresses
        { baseApiUrl + "/util/do_upload",        UPLOAD  },
        //Gallery addresses
        { baseApiUrl + "/gallery/upload",        POST    },
        { baseApiUrl + "/gallery/get_imgs",      GET     },
        //Download addresses
        {"",                                     DOWNLOAD},
        //Feed addresses
        { baseApiUrl + "/acct/get_feed",         GET     },
        { baseApiUrl + "/acct/get_local_feed",   GET     },
        { baseApiUrl + "/acct/update_token",     POST    },
        //Message addresses
        { baseApiUrl + "/pm/get",                GET     },
        { baseApiUrl + "/pm/send",               POST    },
        //Notification addresses
        { baseApiUrl + "/notifications/get",     GET     },
        { baseApiUrl + "/notifications/hide",    POST    }        
    };
    
    //Constructor
    PMServer::PMServer()
    {
        //Do the required global init
        curl_global_init(CURL_GLOBAL_ALL);
        
        //Create the share handle
        shareHandle = curl_share_init();
        
        //Set the share locking function
        curl_share_setopt(shareHandle, CURLSHOPT_LOCKFUNC, shareLock);
        
        //Set the share unlocking function
        curl_share_setopt(shareHandle, CURLSHOPT_UNLOCKFUNC, shareUnlock);
        
        //Indicate we want to share cookies
        curl_share_setopt(shareHandle, CURLSHOPT_SHARE, CURL_LOCK_DATA_COOKIE);
        
        //Create the mutex needed for the curl handle queue
        pthread_mutexattr_t queueMutexAttr;
        pthread_mutexattr_init(&queueMutexAttr);
        pthread_mutex_init(&curlQueueMutex, &queueMutexAttr);
        
        //Create the mutex needed for progress callback protection
        pthread_mutexattr_t progresseMutexAttr;
        pthread_mutexattr_init(&progresseMutexAttr);
        pthread_mutex_init(&progressCallbackMutex, &progresseMutexAttr);
        
        //Create the mutex needed for cookie sharing
        pthread_mutexattr_t cookieMutexAttr;
        pthread_mutexattr_init(&cookieMutexAttr);
        pthread_mutex_init(&cookieSharingMutex, &cookieMutexAttr);
 
        //Create an initial easy handle to be used and push it onto the available queue
        curlHandleQueue.push(createCurlHandle());
    }
    
    //Destructor
    PMServer::~PMServer()
    {
        //Delete all allocated handles
        while(!curlHandleQueue.empty())
        {
           CurlCommandData commandData = curlHandleQueue.front();
           
           //Cleanup easy curl handle
           curl_easy_cleanup(commandData.curlHandle);
           
           //Free the command response data
           free(commandData.commandResponse->memory);
           
           //Free the memory used for the command response
           delete commandData.commandResponse;
           
           //Pop the curl handle off the queue
            curlHandleQueue.pop();
        }
        
        //we're done with libcurl, so clean it up 
        curl_global_cleanup();
    }
    
    //PMServer is a singleton
    PMServer* PMServer::getInstance()
    {        
        //Create the instance
        if(0 == instance)
        {
            instance = new PMServer();
        }
        
        return instance;
    }
    
    //Creates a curl handle and command response data
    PMServer::CurlCommandData PMServer::createCurlHandle()
    {
        CURL* curl_handle = NULL;
        CommandResponse* commandResponse = new CommandResponse;
        
        //Create initial memory to be used, will grow as needed
        commandResponse->memory = (char*)malloc(1);
        commandResponse->size = 0;
        commandResponse->dataSize = 0;
        
        //Init the easy curl session
        curl_handle = curl_easy_init();
        
        //Verbose
        //curl_easy_setopt(curl_handle, CURLOPT_VERBOSE, 1);
        
        //No signals
        curl_easy_setopt(curl_handle,
                         CURLOPT_NOSIGNAL, 1);
        
        //Set the share handle, this will allow cookies to be shared
        curl_easy_setopt(curl_handle, CURLOPT_SHARE, shareHandle);
        
        //Set the write callback
        curl_easy_setopt(curl_handle, CURLOPT_WRITEFUNCTION, writeMemoryCallback);
        
        //Set the data we want passed to the write callback 
        curl_easy_setopt(curl_handle, CURLOPT_WRITEDATA, (void *)commandResponse);
        
        //Set a user agent 
        curl_easy_setopt(curl_handle, CURLOPT_USERAGENT, "libcurl-agent/1.0");
        
        //Start the cookie engine
        curl_easy_setopt(curl_handle, CURLOPT_COOKIEFILE, "");
       
        //Set the progress function
        curl_easy_setopt(curl_handle, CURLOPT_PROGRESSFUNCTION, progress);
        
        //Set the no progress value 
        curl_easy_setopt(curl_handle, CURLOPT_NOPROGRESS, 0L);
        
        //Create the command data to be returned
        CurlCommandData newCommandData = {curl_handle, commandResponse};
        
        return newCommandData;
    }
    
    //Returns the web server api url
    const std::string& PMServer::getBaseUrl()
    {
        return baseApiUrl;
    }
    
    //Lock used by curl sharing of multiple easy curl handles
    void PMServer::shareLock(void* handle, unsigned int data, unsigned int access, void *userptr)
    {
        (void)handle;
        (void)access;
        
        //Determine the data to lock and lock it
        switch (data)
        {
            case CURL_LOCK_DATA_COOKIE:
            {
                //Lock the cookie sharing mutex
                pthread_mutex_lock(&cookieSharingMutex);
                break;
            }
            default:
            	break;
        }
    }
    
    //Unlock used by curl sharing of multiple easy curl handles
    void PMServer::shareUnlock(void* handle, unsigned int data, void *userptr)
    {
        (void)handle;
        
        //Determine the data to unlock and unlock it
        switch (data)
        {
            case CURL_LOCK_DATA_COOKIE:
            {
                //Unlock the cookie sharing mutex
                pthread_mutex_unlock(&cookieSharingMutex);
                break;
            }
            default:
            	break;
        }
    } 
    
    //Progress callback for the curl library
    int PMServer::progress(void *p, double dltotal, double dlnow, double ultotal, double ulnow)
    {
        //Only send progress if a valid request Id was given
        if ((NULL != p) && (0 != ((ProgressStruct*)p)->requestId))
        {
            double upPercent = 0;
            double downPercent = 0;
            
            if ((ultotal > 0) && (ultotal >= ulnow))
                upPercent = (double)ulnow/(double)ultotal;
            
            if ((dltotal > 0) && (dltotal >= dlnow))
                downPercent = (double)dlnow/(double)dltotal;
        
            //Lock the callback mutex during reading
            pthread_mutex_lock(&progressCallbackMutex);
            //Call the user callback
            if (NULL != instance->pCallback)
            {
                instance->pCallback(upPercent, downPercent, ((ProgressStruct*)p));
            }
            //Unlock the progress mutex
            pthread_mutex_unlock(&progressCallbackMutex);
        }
        
        return 0;
    }
    
    //Sets the user progress callback called from the PMServer::progress() function
    void PMServer::SetProgressCallback(ProgressCallbackType progressCallback)
    {
        //Lock the callback mutex during modification
        pthread_mutex_lock(&progressCallbackMutex);
        pCallback = progressCallback;
        pthread_mutex_unlock(&progressCallbackMutex);
    }
    
    //Writes any data returned from the HTTP request to a memory buffer for later refrencing
    size_t PMServer::writeMemoryCallback(void *contents, size_t size, size_t nmemb, void *userp)
    {
        size_t realsize = size * nmemb;
        struct CommandResponse *mem = (struct CommandResponse *)userp;
        
        //Realloc the buffer if the new data does not fit
        if ((mem->dataSize + realsize) > mem->size)
        {
            //Alloc extra byte for null terminator
            mem->memory = (char*)realloc(mem->memory, mem->dataSize+realsize+1);
            mem->size = mem->dataSize + realsize;
        }
        
        if (mem->memory == NULL) {
            //out of memory!
            printf("not enough memory (realloc returned NULL)\n");
            
            //Reset largest alloc
            mem->size = 0;
            mem->dataSize = 0;
            
            //leave the function, we failed
            return 0;
        }
        
        //Clear the buffer before copying the data
        memset(&mem->memory[mem->dataSize], 0, realsize);
        
        //Copy new data
        memcpy(&mem->memory[mem->dataSize], contents, realsize);
        
        mem->dataSize += realsize;
        
        //Make sure the end is null terminated
        mem->memory[mem->size] = 0;
        
        return realsize;
    }
    
    //Executes the command request using libcurl
    bool PMServer::executeCommandRequest(CurlCommandData& curlCommandData, const Json::Value& command, Json::Value& response, ApiCommand commandType, const char* fileName, unsigned int requestId, void** rawData, size_t* rawDataSize)
    {
        static std::string postCommand = "data=";
        std::string jsonData;
        
        struct curl_httppost *formpost=NULL;
        struct curl_httppost *lastptr=NULL;
        
        //Get the curl handle and memory to be used
        CURL* curl_handle = curlCommandData.curlHandle;
        CommandResponse& commandResponse = *(curlCommandData.commandResponse);
        
        if (0 == commandResponse.memory)
            return false;
        
        
        switch (apiCommands[commandType].requestType) 
        {
            case POST:
            {
                Json::FastWriter jsonWriter;
                
                //Update the post data
                jsonData = postCommand + jsonWriter.write(command);
                
                //No progress on posts
                curl_easy_setopt(curl_handle, CURLOPT_PROGRESSDATA, 0);
                
                if (CURLE_OK != curl_easy_setopt(curl_handle, CURLOPT_POST, 1))
                    return false;
                
                //specify URL to get
                if (CURLE_OK != curl_easy_setopt(curl_handle, CURLOPT_URL, apiCommands[commandType].url.c_str()))
                    return false;            
                
                //write the json data and set as the post
                if (CURLE_OK != curl_easy_setopt(curl_handle, CURLOPT_POSTFIELDS, jsonData.c_str()))
                    return false;
                
                break;
            }
            case GET:
            {
                //Decode json data and turn into a get url
                std::string getString = "";
                
                //No progress on gets
                curl_easy_setopt(curl_handle, CURLOPT_PROGRESSDATA, 0);
                
                //Make sure http GET is set
                curl_easy_setopt(curl_handle, CURLOPT_HTTPGET, 1);
                
                //decode the json data into a get string
                Json::ValueIterator jsonItr = command.begin();
                
                //Add '?' if arguments exist
                if (command.end() != jsonItr)
                    getString += "?";
                
                while (jsonItr != command.end())
                {
                    //Build get string from the key and value
                    getString += jsonItr.memberName();
                    getString += '=' + (*jsonItr).asString();
                    
                    //Add '&' if more parameters exist 
                    if ((++jsonItr) != command.end())
                        getString += '&';
                }
                
                //Build the url
                getString = apiCommands[commandType].url + getString;
                
                //Get the data
                if (CURLE_OK != curl_easy_setopt(curl_handle, CURLOPT_URL, getString.c_str()))
                    return false; 
                
                break;
            }
            case UPLOAD:
            {
                bool optStatus = true;
                ProgressStruct progressData = {requestId, UPLOAD};
                
                //Set the progress data to be the curl handle
                //this can be used to identify what process the progress is for
                if (CURLE_OK != curl_easy_setopt(curl_handle, CURLOPT_PROGRESSDATA, &progressData))
                    optStatus = false;
                
                if (optStatus && (0 != curl_formadd(&formpost, &lastptr, CURLFORM_COPYNAME, "upload", CURLFORM_FILE, fileName, CURLFORM_END)))
                    optStatus = false;
                
                if (optStatus && (CURLE_OK != curl_easy_setopt(curl_handle, CURLOPT_HTTPPOST, formpost)))
                    optStatus = false;
                
                if (optStatus && (CURLE_OK != curl_easy_setopt(curl_handle, CURLOPT_URL, apiCommands[commandType].url.c_str())))
                    optStatus = false;
                    
                if (!optStatus)
                {
                    if (NULL != formpost)
                        curl_formfree(formpost);
                    
                    return false;
                }
                
                break;
            }
            case DOWNLOAD:
            {
                ProgressStruct progressData = {requestId, DOWNLOAD};
                
                //Set the progress data to be the curl handle
                //this can be used to identify what process the progress is for
                if (CURLE_OK != curl_easy_setopt(curl_handle, CURLOPT_PROGRESSDATA, &progressData))
                    return false;
                
                //Make sure http GET is set
                if (CURLE_OK != curl_easy_setopt(curl_handle, CURLOPT_HTTPGET, 1))
                    return false;
                
                //Set the url to get
                if (CURLE_OK != curl_easy_setopt(curl_handle, CURLOPT_URL, fileName))
                    return false; 
                break;
            }
            default:
                break;
        }
        
        bool status = true;
        
        //Perform the http request
        if (CURLE_OK != curl_easy_perform(curl_handle))
            status = false;
        
        //If formpost was used then free it
        if (NULL != formpost)
            curl_formfree(formpost);
        
        if (0 >= commandResponse.dataSize)
            status = false;
        
        //If raw data is requested then allocated a new buffer
        // and copy the retrieved data into it
        if (status && (NULL != rawData) && (NULL != rawDataSize))
        {
            *rawData = malloc(commandResponse.dataSize);
            memcpy(*rawData, commandResponse.memory, commandResponse.dataSize);
            *rawDataSize = commandResponse.dataSize;
        }
        
        //Reset the buffer size
        commandResponse.dataSize = 0;
        
        
        if (status && (DOWNLOAD != apiCommands[commandType].requestType))
        {
           //DEBUG: Output server return data for debugging
           std::cout << commandResponse.memory << std::endl;
           
           //Read the JSON data
           Json::Reader jsonReader;
           
           if (!jsonReader.parse(commandResponse.memory, response))
               status = false;
        }
        
        //Zero the full buffer
        bzero(commandResponse.memory, commandResponse.size);
        
        return status;         
    }
    
    //Starts the command request execution by finding an available curl handle to use (for multi-threaded requests)
    // and then executes the request.
    bool PMServer::sendCommandRequest(const Json::Value& command, Json::Value& response, ApiCommand commandType, const char* fileName, unsigned int requestId, void** rawData, size_t* rawDataSize)
    {
        static int created = 0;
        static int onQueue = 0;
        bool status = false;
        CurlCommandData curlCommandData = {NULL,NULL};
        
        //Protect the curl queue
        pthread_mutex_lock(&curlQueueMutex);
        
        if (curlHandleQueue.empty())
        {
            //No available curl handles, create one
            curlCommandData	= createCurlHandle();
            created++;
        }
        else
        {
            //Grab curl command data from the queue
            curlCommandData = curlHandleQueue.front();
            curlHandleQueue.pop();
            onQueue--;
        }

        //Unlock the curl queue
        pthread_mutex_unlock(&curlQueueMutex);
        
        //Execute the command       
        status = executeCommandRequest(curlCommandData, command, response, commandType, fileName, requestId, rawData, rawDataSize);
        
        //Protect the curl queue
        pthread_mutex_lock(&curlQueueMutex);
        //Push the used curl handle back onto the queue
        curlHandleQueue.push(curlCommandData);
        onQueue++;
        //Unlock the curl queue
        pthread_mutex_unlock(&curlQueueMutex);
        
        return status;
    }
    
    //Logs a user in
    bool PMServer::Login(const char* username, const char* password, bool signInRemember)
    {
        if ( (NULL == username) || (NULL == password) )
            return false;
        
        Json::Value response;
        Json::Value args;
        
        //Set args
        args["sign_in_username_email"] = username;
        args["sign_in_password"] = password;
        args["sign_in_remember"] = signInRemember;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, LOGIN))
            return false;
        
        //Return the login status
        return response["success"].asBool();
    }
    
    //Logs a user out
    bool PMServer::Logout()
    {
        Json::Value response;
        Json::Value args;
        
        //Set args
        args["logout"] = true;
        
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, LOGOUT))
            return false;
        
        //Return the login status
        return response["success"].asBool();
    }
    
    //Registers an email and password
    bool PMServer::Register(const char* email, const char* password)
    {
        if ( (NULL == email) || (NULL == password) )
            return false;
        
        Json::Value response;
        Json::Value args;
        
        //Set args
        args["sign_up_email"] = email;
        args["sign_up_password"] = password;
        
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, REGISTER))
            return false;
        
        return response["success"].asBool();
    }
    
    //Updates a profile based on the provided userdata
    bool PMServer::UpdateProfile(const UserData& userData)
    {
        Json::Value response;
        Json::Value args;
        
        //Set args
        if (userData.plateId != "")
            args["plate_id"] = userData.plateId.c_str();
        if (userData.firstName != "")
            args["fname"] = userData.firstName.c_str();
        if (userData.lastName != "")
            args["lname"] = userData.lastName.c_str();
        if (userData.birthday != "")
            args["birthday"] = userData.birthday.c_str();
        if (userData.gender != "")
            args["gender"] = userData.gender.c_str();
        if (userData.profilePicUrl != "")
            args["profile_pic_url"] = userData.profilePicUrl.c_str();
        
        args["interested_in"] = "Unknown";
        
        if ("" != userData.userId)
            args["account_id"] = userData.userId.c_str();
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, UPDATEPROFILE))
            return false;
        
        return response["success"].asBool();        
    }
    
    //Changes a user password
    bool PMServer::ChangePassword(const char* newPassword)
    {
        if (NULL == newPassword)
            return false;
        
        Json::Value response;
        Json::Value args;
        
        //Set args
        args["password_new"] = newPassword;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, CHANGEPASSWORD))
            return false;
        
        return response["success"].asBool();        
    }
    
    //Gets plate data for the specified plate number and state
    bool PMServer::GetPlate(const char* plate, const char* state, PlateData& plateData)
    {
        if ( (NULL == plate) || (NULL == state) )
            return false;
        
        Json::Value response;
        Json::Value args;
        
        args["plate"] = plate;
        args["state"] = state;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, GETPLATEDATA))
            return false;
        
        //Check that the command was executed successfully
        if (!response["success"].asBool())
            return false;
        
        //Convert the json data into useful plate data
        return serverHelper.createPlateData(response, plateData);
    }
    
    //Gets plate data for the specified plate id
    bool PMServer::GetPlate(const char* plateId, PlateData& plateData)
    {
        Json::Value response;
        Json::Value args;
        
        //No plate Id means default plate
        if (NULL != plateId)
            args["plate_id"] = plateId;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, GETPLATEDATA))
            return false;
        
        //Check that the command was executed successfully
        if (!response["success"].asBool())
            return false;    
        
        //Convert the json data into useful plate data
        return serverHelper.createPlateData(response, plateData);
    }    
    
    //Gets user information for the specified user id
    bool PMServer::GetUserInfo(UserData& userData, const char* userId)
    {
        Json::Value response;
        Json::Value args;
        
        //Add the user ID argument if it is not the default
        if (NULL != userId)
            args["account_id"] = userId;
        
        //Send the command
        if (!sendCommandRequest(args, response, GETUSERINFO))
            return false;
        
        //Check that the command was executed successfully
        if (!response["success"].asBool())
            return false;
        
        //Use the helper to create the user data
        return serverHelper.createUserData(response, userData);
    }
    
    //Updates a plates location
    bool PMServer::UpdateLocation(const char* plateId, const char* latitude, const char* longitude)
    {
        if ( (NULL == plateId) || (NULL == latitude) || (NULL == longitude) )
            return false;
        
        Json::Value response;
        Json::Value args;
        
        //Set args
        args["plate_id"] = plateId;
        args["lat"] = latitude;
        args["lon"] = longitude;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, UPDATELOCATION))
            return false;
        
        return response["success"].asBool();         
    }
    
    //Gets the wall data (posts) for the specified plate id
    bool PMServer::GetWallData(WallData& wallData, const char* plateId)
    {
        Json::Value response;
        Json::Value args;
        
        //Set the plate ID to get wall data for
        if (NULL != plateId)
            args["plate_id"] = plateId;
        
        //Send the command
        if (!sendCommandRequest(args, response, GETWALLDATA))
            return false;
        
        //Check that the command was executed successfully
        const Json::Value& success = response["success"];
        if (success.isNull() || !success.asBool())
            return false;
        
        //Use the helper to create the wall data
        return serverHelper.createWallData(response, wallData);
    }
    
    //Posts to the wall of the specified plate id
    //A parent id of 0 indicates post to wall
    //A non-zero parent id indicates a comment where the parent id is the parent post id 
    bool PMServer::AddPost(const char* plateId, const char* content, const char* parentId, const char* imgUrl, const char* videoUrl, const char* videoThumbnailUrl)
    {
        if ( (NULL == plateId) || (NULL == content) || (NULL == parentId) )
            return false;
        
        Json::Value response;
        Json::Value args;
        
        //Set args
        args["plate_id"] = plateId;
        args["content"] = content;
        args["parent_id"] = parentId;
        
        if (NULL != imgUrl)
            args["img_url"] = imgUrl;
        
        if (NULL != videoUrl)
            args["vid_url"] = videoUrl;
        
        if (NULL != videoThumbnailUrl)
            args["vid_thumb_url"] = videoThumbnailUrl;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, ADDPOST))
            return false;
        
        return response["success"].asBool();         
    }
    
    //Deletes a post with the specified post id
    bool PMServer::DeletePost(const char* postId)
    {
        if (NULL == postId)
            return false;
        
        Json::Value response;
        Json::Value args;
        
        //Set args
        args["wall_post_id"] = postId;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, DELETEPOST))
            return false;
        
        return response["success"].asBool();         
    }
    
    //Associates a plate id with with the current user
    bool PMServer::AssociatePlate(const char* plateId)
    {
        if (NULL == plateId)
            return false;
        
        Json::Value response;
        Json::Value args;
        
        //Set args
        args["plate_id"] = plateId;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, ASSOCIATEPLATE))
            return false;
        
        return response["success"].asBool();          
    }
    
    //Rates a post (post id) with the specified rating
    //The rating is a string representing a decimal number of 0-5 in .5 increments
    bool PMServer::RatePost(const char* postId, const char* rating)
    {
        if ( (NULL == postId) || (NULL == rating) )
            return false;
        
        Json::Value response;
        Json::Value args;
        
        //Set args
        args["wall_post_id"] = postId;
        args["rating"] = rating;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, RATEPOST))
            return false;
        
        return response["success"].asBool();          
    }
    
    //Returns all the five star rating done on the specified post id
    bool PMServer::GetFiveStarRatings(const char* postId, FiveStarVector& fiveStarVector)
    {
        if (NULL == postId)
            return false;
        
        Json::Value response;
        Json::Value args;
        
        //Set args
        args["wall_post_id"] = postId;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, FIVESTARGET))
            return false;
        
        if (!response["success"].asBool())
            return false;
        
        return serverHelper.createFiveStarData(response, fiveStarVector);        
    }
    
    //Requests a favorite (account id) for the current user profile
    bool PMServer::AddFavorite(const char* accountId)
    {
        if (NULL == accountId)
            return false;
        
        Json::Value response;
        Json::Value args;
        
        //Set args
        args["target_id"] = accountId;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, FAVORITESADD))
            return false;
        
        return response["success"].asBool();         
    }
    
    //Removed a favorite (account id) from the current user profile
    bool PMServer::RemoveFavorite(const char* accountId)
    {
        if (NULL == accountId)
            return false;
        
        Json::Value response;
        Json::Value args;
        
        //Set args
        args["target_id"] = accountId;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, FAVORITESREMOVE))
            return false;
        
        return response["success"].asBool();          
    }
    
    //Gets all favorites of the specified account id
    bool PMServer::GetFavorites(const char* accountId, FavoritesVector& favoritesVector)
    {
        Json::Value response;
        Json::Value args;
        
        //Set args
        if (NULL != accountId)
            args["account_id"] = accountId;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, FAVORITEGET))
            return false;
        
        if (!response["success"].asBool())
            return false;
        
        return serverHelper.createFavoritesData(response, favoritesVector);          
    }
    
    //Gets any favorite requests which have not been accepted
    bool PMServer::GetPendingFavoriteRequests(const char* accountId, FavoritesVector& favoritesVector)
    {
        Json::Value response;
        Json::Value args;
        
        //Set args
        if (NULL != accountId)
            args["account_id"] = accountId;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, FAVORITEGETPENDING))
            return false;
        
        if (!response["success"].asBool())
            return false;
        
        return serverHelper.createFavoritesData(response, favoritesVector);          
    }
    
    //Confirms a friend request
    bool PMServer::ConfirmFriendRequest(const char* accountId)
    {
        if (NULL == accountId)
            return false;
        
        Json::Value response;
        Json::Value args;
        
        //Set args
        args["target_id"] = accountId;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, FAVORITECONFIRM))
            return false;
        
        return response["success"].asBool();         
    }
    
    //Checks if an account (accountId) is currently a favorite or pending a request
    bool PMServer::CheckFavoriteStatus(const char* accountId, bool& isFavorite, bool& isPending)
    {
        if (NULL == accountId)
            return false;
        
        Json::Value response;
        Json::Value args;
        
        //Set args
        args["favorite_id"] = accountId;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, FAVORITECHECK))
            return false;
        
        isPending = response["data"]["is_pending"].asBool();
        isFavorite = response["data"]["is_favorite"].asBool();
        
        return response["success"].asBool();        
    }
    
    //Follows the specified plate id
    bool PMServer::AddFollower(const char* plateId)
    {
        if (NULL == plateId)
            return false;
        
        Json::Value response;
        Json::Value args;
        
        //Set args
        args["plate_id"] = plateId;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, FOLLOWERADD))
            return false;
        
        return response["success"].asBool();         
    }
    
    //Removes the follow from the specified plate id
    bool PMServer::RemoveFollower(const char* plateId)
    {
        if (NULL == plateId)
            return false;
        
        Json::Value response;
        Json::Value args;
        
        //Set args
        args["plate_id"] = plateId;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, FOLLOWERREMOVE))
            return false;
        
        return response["success"].asBool();         
    }
    
    //Returns all followers for the specified account id
    bool PMServer::GetFollowers(const char* accountId, FollowersVector& followersVector)
    {
        Json::Value response;
        Json::Value args;
        
        //Set args
        if (NULL != accountId)
            args["account_id"] = accountId;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, FOLLOWERGET))
            return false;
        
        if (!response["success"].asBool())
            return false;
        
        return serverHelper.createFollowersData(response, followersVector);          
    }
    
    //Uploads a file to the server
    bool PMServer::UploadFile(const char* fileName, std::string& url, unsigned int requestId)
    {
        Json::Value response;
        Json::Value args;
        
        if (!sendCommandRequest(args, response, FILEUPLOAD, fileName, requestId))
            return false;
        
        if (!response["success"].asBool())
            return false;
        
        url = response["data"].asString();
        
        return true;
    }
    
    //Checks the follow status of a plate
    bool PMServer::CheckFollowingStatus(const char* plateId)
    {
        if (NULL == plateId)
            return false;
        
        Json::Value response;
        Json::Value args;
        
        //Set args
        args["plate_id"] = plateId;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, FOLLOWERCHECK))
            return false;
        
        if (!response["success"].asBool())
            return false;
        
        return response["data"]["is_following"].asBool();      
    }
    
    //Uploads an image and sets it as the primary profile pic
    bool PMServer::UploadProfilePic(const char* fileName, unsigned int requestId)
    {
        Json::Value response;
        Json::Value args;
        
        if (!sendCommandRequest(args, response, FILEUPLOAD, fileName, requestId))
            return false;
        
        if (!response["success"].asBool())
            return false;
        
        std::string url = response["data"].asString();
        
        return SetProfilePic(url.c_str());           
    }
    
    //Uploads an image to the users gallery
    bool PMServer::UploadGalleryImage(const char* plateId, const char* fileName, unsigned int requestId, std::string& url)
    {
        Json::Value response;
        Json::Value args;
        
        if (!sendCommandRequest(args, response, FILEUPLOAD, fileName, requestId))
            return false;
        
        if (!response["success"].asBool())
            return false;
        
        url = response["data"].asString();
        
        args["plate_id"] = plateId;
        args["url"] = url.c_str();
        args["media_type"] = "image";
        
        if (!sendCommandRequest(args, response, GALLERYIMAGESET))
            return false;
        
        return response["success"].asBool();        
    }
    
    //Uploads a video to the users gallery
    bool PMServer::UploadGalleryVideo(const char* plateId, const char* fileName, unsigned int requestId, const char* thumbnail_url, std::string& url)
    {
        Json::Value response;
        Json::Value args;
        
        if (!sendCommandRequest(args, response, FILEUPLOAD, fileName, requestId))
            return false;
        
        if (!response["success"].asBool())
            return false;
        
        url = response["data"].asString();
        
        args["plate_id"] = plateId;
        args["url"] = url.c_str();
        args["media_type"] = "video";
        if (NULL != thumbnail_url)
            args["thumb_url"] = thumbnail_url;
        
        if (!sendCommandRequest(args, response, GALLERYIMAGESET))
            return false;
        
        return response["success"].asBool();        
    }
    
    //Sets the profile pic url
    bool PMServer::SetProfilePic(const char* url)
    {
        Json::Value response;
        Json::Value args;
        
        //Set args
        args["profile_pic_url"] = url;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, UPDATEPROFILE))
            return false;
        
        return response["success"].asBool();         
    }
    
    //Gets all images currently in the gallery
    bool PMServer::GetGalleryImages(const char* plateId, GalleryImageVector& images)
    {
        Json::Value response;
        Json::Value args;
        
        //Set args
        if (NULL != plateId)
            args["plate_id"] = plateId;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, GALLERYGETIMAGES))
            return false;
        
        if (!response["success"].asBool())
            return false;
        
        return serverHelper.createGalleryData(response, images);         
    }
    
    //Generic file download, a full url needs to be passed
    bool PMServer::DownloadFile(const char* url, const char*& data, size_t& dataSize, unsigned int requestId)
    {
        Json::Value response;
        Json::Value args;
        
        if (!sendCommandRequest(args, response, FILEDOWNLOAD, url, requestId, (void**)&data, &dataSize))
            return false;
        
        return true;
    }
    
    bool PMServer::GetFeed(WallData& wallData)
    {
        Json::Value response;
        Json::Value args;
        
        //Send the command
        if (!sendCommandRequest(args, response, GETFEED))
            return false;
        
        //Check that the command was executed successfully
        const Json::Value& success = response["success"];
        if (success.isNull() || !success.asBool())
            return false;
        
        //Use the helper to create the wall data
        return serverHelper.createWallData(response, wallData);        
    }
    
    bool PMServer::GetLocalFeed(WallData& wallData)
    {
        Json::Value response;
        Json::Value args;
        
        //Send the command
        if (!sendCommandRequest(args, response, GETLOCALFEED))
            return false;
        
        //Check that the command was executed successfully
        const Json::Value& success = response["success"];
        if (success.isNull() || !success.asBool())
            return false;
        
        //Use the helper to create the wall data
        return serverHelper.createWallData(response, wallData);         
    }
    
    bool PMServer::UpdateToken(const char* accountId, const char* token)
    {
        Json::Value response;
        Json::Value args;
        
        //Set args        
        if (NULL != accountId)
            args["account_id"] = accountId;
        
        args["token"] = token;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, UPDATETOKEN))
            return false;
        
        return response["success"].asBool();          
    }
    
    bool PMServer::GetMessages(MessageMap& messages)
    {
        Json::Value response;
        Json::Value args;
        
        //Send the command
        if (!sendCommandRequest(args, response, GETMESSAGES))
            return false;
        
        //Check that the command was executed successfully
        const Json::Value& success = response["success"];
        if (success.isNull() || !success.asBool())
            return false;
        
        //Use the helper to create the wall data
        return serverHelper.createMessageData(response, messages);           
    }
    
    bool PMServer::GetNotifications(NotificationVector& notifications)
    {
        Json::Value response;
        Json::Value args;
        
        //Send the command
        if (!sendCommandRequest(args, response, GETNOTIFICATIONS))
            return false;
        
        //Check that the command was executed successfully
        const Json::Value& success = response["success"];
        if (success.isNull() || !success.asBool())
            return false;
        
        //Use the helper to create the wall data
        return serverHelper.createNotificationData(response, notifications);         
    }
    
    bool PMServer::HideNotification(const char* notificationId)
    {
        Json::Value response;
        Json::Value args;
        
        //Set args        
        if (NULL == notificationId)
            return false;
        
        args["notification_id"] = notificationId;
        
        //If the command send failed then return false
        if (!sendCommandRequest(args, response, HIDENOTIFICATION))
            return false;
        
        return response["success"].asBool();           
    }
    
}