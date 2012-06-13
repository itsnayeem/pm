//
//  PMServerHelper.cpp
//  PMLib
//
//  Created by Kevin Calcote on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "PMServerHelper.h"
#include <iostream>
#include <json/json.h>
#include "PMServer.h"


namespace PMLibCpp 
{
    std::string PMServerHelper::imageLocation = "/board/uploads/";
    
    PMServerHelper::PMServerHelper()
    {
        
    }
    
    PMServerHelper::~PMServerHelper()
    {
        
    }

    bool PMServerHelper::createNotificationData(const Json::Value &jsonData, NotificationVector &notificationVector)
    {
        const Json::Value* val = NULL;
        //Get the necessary values
        const Json::Value& notifications = jsonData["data"];
        
        //Popuate the favorites data
        //Iterator to loop through the posts
        Json::ValueConstIterator notifItr = notifications.begin();
        
        //Loop through the posts and create post data
        while (notifications.end() != notifItr)
        {
            PMLibCpp::NotificationData notifData;
            
            val = &(*notifItr)["id"];
            if(!val->isNull())
                notifData.notificationId = val->asCString();
            
            val = &(*notifItr)["account_id"];
            if(!val->isNull())
                notifData.accountId = val->asCString();
            
            val = &(*notifItr)["message"];
            if(!val->isNull())
                notifData.message = val->asCString();
            
            val = &(*notifItr)["type"];
            if(!val->isNull())
                notifData.type = val->asCString();
            
            val = &(*notifItr)["target_id"];
            if(!val->isNull())
                notifData.targetId = val->asCString();
            
            val = &(*notifItr)["unread"];
            if(!val->isNull())
                notifData.unread = val->asCString();
            
            val = &(*notifItr)["show"];
            if(!val->isNull())
                notifData.show = val->asCString();
            
            val = &(*notifItr)["timestamp"];
            if(!val->isNull())
                notifData.timestamp = val->asCString();
            
            notificationVector.push_back(notifData);
            
            notifItr++;
        }
        
        return true;
    }
    
    bool PMServerHelper::createMessageData(const Json::Value& jsonData, MessageMap& messageMap)
    {
        //Get and copy the user data to the out parameter
        const Json::Value* val = NULL;
        const Json::Value& data = jsonData["data"]; 
        const Json::Value& accounts = data["accounts"];
        std::string senderName = "";
        std::string receiverName = "";
        
        Json::ValueConstIterator accountsItr = accounts.begin();
        
        //Loop through all accounts provided
        while (accounts.end() != accountsItr)
        {
            const char* accountId = NULL;
            
            val =  &(*accountsItr)["id"];
            if (!val->isNull())
                accountId = val->asCString();
            
            //Verify the account Id is valid
            if (NULL != accountId)
            {
                //Get the message array
                val = &data[accountId];
                if (!val->isNull() && val->isArray())
                {
                    Json::ValueConstIterator messageItr = val->begin();
                    MessageDataVector& messages = messageMap[accountId];
                    
                    //Loop through all the messages
                    while(val->end() != messageItr)
                    {
                        MessageData messageData;
                        
                        val = &(*messageItr)["id"];
                        if(!val->isNull())
                            messageData.messageId = val->asCString();
                        
                        val = &(*messageItr)["sender_id"];
                        if(!val->isNull())
                            messageData.senderId = val->asCString();
                        
                        val = &(*messageItr)["receiver_id"];
                        if(!val->isNull())
                            messageData.receiverId = val->asCString();
                        
                        val = &(*messageItr)["content"];
                        if(!val->isNull())
                            messageData.content = val->asCString();
                        
                        val = &(*messageItr)["senton"];
                        if(!val->isNull())
                            messageData.timestamp = val->asCString();
                        
                        //Add the message data to the vector
                        messages.push_back(messageData);
                    }
                }
            }
        }
        
        return true;
    }
    
    bool PMServerHelper::createUserData(const Json::Value &jsonData, UserData &userData)
    {
        //Get and copy the user data to the out parameter
        const Json::Value* val = NULL;
        const Json::Value& data = jsonData["data"];
        
        val = &data["id"];
        if(!val->isNull())
            userData.userId = val->asCString();        
        
        val = &data["email"];
        if(!val->isNull())
            userData.email = val->asCString();
        
        val = &data["fname"];
        if(!val->isNull())        
            userData.firstName = val->asCString();
        
        val = &data["lname"];
        if(!val->isNull())        
            userData.lastName = val->asCString();
        
        val = &data["plate_id"];
        if(!val->isNull())        
            userData.plateId = val->asCString();
        
        val = &data["birthday"];
        if(!val->isNull())        
            userData.birthday = val->asCString();
        
        val = &data["gender"];
        if(!val->isNull())        
            userData.gender = val->asCString();
        
        val = &data["profile_pic_url"];
        if(!val->isNull())        
            userData.profilePicUrl = val->asCString();
        
        return true;
    }
    
