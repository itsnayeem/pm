//
//  PMServer.m
//  PlateMe
//
//  Created by Kevin Calcote on 1/18/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#include <PMLib/PMLib.h>
#import "PMServer.h"
#import "PMLoadingView.h"
#import "PMNotificationData.h"

void progressCallback(double upPercent, double downPercent, PMLibCpp::PMServer::ProgressStruct* progressData);


//Extension to have a private function
@interface PMServer()

-(PMUserData*) userDataFromCppStruct:(const PMLibCpp::UserData&)cppUserData;
-(PMPlateData*) plateDataFromCppStruct:(const PMLibCpp::PlateData&)cppPlateData;
-(PMWallData*) wallDataFromCppStruct:(const PMLibCpp::WallData&)cppWallData;
- (PMPostData*) fillPost:(PMPostData*)post :(const PMLibCpp::WallPost&)cppPost;
-(NSMutableArray*) favoritesFromCpp:(const PMLibCpp::FavoritesVector&) cppFavoritesVector;
-(NSMutableArray*) ratingsFromCpp:(const PMLibCpp::FiveStarVector&) cppRatingsVector;
-(NSMutableArray*) followersFromCpp:(const PMLibCpp::FollowersVector&) cppFollwersVector;
-(NSMutableArray*) galleryFromCpp:(const PMLibCpp::GalleryImageVector&) cppImagesVector;
-(NSMutableArray*) notificationsFromCpp:(const PMLibCpp::NotificationVector&) cppNotificationVector;
@end


@implementation PMServer

- (id)init
{
    self = [super init];
    if (self)
    {
        PMLibCpp::PMServer::getInstance()->SetProgressCallback(progressCallback);
    }
    
    return self;
}

+(PMServer*) sharedInstance
{
    static PMServer *instance = nil;
    
    if (nil == instance)
    {
        instance = [[PMServer alloc] init];
    }
    
    return instance;
}

-(bool) Login:(NSString *)username :(NSString *)password :(BOOL)keepLoggedIn
{
    PMLibCpp::PMServer* pmServer = PMLibCpp::PMServer::getInstance();

    bool loginStatus = pmServer->Login(username.UTF8String, password.UTF8String, keepLoggedIn);    
    
    return loginStatus;
}

-(bool) Logout
{
    return PMLibCpp::PMServer::getInstance()->Logout();
}

-(PMPlateData*) GetPlate:(NSString*)plate :(NSString*)state
{
    PMLibCpp::PlateData cppPlateData;
    PMPlateData *plateData = nil;
    
    if (PMLibCpp::PMServer::getInstance()->GetPlate(plate.UTF8String, state.UTF8String, cppPlateData))
    {
         plateData = [self plateDataFromCppStruct:cppPlateData];
    }
    
    return plateData;
}

-(PMPlateData*) GetPlate:(NSString*)plateId
{
    PMLibCpp::PlateData cppPlateData;
    PMPlateData *plateData = nil;
    
    if (PMLibCpp::PMServer::getInstance()->GetPlate(plateId.UTF8String, cppPlateData))
    {
        plateData = [self plateDataFromCppStruct:cppPlateData];
    }
    
    return plateData;
}

-(PMPlateData*) GetPlate
{
    return [self GetPlate:nil];
}

-(PMUserData*) GetUserInfo: (NSString*)userId
{
    PMLibCpp::UserData cppUserData;
    PMUserData *userData = nil;
    
    if (PMLibCpp::PMServer::getInstance()->GetUserInfo(cppUserData, userId.UTF8String))
    {
        userData = [self userDataFromCppStruct:cppUserData];
    }
    
    return userData;
}

-(PMUserData*) GetUserInfo
{
    return [self GetUserInfo:nil];
}

-(PMWallData*) GetWallData:(NSString*)plateId
{
    PMLibCpp::WallData cppWallData;
    PMWallData *wallData = nil;
    
    if (PMLibCpp::PMServer::getInstance()->GetWallData(cppWallData, plateId.UTF8String))
    {
        wallData = [self wallDataFromCppStruct:cppWallData];
    }
    
    return wallData;
}

-(PMWallData*) GetWallData
{
    return [self GetWallData:nil];
}

-(bool) AssociatePlate:(NSString *)plateId
{
    return PMLibCpp::PMServer::getInstance()->AssociatePlate(plateId.UTF8String);
}

