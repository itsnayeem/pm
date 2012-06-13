//
//  PMServer.h
//  PMLib
//
//  Created by Kevin Calcote on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef PMLib_PMServer_h
#define PMLib_PMServer_h

#include <stdlib.h>
#include <iostream>
#include <queue>
#include "PMServerHelper.h"
#include "pthread.h"

namespace Json
{
    class Value;
}

namespace PMLibCpp
{
    //PMServer is a thread safe C++ API to communicate with the PlateMe server API
    //Multiple requests from seperate threads can be processed simultaneously
    //PMServer is a singleton and should only be used as a singleton
    class PMServer
    {
    public:
        enum ApiCommand
        {
            //Account commands
            LOGIN,
            LOGOUT,
            REGISTER,
            UPDATEPROFILE,
            CHANGEPASSWORD,
            GETUSERINFO,
            //Plate commands
            GETPLATEDATA,
            UPDATELOCATION,
            GETWALLDATA,
            ADDPOST,
            DELETEPOST,
            ASSOCIATEPLATE,
            //Five star commands
            RATEPOST,
            FIVESTARGET,
            //Favorites commands
            FAVORITESADD,
            FAVORITESREMOVE,
            FAVORITEGET,
            FAVORITEGETPENDING,
            FAVORITECONFIRM,
            FAVORITECHECK,
            //Followers commands
            FOLLOWERADD,
            FOLLOWERREMOVE,
            FOLLOWERGET,
            FOLLOWERCHECK,
            //UploadCommands
            FILEUPLOAD,
            //Gallery commands
            GALLERYIMAGESET,
            GALLERYGETIMAGES,
            //Download commands
            FILEDOWNLOAD,
            //Feed commands
            GETFEED,
            GETLOCALFEED,
            UPDATETOKEN,
            //Message commands
            GETMESSAGES,
            SENDMESSAGE,
            //Notification Commands
            GETNOTIFICATIONS,
            HIDENOTIFICATION,
            //Max
            MAX_API_COMMANDS
        };
        
        //Api call type
        enum ApiRequestType
        {
            GET = 1,
            POST,
            UPLOAD,
            DOWNLOAD
        };
        
        struct ProgressStruct
        {
            unsigned int requestId;
            ApiRequestType requestType;
        };
        
        struct CommandResponse 
        {
            char *memory;
            size_t dataSize;
            size_t size;
        };
        
        struct ApiType
        {
            std::string url;
            ApiRequestType requestType;
        };
        
        struct CurlCommandData
        {
            void* curlHandle;
            CommandResponse* commandResponse;
        };
        
        //Progress callback type
        typedef void(*ProgressCallbackType)(double, double, ProgressStruct*);
        
        
    private:
        PMServer();
        ~PMServer();
    public:
        //Helper calls
        static PMServer* getInstance();
        void SetProgressCallback(ProgressCallbackType progressCallback);
        //API calls
        bool Login(const char* username, const char* password, bool signInRemember);
        bool Logout();
        bool GetUserInfo(UserData& userData, const char* userId = NULL);
        bool Register(const char* email, const char* password);
        bool UpdateProfile(const UserData& userData);
        bool ChangePassword(const char* newPassword);
        bool GetPlate(const char*, const char* state, PlateData& plateData);
        bool GetPlate(const char* plateId, PlateData& plateData);        
        bool GetWallData(WallData& wallData, const char* plateId);
        bool UpdateLocation(const char* plateId, const char* latitude, const char* longitude);
        bool AddPost(const char* plateId, const char* content, const char* parentId, const char* imgUrl, const char* videoUrl, const char* videoThumbnailUrl);
        bool DeletePost(const char* postId);
        bool AssociatePlate(const char* plateId);
        bool RatePost(const char* postId, const char* rating);
        bool GetFiveStarRatings(const char* postId, FiveStarVector& fiveStarVector);
        bool AddFavorite(const char* accountId);
        bool RemoveFavorite(const char* accountId);
        bool GetFavorites(const char* accountId, FavoritesVector& favoritesVector);
        bool GetPendingFavoriteRequests(const char* accountId, FavoritesVector& favoritesVector);
        bool ConfirmFriendRequest(const char* accountId);
        bool CheckFavoriteStatus(const char* accountId, bool& isFavorite, bool& isPending);
        bool AddFollower(const char* plateId);
        bool RemoveFollower(const char* plateId);
        bool GetFollowers(const char* accountId, FollowersVector& followersVector);
        bool UploadFile(const char* fileName, std::string& url, unsigned int requestId);
        bool UploadProfilePic(const char* fileName, unsigned int requestId);
        bool UploadGalleryImage(const char* plateId, const char* fileName, unsigned int requestId, std::string& url);
        bool UploadGalleryVideo(const char* plateId, const char* fileName, unsigned int requestId, const char* thumbnail_url, std::string& url);
        bool SetProfilePic(const char* url);
        bool CheckFollowingStatus(const char* plateId);
        bool GetGalleryImages(const char* plateId, GalleryImageVector& images);
        bool DownloadFile(const char* url, const char*& data, size_t& dataSize, unsigned int requestId);
        bool GetFeed(WallData& wallData);
        bool GetLocalFeed(WallData& wallData);
        bool UpdateToken(const char* accountId, const char* token);
        bool GetMessages(MessageMap& messages);
        bool GetNotifications(NotificationVector& notifications);
        bool HideNotification(const char* notificationId);
        //Non-API call
        static const std::string& getBaseUrl();
    
    private:
        //Private static vars
        static PMServer* instance;
        static ApiType apiCommands[MAX_API_COMMANDS];
        static const std::string baseApiUrl;
        static void* shareHandle;
        static pthread_mutex_t curlQueueMutex;
        static pthread_mutex_t progressCallbackMutex;
        static pthread_mutex_t cookieSharingMutex;
    
        //Private instance member vars
        PMServerHelper serverHelper;
        ProgressCallbackType pCallback;
        std::queue<CurlCommandData> curlHandleQueue;
        
        //Private static methods
        static size_t writeMemoryCallback(void *contents, size_t size, size_t nmemb, void *userp);
        static int progress(void *p, double dltotal, double dlnow, double ultotal, double ulnow);
        static void shareLock(void* handle, unsigned int data, unsigned int access, void *userptr);
        static void shareUnlock(void* handle, unsigned int data, void *userptr);
        
        //Private instance methods  
        bool sendCommandRequest(const Json::Value& command, Json::Value& response, ApiCommand commandType, const char* fileName = NULL, unsigned int requestId = 0, void** rawData = NULL, size_t* rawDataSize = NULL);
        bool executeCommandRequest(CurlCommandData& curlCommandData, const Json::Value& command, Json::Value& response, ApiCommand commandType, const char* fileName, unsigned int requestId, void** rawData, size_t* rawDataSize);
        CurlCommandData createCurlHandle();
    };
};

#endif
