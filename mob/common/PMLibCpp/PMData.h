//
//  PMData.h
//  PMLib
//
//  Created by Kevin Calcote on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef PMLib_PMData_h
#define PMLib_PMData_h

#include <iostream>
#include <vector>
#include <map>

namespace PMLibCpp
{
    struct WallPost;
    struct FavoriteData;
    struct FollowerData;
    struct FiveStarData;
    struct GalleryImageData;
    struct MessageData;
    struct NotificationData;
    
    typedef std::vector<WallPost> PostVector;
    typedef std::vector<FavoriteData> FavoritesVector;
    typedef std::vector<FollowerData> FollowersVector;
    typedef std::vector<FiveStarData> FiveStarVector;
    typedef std::vector<GalleryImageData> GalleryImageVector;
    typedef std::vector<MessageData> MessageDataVector;
    typedef std::map<std::string, MessageDataVector> MessageMap;
    typedef std::vector<NotificationData> NotificationVector;
    
    struct UserData
    {
        std::string userId;
        std::string email;
        std::string firstName;
        std::string lastName;
        std::string plateId;
        std::string profilePicUrl;
        std::string birthday;
        std::string gender;
    };
    
    struct FiveStarData
    {
        std::string ratingId;
        std::string postId;
        std::string accountId;
        std::string rating;
        std::string fname;
        std::string lname;
    };

    struct FavoriteData
    {
        std::string accountId;
        std::string fname;
        std::string lname;
        std::string profilePicUrl;
        std::string primaryPlateId;
        std::string primaryPlateLat;
        std::string primaryPlateLon;
    };
    
    struct FollowerData
    {
        std::string plateId;
        std::string accountId;
        std::string fname;
        std::string lname;
        std::string plateNumber;
        std::string platePicUrl;
    };
    
    struct PlateData
    {
        std::string plateId;
        std::string plate;
        std::string accountId;
        std::string make;
        std::string model;
        std::string color;
        std::string year;
        std::string state;
        std::string access;
        std::string primary;
        std::string latitude;
        std::string longitude;
        std::string platePicUrl;
    };
    
    struct WallPost
    {
        std::string postId;
        std::string plateId;
        std::string accountId;
        std::string content;
        std::string postedon;
        std::string parentId;
        std::string avg_rating;
        std::string num_ratings;
        std::string deletedon;
        std::string profilePicUrl;
        std::string fname;
        std::string lname;
        std::string imgUrl;
        std::string videoUrl;
        std::string videoThumbnailUrl;
        PostVector comments;
    };
    
    struct WallData
    {
        PostVector posts;
    };
    
    struct GalleryImageData
    {
        std::string imageId;
        std::string plateId;
        std::string accountId;
        std::string url;
        std::string thumbnailUrl;
        std::string uploadedOn;
        std::string mediaType;
    };
    
    struct MessageData
    {
        std::string messageId;
        std::string senderId;
        std::string receiverId;
        std::string senderName;
        std::string receiverName;
        std::string content;
        std::string timestamp;
    };
    
    struct NotificationData
    {
        std::string notificationId;
        std::string accountId;
        std::string message;
        std::string type;
        std::string targetId;
        std::string unread;
        std::string show;
        std::string timestamp;
    };
}


#endif