-(bool)AddPost:(NSString *)plateId :(NSString *)content: (NSString*)imgUrl :(NSString*)videoUrl :(NSString*)videoThumbnailUrl
{
    return [self AddPost:plateId :content :@"0" :imgUrl :videoUrl :videoThumbnailUrl];
}

-(bool) AddPost:(NSString *)plateId :(NSString *)content :(NSString *)parentId: (NSString*)imgUrl :(NSString*)videoUrl :(NSString*)videoThumbnailUrl
{
    return PMLibCpp::PMServer::getInstance()->AddPost(plateId.UTF8String, content.UTF8String, parentId.UTF8String, imgUrl.UTF8String, videoUrl.UTF8String, videoThumbnailUrl.UTF8String);
}

-(bool) DeletePost:(NSString*)postId
{
    return PMLibCpp::PMServer::getInstance()->DeletePost(postId.UTF8String);
}

-(bool) Register:(NSString*)email :(NSString*)password
{
    return PMLibCpp::PMServer::getInstance()->Register(email.UTF8String, password.UTF8String);
}

-(bool) UpdateProfile:(PMUserData*)userData
{
    PMLibCpp::UserData cppUserData;
    
    //Fill cpp struct with user data
    cppUserData.firstName = userData.firstName.UTF8String;
    cppUserData.lastName = userData.lastName.UTF8String;
    cppUserData.profilePicUrl = userData.profilePicUrl.UTF8String;
    
    return PMLibCpp::PMServer::getInstance()->UpdateProfile(cppUserData);
}

-(bool) RatePost:(NSString*)postId :(NSString*)rating
{
    return PMLibCpp::PMServer::getInstance()->RatePost(postId.UTF8String, rating.UTF8String);
}

-(bool) AddFavorite:(NSString*)accountId
{
    return PMLibCpp::PMServer::getInstance()->AddFavorite(accountId.UTF8String);
}

-(bool) RemoveFavorite:(NSString*)accountId
{
    return PMLibCpp::PMServer::getInstance()->RemoveFavorite(accountId.UTF8String);
}

-(NSMutableArray*) GetFavorites:(NSString*)accountId
{
    PMLibCpp::FavoritesVector cppFavories;
    NSMutableArray *favorites = nil;
    
    if (PMLibCpp::PMServer::getInstance()->GetFavorites(accountId.UTF8String, cppFavories))
    {
         favorites = [self favoritesFromCpp:cppFavories];
    }
    
    return favorites;
}

-(NSMutableArray*) GetFavorites
{
    return [self GetFavorites:nil];
}

-(NSMutableArray*) GetPendingFavorites:(NSString*)accountId
{
    PMLibCpp::FavoritesVector cppFavories;
    NSMutableArray *favorites = nil;
    
    if (PMLibCpp::PMServer::getInstance()->GetPendingFavoriteRequests(accountId.UTF8String, cppFavories))
    {
        favorites = [self favoritesFromCpp:cppFavories];
    }
    
    return favorites;
}

-(NSMutableArray*) GetPendingFavorites
{
    return [self GetPendingFavorites:nil];
}

-(bool) ConfirmFavoriteRequest:(NSString*)accountId
{
    return PMLibCpp::PMServer::getInstance()->ConfirmFriendRequest(accountId.UTF8String);
}

-(struct FavoriteStatus) CheckFavoriteStatus:(NSString*)accountId
{
    struct FavoriteStatus favStatus = {false, false};
    
    PMLibCpp::PMServer::getInstance()->CheckFavoriteStatus(accountId.UTF8String, favStatus.isFavorite, favStatus.isPending);
    
    return favStatus;
}

-(bool) UpdateLocation:(NSString*)plateId :(NSString*)Latitude :(NSString*)Longitude
{
    return PMLibCpp::PMServer::getInstance()->UpdateLocation(plateId.UTF8String, Latitude.UTF8String, Longitude.UTF8String);
}

-(NSMutableArray*) GetFiveStarRatings:(NSString*)postId
{
    PMLibCpp::FiveStarVector cppRatings;
    NSMutableArray *ratings = nil;
    
    if (PMLibCpp::PMServer::getInstance()->GetFiveStarRatings(postId.UTF8String, cppRatings))
    {
        ratings = [self ratingsFromCpp:cppRatings];
    }
    
    return ratings;    
}