    bool PMServerHelper::createPlateData(const Json::Value &jsonData, PMLibCpp::PlateData &plateData)
    {
        //Get the necessary values
        const Json::Value* val = NULL;
        const Json::Value& plate = jsonData["data"];
        
        //Populate the plate data
        if (!plate.isArray())
        {
            val = &plate["id"];
            if(!val->isNull())
                plateData.plateId = val->asCString();
            
            val = &plate["plate"];
            if(!val->isNull())
                plateData.plate = val->asCString();
            
            val = &plate["account_id"];
            if(!val->isNull())
                plateData.accountId = val->asCString();
            
            val = &plate["make"];
            if(!val->isNull())
                plateData.make = val->asCString();
            
            val = &plate["model"];
            if(!val->isNull())
                plateData.model = val->asCString();
            
            val = &plate["color"];
            if(!val->isNull())
                plateData.color = val->asCString();
            
            val = &plate["year"];
            if(!val->isNull())
                plateData.year = val->asCString();
            
            val = &plate["state"];
            if(!val->isNull())
                plateData.state = val->asCString();
            
            val = &plate["access"];
            if(!val->isNull())
                plateData.access = val->asCString();
            
            val = &plate["primary"];
            if(!val->isNull())
                plateData.primary = val->asCString();
            
            val = &plate["lat"];
            if(!val->isNull())
                plateData.latitude = val->asCString();
            
            val = &plate["lon"];
            if(!val->isNull())
                plateData.longitude = val->asCString();
            
            val = &plate["plate_pic_url"];
            if(!val->isNull())        
                plateData.platePicUrl = val->asCString();            
            
            return true;
        }
        else
        {
            return false;
        }
    }
    
    bool PMServerHelper::createFavoritesData(const Json::Value& jsonData, FavoritesVector& favoritesVector)
    {
        const Json::Value* val = NULL;
        //Get the necessary values
        const Json::Value& favorites = jsonData["data"];
        
        //Popuate the favorites data
        //Iterator to loop through the posts
        Json::ValueConstIterator favItr = favorites.begin();
        
        //Loop through the posts and create post data
        while (favorites.end() != favItr)
        {
            PMLibCpp::FavoriteData favData;
            
            val = &(*favItr)["id"];
            if(!val->isNull())
                favData.accountId = val->asCString();
            
            val = &(*favItr)["fname"];
            if(!val->isNull())
                favData.fname = val->asCString();
            
            val = &(*favItr)["lname"];
            if(!val->isNull())
                favData.lname = val->asCString();
            
            val = &(*favItr)["profile_pic_url"];
            if(!val->isNull())
                favData.profilePicUrl = val->asCString();
            
            val = &(*favItr)["lat"];
            if(!val->isNull())
                favData.primaryPlateLat = val->asCString();
            
            val = &(*favItr)["lon"];
            if(!val->isNull())
                favData.primaryPlateLon = val->asCString();
            
            val = &(*favItr)["plate_id"];
            if(!val->isNull())
                favData.primaryPlateId = val->asCString();
            
            favoritesVector.push_back(favData);
            
            favItr++;
        }
        
        return true;        
    }
    
    bool PMServerHelper::createFollowersData(const Json::Value& jsonData, FollowersVector& followersVector)
    {
        const Json::Value* val = NULL;
        //Get the necessary values
        const Json::Value& followers = jsonData["data"];
        
        //Popuate the favorites data
        //Iterator to loop through the posts
        Json::ValueConstIterator followItr = followers.begin();
        
        //Loop through the posts and create post data
        while (followers.end() != followItr)
        {
            PMLibCpp::FollowerData followData;
            
            val = &(*followItr)["plate_id"];
            if(!val->isNull())
                followData.plateId = val->asCString();
            
            val = &(*followItr)["account_id"];
            if(!val->isNull())
                followData.accountId = val->asCString();
            
            val = &(*followItr)["fname"];
            if(!val->isNull())
                followData.fname = val->asCString();
            
            val = &(*followItr)["lname"];
            if(!val->isNull())
                followData.lname = val->asCString();
            
            val = &(*followItr)["plate"];
            if(!val->isNull())
                followData.plateNumber = val->asCString();
            
            val = &(*followItr)["plate_pic_url"];
            if(!val->isNull())
                followData.platePicUrl = val->asCString();
            
            followersVector.push_back(followData);
            
            followItr++;
        }
        
        return true;          
    }
    
