//
//  PlateMeSession.h
//  PlateMe
//
//  Created by Kevin Calcote on 2/4/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMUserData.h"
#import "PMPlateData.h"
#import "PMLocationData.h"
#import "PMNotificationData.h"

struct PMSettings
{
    BOOL keepLoggedIn;
    char username[100];
    char password[100];
};

@interface NotificationReceiver :NSObject
{
    id target;
    SEL selector;
}

@property (retain) id target;
@property (assign) SEL selector;

@end

@interface PlateMeSession : NSObject
{
    enum SessionType
    {
        LOGGEDIN,
        ANONYMOUS,
        SELF
    };

@private
    PMUserData* userData;
    NSMutableDictionary* plates;
    PMPlateData *defaultPlateData;
    PMUserData *defaultUserData;
    PMLocationData *locationData;
    NSMutableArray *favorites;
    NSMutableArray *favoriteRequests;
    NSMutableArray *followers;
    enum SessionType sessionType;
    NSString *deviceToken;
    NSMutableArray *notifications;
    struct PMSettings settings;
    NSMutableArray *notificationReceivers;
}

@property (retain) PMUserData *userData;
@property (retain) NSMutableDictionary *plates;
@property (retain) PMLocationData *locationData;
@property (retain) NSMutableArray *favorites;
@property (retain) NSMutableArray *favoriteRequests;
@property (retain) NSMutableArray *followers;
@property (retain) NSString *deviceToken;
@property (retain) NSMutableArray *notifications;
@property (assign) struct PMSettings settings;

-(void) addPlate:(PMPlateData*)plateData;
-(void) addPlate:(PMPlateData*)plateData :(BOOL)defaultPlate;
-(PMPlateData*) getPlate;
-(PMPlateData*) getPlate:(NSString*)plateId;
-(BOOL) accountIsFavorite:(NSString*)accountId;
-(BOOL) accountIsFavoriteRequest:(NSString*)accountId;
-(void) addNotificationReceiver:(id)target :(SEL)selector;
-(void) notificationReceived:(NSDictionary*)userInfo;

+(PlateMeSession*) currentSession;

@end