-(NSString*) UploadImage:(NSString*)filePath :(NSInteger)requestId
{
    std::string url;
    NSString *returnUrl = nil;
    
    if (PMLibCpp::PMServer::getInstance()->UploadFile(filePath.UTF8String, url, requestId))
    {
        returnUrl = [[NSString stringWithUTF8String:url.c_str()] retain];
    }
    
    return returnUrl;
}

-(bool) AddFollower:(NSString*)plateId
{
    return PMLibCpp::PMServer::getInstance()->AddFollower(plateId.UTF8String);
}

-(bool) AddFollower
{
    return [self AddFollower:nil];
}

-(bool) RemoveFollower:(NSString*)plateId
{
    return PMLibCpp::PMServer::getInstance()->RemoveFollower(plateId.UTF8String);
}

-(NSMutableArray*) GetFollowers:(NSString*)accountId
{
    PMLibCpp::FollowersVector cppFollowers;
    NSMutableArray *followers = nil;
    
    if (PMLibCpp::PMServer::getInstance()->GetFollowers(accountId.UTF8String, cppFollowers))
    {
        followers = [self followersFromCpp:cppFollowers];
    }
    
    return followers;
}

-(NSMutableArray*) GetFollowers
{
    return [self GetFollowers:nil];
}

-(bool) CheckFollowing:(NSString*)plateId
{
    return PMLibCpp::PMServer::getInstance()->CheckFollowingStatus(plateId.UTF8String);
}

-(NSMutableArray*) GetGalleryImages:(NSString*)plateId
{
    PMLibCpp::GalleryImageVector cppImages;
    NSMutableArray *images = nil;
    
    if (PMLibCpp::PMServer::getInstance()->GetGalleryImages(plateId.UTF8String, cppImages))
    {
        images = [self galleryFromCpp:cppImages];
    }
    
    return images;
}

-(UIImage*) DownloadImage:(NSString*)url :(NSInteger)requestId
{
    const char* imageData = 0;
    size_t imageDataSize = 0;
    UIImage *image = nil;
    
    // This creates a string with the path to the app's Documents Directory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *parts = [url componentsSeparatedByString:@"/"];
    NSString *filename = [parts objectAtIndex:[parts count]-1];
    
    // This is where you would select the file name for the image you want to save.
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, filename];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
    
    if (!fileExists)
    {
        if (PMLibCpp::PMServer::getInstance()->DownloadFile(url.UTF8String, imageData, imageDataSize, requestId))
        {
            NSData *data = [NSData dataWithBytes:(const void*)imageData length:imageDataSize];
            
            // This actually creates the image at the file path specified, with the image's NSData.
            [[NSFileManager defaultManager] createFileAtPath:imagePath contents:data attributes:nil];
            
            image = [[[UIImage alloc] initWithData:data] autorelease];
            delete imageData;
        }
    }
    else
    {
        NSData *data = [NSData dataWithContentsOfFile:imagePath]; 
        image = [[[UIImage alloc] initWithData:data] autorelease];
        delete imageData;
    }
    
    return image;
}

-(NSString*) UploadGalleryImage:(NSString*)plateId :(NSString*)filePath :(NSInteger)requestId
{
    std::string cppUrl = "";
    NSString *retUrl = nil;
    
    if (PMLibCpp::PMServer::getInstance()->UploadGalleryImage(plateId.UTF8String, filePath.UTF8String, requestId, cppUrl))
    {
        retUrl = [[NSString alloc] initWithUTF8String:cppUrl.c_str()];
    }
    
    return retUrl;
}

-(NSString*) UploadGalleryVideo:(NSString*)plateId :(NSString*)filePath :(NSInteger)requestId :(NSString*)thumbnail_url
{
    std::string cppUrl = "";
    NSString *retUrl = nil;
    
    if (PMLibCpp::PMServer::getInstance()->UploadGalleryVideo(plateId.UTF8String, filePath.UTF8String, requestId, thumbnail_url.UTF8String, cppUrl))
    {
        retUrl = [[NSString alloc] initWithUTF8String:cppUrl.c_str()];
    }
    
    return retUrl;
}

-(PMWallData*) GetFeed
{
    PMLibCpp::WallData cppWallData;
    PMWallData *wallData = nil;
    
    if (PMLibCpp::PMServer::getInstance()->GetFeed(cppWallData))
    {
        wallData = [self wallDataFromCppStruct:cppWallData];
    }
    
    return wallData;    
}

