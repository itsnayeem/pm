//
//  PMServerHelper.h
//  PMLib
//
//  Created by Kevin Calcote on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef PMLib_PMServerHelper_h
#define PMLib_PMServerHelper_h

#include "PMData.h"

namespace Json
{
    class Value;
}


namespace PMLibCpp
{
    class PMServerHelper
    {
    public:
        PMServerHelper();
        ~PMServerHelper();
        bool createUserData(const Json::Value& jsonData, UserData& userData);
        bool createPlateData(const Json::Value& jsonData, PlateData& plateData);
        bool createWallData(const Json::Value& jsonData, WallData& wallData);
        bool createFavoritesData(const Json::Value& jsonData, FavoritesVector& favoritesVector);
        bool createFollowersData(const Json::Value& jsonData, FollowersVector& followersVector);
        bool createFiveStarData(const Json::Value& jsonData, FiveStarVector& fiveStarVector);
        bool createGalleryData(const Json::Value& jsonData, GalleryImageVector& imagesVector);
        bool createMessageData(const Json::Value& jsonData, MessageMap& messageMap);
        bool createNotificationData(const Json::Value &jsonData, NotificationVector&notificationVector);
    
    private:
        void populatePosts(const Json::Value jsonPosts, PostVector& postVector);
        
    private:
        static std::string imageLocation;
    };
};

#endif
