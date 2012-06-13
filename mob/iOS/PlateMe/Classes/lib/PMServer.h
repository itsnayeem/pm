//
//  PMServer.h
//  PlateMe
//
//  Created by Kevin Calcote on 1/18/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMUserData.h"
#import "PMWallData.h"
#import "PMPlateData.h"

@interface PMServer : NSObject
{
    struct FavoriteStatus
    {
        bool isFavorite;
        bool isPending;
    };
    @private
}

+(PMServer*) sharedInstance;

-(bool) Login:(NSString *)username :(NSString *)password :(BOOL)keepLoggedIn;
-(bool) Logout;
-(bool) Register:(NSString*)email :(NSString*)password;
-(PMPlateData*) GetPlate:(NSString*)plate :(NSString*)state;
-(PMPlateData*) GetPlate:(NSString*)plateId;
-(PMPlateData*) GetPlate;
-(PMUserData*) GetUserInfo: (NSString*)userId;
-(PMUserData*) GetUserInfo;
-(PMWallData*) GetWallData:(NSString*)plateId;
-(PMWallData*) GetWallData;
-(bool) AssociatePlate:(NSString*)plateId;
-(bool) AddPost:(NSString*)plateId :(NSString*)content: (NSString*)imgUrl :(NSString*)videoUrl :(NSString*)videoThumbnailUrl;
-(bool) AddPost:(NSString*)plateId :(NSString*)content :(NSString*)parentId: (NSString*)imgUrl :(NSString*)videoUrl :(NSString*)videoThumbnailUrl;
-(bool) DeletePost:(NSString*)postId;
-(bool) UpdateProfile:(PMUserData*)userData;
-(bool) RatePost:(NSString*)postId :(NSString*)rating;
-(NSMutableArray*) GetFiveStarRatings:(NSString*)postId;
-(bool) AddFavorite:(NSString*)accountId;
-(bool) RemoveFavorite:(NSString*)accountId;
-(NSMutableArray*) GetFavorites:(NSString*)accountId;
-(NSMutableArray*) GetFavorites;
-(NSMutableArray*) GetPendingFavorites:(NSString*)accountId;
-(NSMutableArray*) GetPendingFavorites;
-(bool) ConfirmFavoriteRequest:(NSString*)accountId;
-(struct FavoriteStatus) CheckFavoriteStatus:(NSString*)accountId;
-(bool) UpdateLocation:(NSString*)plateId :(NSString*)Latitude :(NSString*)Longitude;
-(NSString*) UploadImage:(NSString*)filePath :(NSInteger)requestId;
-(bool) AddFollower:(NSString*)plateId;
-(bool) AddFollower;
-(bool) RemoveFollower:(NSString*)plateId;
-(NSMutableArray*) GetFollowers:(NSString*)accountId;
-(NSMutableArray*) GetFollowers;
-(bool) CheckFollowing:(NSString*)plateId;
-(NSMutableArray*) GetGalleryImages:(NSString*)plateId;
-(UIImage*) DownloadImage:(NSString*)url :(NSInteger)requestId;
-(NSString*) UploadGalleryImage:(NSString*)plateId :(NSString*)filePath :(NSInteger)requestId;
-(NSString*) UploadGalleryVideo:(NSString*)plateId :(NSString*)filePath :(NSInteger)requestId :(NSString*)thumbnail_url;
-(PMWallData*) GetFeed;
-(PMWallData*) GetLocalFeed;
-(bool) UpdateToken:(NSString*)token;
-(NSMutableArray*) GetNotifications;
-(bool) HideNotification:(NSString*)notificationId;

@end