-(PMWallData*) GetLocalFeed
{
    PMLibCpp::WallData cppWallData;
    PMWallData *wallData = nil;
    
    if (PMLibCpp::PMServer::getInstance()->GetLocalFeed(cppWallData))
    {
        wallData = [self wallDataFromCppStruct:cppWallData];
    }
    
    return wallData;      
}

-(bool) UpdateToken:(NSString*)token
{
    return PMLibCpp::PMServer::getInstance()->UpdateToken(NULL, token.UTF8String);
}

-(NSMutableArray*) GetNotifications
{
    PMLibCpp::NotificationVector cppNotifications;
    NSMutableArray *notifications = nil;
    
    if (PMLibCpp::PMServer::getInstance()->GetNotifications(cppNotifications))
    {
        notifications = [self notificationsFromCpp:cppNotifications];
    }
    
    return notifications;    
}

-(bool) HideNotification:(NSString*)notificationId
{
    return PMLibCpp::PMServer::getInstance()->HideNotification(notificationId.UTF8String);
}

 
/*************HELPER Functions for the API********************************/

-(NSMutableArray*) notificationsFromCpp:(const PMLibCpp::NotificationVector&) cppNotificationVector
{
    NSMutableArray *notifications = [[[NSMutableArray alloc] init] autorelease];
    
    for (uint32_t notifIndex = 0; notifIndex < cppNotificationVector.size(); notifIndex++)
    {
        PMNotificationData *notifData = [[PMNotificationData alloc] init];
        
        notifData.notificationId = [NSString stringWithUTF8String:cppNotificationVector[notifIndex].notificationId.c_str()];
        notifData.accountId = [NSString stringWithUTF8String:cppNotificationVector[notifIndex].accountId.c_str()];
        notifData.message = [NSString stringWithUTF8String:cppNotificationVector[notifIndex].message.c_str()];
        notifData.type = [NSString stringWithUTF8String:cppNotificationVector[notifIndex].type.c_str()];
        notifData.targetId = [NSString stringWithUTF8String:cppNotificationVector[notifIndex].targetId.c_str()];
        notifData.unread = [NSString stringWithUTF8String:cppNotificationVector[notifIndex].unread.c_str()];
        notifData.show = [NSString stringWithUTF8String:cppNotificationVector[notifIndex].show.c_str()];
        notifData.timestamp = [NSString stringWithUTF8String:cppNotificationVector[notifIndex].timestamp.c_str()];
        
        [notifications addObject:notifData];
        [notifData release];
    }
    
    return notifications;
}

-(NSMutableArray*) galleryFromCpp:(const PMLibCpp::GalleryImageVector&) cppImagesVector
{
    NSMutableArray *images = [[[NSMutableArray alloc] init] autorelease];
    
    for (uint32_t imageIndex = 0; imageIndex < cppImagesVector.size(); imageIndex++)
    {
        PMGalleryImageData *imageData = [[PMGalleryImageData alloc] init];
        
        imageData.imageId = [NSString stringWithUTF8String:cppImagesVector[imageIndex].imageId.c_str()];
        imageData.plateId = [NSString stringWithUTF8String:cppImagesVector[imageIndex].plateId.c_str()];
        imageData.accountId = [NSString stringWithUTF8String:cppImagesVector[imageIndex].accountId.c_str()];
        imageData.url = [NSString stringWithUTF8String:cppImagesVector[imageIndex].url.c_str()];
        imageData.mediaType = [NSString stringWithUTF8String:cppImagesVector[imageIndex].mediaType.c_str()];
        imageData.thumbnailUrl = [NSString stringWithUTF8String:cppImagesVector[imageIndex].thumbnailUrl.c_str()];
        imageData.uploadedOn = [NSString stringWithUTF8String:cppImagesVector[imageIndex].uploadedOn.c_str()];
        
        [images addObject:imageData];
        [imageData release];
    }
    
    return images;
}