    bool PMServerHelper::createFiveStarData(const Json::Value& jsonData, FiveStarVector& fiveStarVector)
    {
        const Json::Value* val = NULL;
        //Get the necessary values
        const Json::Value& fiveStars = jsonData["data"];
        
        //Popuate the favorites data
        //Iterator to loop through the posts
        Json::ValueConstIterator fiveStarItr = fiveStars.begin();
        
        //Loop through the posts and create post data
        while (fiveStars.end() != fiveStarItr)
        {
            PMLibCpp::FiveStarData fiveStarData;
            
            val = &(*fiveStarItr)["id"];
            if(!val->isNull())
                fiveStarData.ratingId = val->asCString();
            
            val = &(*fiveStarItr)["wall_post_id"];
            if(!val->isNull())
                fiveStarData.postId = val->asCString();
            
            val = &(*fiveStarItr)["account_id"];
            if(!val->isNull())
                fiveStarData.accountId = val->asCString();
            
            val = &(*fiveStarItr)["rating"];
            if(!val->isNull())
                fiveStarData.rating = val->asCString();
            
            val = &(*fiveStarItr)["fname"];
            if(!val->isNull())
                fiveStarData.fname = val->asCString();
            
            val = &(*fiveStarItr)["lname"];
            if(!val->isNull())
                fiveStarData.lname = val->asCString();
            
            fiveStarVector.push_back(fiveStarData);
            
            fiveStarItr++;
        }
        
        return true;        
    }
    
    bool PMServerHelper::createWallData(const Json::Value &jsonData, WallData &wallData)
    {
        //Get the necessary values
        const Json::Value& posts = jsonData["data"];
        
        //Populate the posts, this includes comments
        if (!posts.isNull())
            populatePosts(posts, wallData.posts);
        
        return true;
    }
    
    void PMServerHelper::populatePosts(const Json::Value jsonPosts, PostVector& postVector)
    {
        const Json::Value* val = NULL;
        
        //Iterator to loop through the posts
        Json::ValueConstIterator postItr = jsonPosts.begin();
        
        //Loop through the posts and create post data
        while (jsonPosts.end() != postItr)
        {
            //Increase size by one, this is done to prevent
            //the need to allocate multiple posts
            postVector.resize(postVector.size()+1);
            
            //Get the post reference
            WallPost& post = postVector[postVector.size()-1];
            
            //Populate the post
            val = &(*postItr)["id"];
            if (!val->isNull())
                post.postId = val->asCString();
            
            val = &(*postItr)["plate_id"];
            if (!val->isNull())
                post.plateId = val->asCString();
            
            val = &(*postItr)["account_id"];
            if (!val->isNull())
                post.accountId = val->asCString();
            
            val = &(*postItr)["content"];
            if (!val->isNull())
                post.content = val->asCString();
            
            val = &(*postItr)["parent_id"];
            if (!val->isNull())
                post.parentId = val->asCString();
            
            val = &(*postItr)["avg_rating"];
            if (!val->isNull())
                post.avg_rating = val->asCString();
            
            val = &(*postItr)["num_ratings"];
            if (!val->isNull())
                post.num_ratings = val->asCString();
            
            val = &(*postItr)["profile_pic_url"];
            if (!val->isNull())
                post.profilePicUrl = val->asCString();
            
            val = &(*postItr)["fname"];
            if (!val->isNull())
                post.fname = val->asCString();
            
            val = &(*postItr)["lname"];
            if (!val->isNull())
                post.lname = val->asCString();
            
            val = &(*postItr)["postedon"];
            if (!val->isNull())
                post.postedon = val->asCString();
            
            val = &(*postItr)["img_url"];
            if (!val->isNull())
                post.imgUrl = val->asCString();
            
            val = &(*postItr)["vid_url"];
            if (!val->isNull())
                post.videoUrl = val->asCString();
            
            val = &(*postItr)["vid_thumb_url"];
            if (!val->isNull())
                post.videoThumbnailUrl = val->asCString();
            
            //Populate comments if they exist
            val = &(*postItr)["comments"];
            if (!val->isNull())
            {
                populatePosts(*val, post.comments);
            }            
            
            postItr++;
        }
        
    }
    
    bool PMServerHelper::createGalleryData(const Json::Value& jsonData, GalleryImageVector& imagesVector)
    {
        const Json::Value* val = NULL;
        
        //Iterator to loop through image data
        const Json::Value& imageArray = jsonData["image"];
        Json::ValueConstIterator imageItr = imageArray.begin();
        
        //Loop through the posts and create post data
        while (imageArray.end() != imageItr)
        {
            //Increase size by one, this is done to prevent
            //the need to allocate multiple posts
            imagesVector.resize(imagesVector.size()+1);
            
            //Get the image data reference
            GalleryImageData& imageData = imagesVector[imagesVector.size()-1];
            
            //Populate the image data
            val = &(*imageItr)["id"];
            if (!val->isNull())
                imageData.imageId = val->asCString();
            
            val = &(*imageItr)["plate_id"];
            if (!val->isNull())
                imageData.plateId = val->asCString();
            
            val = &(*imageItr)["account_id"];
            if (!val->isNull())
                imageData.accountId = val->asCString();
            
            val = &(*imageItr)["url"];
            if (!val->isNull())
                imageData.url = val->asCString();
            
            val = &(*imageItr)["thumb_url"];
            if (!val->isNull())
                imageData.thumbnailUrl = val->asCString();
            
            val = &(*imageItr)["media_type"];
            if (!val->isNull())
                imageData.mediaType = val->asCString();
            
            val = &(*imageItr)["uploadedon"];
            if (!val->isNull())
                imageData.uploadedOn = val->asCString();
            
            imageItr++;
        }
        
        return true;
    }
}