- (PMPostData*) fillPost :(PMPostData*)post :(const PMLibCpp::WallPost&)cppPost
{
    //Set the postId
    [post setPostId:[NSString stringWithUTF8String:cppPost.postId.c_str()]];
    
    [post setOwnerId:[NSString stringWithUTF8String:cppPost.accountId.c_str()]];
    
    [post setPlateId:[NSString stringWithUTF8String:cppPost.plateId.c_str()]];
    
    //Set the pic url
    [post setProfilePicUrl:[NSString stringWithUTF8String:cppPost.profilePicUrl.c_str()]];
    
    //Set post content
    [post setText:[NSString stringWithUTF8String:cppPost.content.c_str()]];
    
    //Set poster name
    std::string posterName = ((cppPost.fname + " ") + cppPost.lname).c_str();
    [post setPosterName:[NSString stringWithUTF8String:posterName.c_str()]];
    
    //Set the average rating
    [post setAverageRating:[NSString stringWithUTF8String:cppPost.avg_rating.c_str()]];
    
    //Set the number of ratings
    [post setNumRatings:[NSString stringWithUTF8String:cppPost.num_ratings.c_str()]];
    
    //Set the parent Id
    [post setParentId:[NSString stringWithUTF8String:cppPost.parentId.c_str()]];
    
    //Get the timestamp
    [post setTimestamp:[NSString stringWithUTF8String:cppPost.postedon.c_str()]];
    
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; 
    NSDate* date = [formatter dateFromString:post.timestamp];
    [formatter setDateFormat:@"EEE, MMM d 'at' h:mm a"];
    post.timestamp = [formatter stringFromDate:date];
    [formatter release];
    
    //Get the posted image url
    [post setPostImageUrl:[NSString stringWithUTF8String:cppPost.imgUrl.c_str()]];
    
    //Get the posted video
    [post setPostVideoUrl:[NSString stringWithUTF8String:cppPost.videoUrl.c_str()]];
    [post setPostVideoThumbnailUrl:[NSString stringWithUTF8String:cppPost.videoThumbnailUrl.c_str()]];
    
    //Set the image to nil to start
    [post setProfileImage:nil];
    
    return post;
}

-(PMWallData*) wallDataFromCppStruct:(const PMLibCpp::WallData&)cppWallData
{
    PMWallData *wallData = [[[PMWallData alloc] init] autorelease];
    
    for (uint32_t postIndex = 0; postIndex < cppWallData.posts.size(); postIndex++)
    {
        PMPostData *post = [[PMPostData alloc] init];
        const PMLibCpp::WallPost& cppPost = cppWallData.posts[postIndex];
        
        for (uint32_t commentIndex = 0; commentIndex < cppPost.comments.size(); commentIndex++)
        {
            PMPostData *comment = [[PMPostData alloc] init];
            [post.comments addObject:[self fillPost:comment :cppPost.comments[commentIndex]]];
            [comment release];
        }
        
        [wallData.posts addObject:[self fillPost :post :cppPost]];
        [post release];
    }
    
    return wallData;
}

-(PMPlateData*) plateDataFromCppStruct:(const PMLibCpp::PlateData&)cppPlateData
{
    PMPlateData *plateData = [[[PMPlateData alloc] init] autorelease];
    
    plateData.plateId = [NSString stringWithUTF8String:cppPlateData.plateId.c_str()];
    plateData.plateNumber = [NSString stringWithUTF8String:cppPlateData.plate.c_str()];
    plateData.make = [NSString stringWithUTF8String:cppPlateData.make.c_str()];
    plateData.model = [NSString stringWithUTF8String:cppPlateData.model.c_str()];
    plateData.color = [NSString stringWithUTF8String:cppPlateData.color.c_str()];
    plateData.associatedAccountId = [NSString stringWithUTF8String:cppPlateData.accountId.c_str()];
    plateData.year = [NSString stringWithUTF8String:cppPlateData.year.c_str()];
    plateData.state = [NSString stringWithUTF8String:cppPlateData.state.c_str()];
    plateData.latitude = [NSString stringWithUTF8String:cppPlateData.latitude.c_str()];
    plateData.longitude = [NSString stringWithUTF8String:cppPlateData.longitude.c_str()];
    plateData.platePicUrl = [NSString stringWithUTF8String:cppPlateData.platePicUrl.c_str()];
    
    return plateData;
}

-(PMUserData*) userDataFromCppStruct:(const PMLibCpp::UserData&) cppUserData
{
    PMUserData *userData = [[[PMUserData alloc] init] autorelease];    
    
    userData.userId = [NSString stringWithUTF8String:cppUserData.userId.c_str()];
    userData.email = [NSString stringWithUTF8String:cppUserData.email.c_str()];
    userData.firstName = [NSString stringWithUTF8String:cppUserData.firstName.c_str()];
    userData.lastName = [NSString stringWithUTF8String:cppUserData.lastName.c_str()];
    userData.primaryPlateId = [NSString stringWithUTF8String:cppUserData.plateId.c_str()];
    userData.profilePicUrl = [NSString stringWithUTF8String:cppUserData.profilePicUrl.c_str()];
    
    return userData;
}

-(NSMutableArray*) favoritesFromCpp:(const PMLibCpp::FavoritesVector&) cppFavoritesVector
{
    NSMutableArray *favorites = [[[NSMutableArray alloc] init] autorelease];
    
    for (uint32_t favIndex = 0; favIndex < cppFavoritesVector.size(); favIndex++)
    {
        PMFavoriteData *favoriteData = [[PMFavoriteData alloc] init];
        
        favoriteData.userId = [NSString stringWithUTF8String:cppFavoritesVector[favIndex].accountId.c_str()];
        favoriteData.firstName = [NSString stringWithUTF8String:cppFavoritesVector[favIndex].fname.c_str()];
        favoriteData.lastName = [NSString stringWithUTF8String:cppFavoritesVector[favIndex].lname.c_str()];
        favoriteData.profilePicUrl = [NSString stringWithUTF8String:cppFavoritesVector[favIndex].profilePicUrl.c_str()];
        favoriteData.primaryPlateId = [NSString stringWithUTF8String:cppFavoritesVector[favIndex].primaryPlateId.c_str()];
        favoriteData.primaryPlateLat = [NSString stringWithUTF8String:cppFavoritesVector[favIndex].primaryPlateLat.c_str()];
        favoriteData.primaryPlateLon = [NSString stringWithUTF8String:cppFavoritesVector[favIndex].primaryPlateLon.c_str()];        
        
        [favorites addObject:favoriteData];
        [favoriteData release];
    }
    
    return favorites;
}

-(NSMutableArray*) ratingsFromCpp:(const PMLibCpp::FiveStarVector&) cppRatingsVector
{
    NSMutableArray *ratings = [[[NSMutableArray alloc] init] autorelease];
    
    for (uint32_t favIndex = 0; favIndex < cppRatingsVector.size(); favIndex++)
    {
        PMFiveStarData *fiveStarData = [[PMFiveStarData alloc] init];
        
        fiveStarData.postId = [NSString stringWithUTF8String:cppRatingsVector[favIndex].postId.c_str()];
        fiveStarData.accountId = [NSString stringWithUTF8String:cppRatingsVector[favIndex].accountId.c_str()];
        fiveStarData.rating = [NSString stringWithUTF8String:cppRatingsVector[favIndex].rating.c_str()];
        fiveStarData.firstName = [NSString stringWithUTF8String:cppRatingsVector[favIndex].fname.c_str()];
        fiveStarData.lastName = [NSString stringWithUTF8String:cppRatingsVector[favIndex].lname.c_str()];      
        
        [ratings addObject:fiveStarData];
        [fiveStarData release];
    }
    
    return ratings;
}

-(NSMutableArray*) followersFromCpp:(const PMLibCpp::FollowersVector&) cppFollwersVector
{
    NSMutableArray *followers = [[[NSMutableArray alloc] init] autorelease];
    
    for (uint32_t folIndex = 0; folIndex < cppFollwersVector.size(); folIndex++)
    {
        PMFollowerData *followerData = [[PMFollowerData alloc] init];
        
        followerData.plateId = [NSString stringWithUTF8String:cppFollwersVector[folIndex].plateId.c_str()];
        followerData.accountId = [NSString stringWithUTF8String:cppFollwersVector[folIndex].accountId.c_str()];
        followerData.firstName = [NSString stringWithUTF8String:cppFollwersVector[folIndex].fname.c_str()];
        followerData.lastName = [NSString stringWithUTF8String:cppFollwersVector[folIndex].lname.c_str()];
        followerData.profilePicUrl = [NSString stringWithUTF8String:cppFollwersVector[folIndex].platePicUrl.c_str()];
        followerData.plate = [NSString stringWithUTF8String:cppFollwersVector[folIndex].plateNumber.c_str()];
        
        [followers addObject:followerData];
        [followerData release];
    }
    
    return followers;    
}

/**************************************************************************/

@end

/************C functions************************/

void progressCallback(double upPercent, double downPercent, PMLibCpp::PMServer::ProgressStruct* progressData)
{
    
    if (PMLibCpp::PMServer::DOWNLOAD == progressData->requestType)
        [PMLoadingView setProgressValue:downPercent :progressData->requestId];
    else if (PMLibCpp::PMServer::UPLOAD == progressData->requestType)
        [PMLoadingView setProgressValue:upPercent :progressData->requestId];
}

/***********************************************/
