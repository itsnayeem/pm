//
//  PlateMeSession.m
//  PlateMe
//
//  Created by Kevin Calcote on 2/4/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PlateMeSession.h"

@implementation NotificationReceiver

@synthesize target;
@synthesize selector;

@end

@implementation PlateMeSession

@synthesize plates;
@synthesize locationData;
@synthesize favorites;
@synthesize favoriteRequests;
@synthesize followers;
@synthesize deviceToken;
@synthesize notifications;

-(id) init
{
    self = [super init];
    
    if (self)
    {
        userData = [[[PMUserData alloc] init] retain];
        plates = [[[NSMutableDictionary alloc] init] retain];
        locationData = [[[PMLocationData alloc] init] retain];
        favorites = [[[NSMutableArray alloc] init] retain];
        favoriteRequests = [[[NSMutableArray alloc] init] retain];
        defaultPlateData = [[[PMPlateData alloc] init] retain];
        notificationReceivers = [[NSMutableArray alloc] init];
        defaultPlateData.plateId = @"0";
        defaultPlateData.make = @"";
        defaultPlateData.model = @"";
        defaultPlateData.state = @"";
        defaultPlateData.year = @"";
        defaultPlateData.color = @"";
        defaultPlateData.associatedAccountId = @"";
        defaultPlateData.plateNumber = @"No Plate";
        
        defaultUserData = [[[PMUserData alloc] init] retain];
        defaultUserData.firstName = @"Unregistered";
        defaultUserData.lastName = @"";
    }    
    
    return self;
}

-(void) setSettings:(struct PMSettings)settingsL
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // This is where you would select the file name for the image you want to save.
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"PMSettings"];

    NSData *data = [NSData dataWithBytes:(const void*)&settingsL length:sizeof(settingsL)];
    
    // This actually creates the image at the file path specified, with the image's NSData.
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
    
    settings = settingsL;
}

- (struct PMSettings) settings
{
    struct PMSettings fileSettings = {0};
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // This is where you would select the file name for the image you want to save.
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"PMSettings"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [self setSettings:settings];

    }
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    fileSettings = *((struct PMSettings*)data.bytes);
    
    return fileSettings;  
}

-(void) addPlate:(PMPlateData*)plateData :(BOOL)defaultPlate
{
    @synchronized(self)
    {
        //Set at plate Id 0 if this is the current accounts default plate
        if (defaultPlate)
        {
            [plates setValue:plateData forKeyPath:@"0"];
        }
        
        [plates setValue:plateData forKeyPath:plateData.plateId];
    }
}

-(void) addPlate:(PMPlateData*)plateData
{
    [self addPlate:plateData :NO];
}

-(PMPlateData*) getPlate
{
    return [self getPlate:@"0"];
}

-(PMPlateData*) getPlate:(NSString*)plateId
{
    @synchronized(self)
    {
        PMPlateData *plateData = (PMPlateData*)[plates valueForKey:plateId];
        
        //If no plate exists then return default data
        if (nil == plateData)
        {
            return defaultPlateData;
        }
        
        return plateData;
    }
}

-(PMUserData*)userData
{
    if (userData == nil)
    {
        return defaultUserData;
    }
    
    return userData;
}

-(void)setUserData:(PMUserData *)userDataL
{
    if (userData != userDataL)
    {
        [userData release];
        userData = [userDataL retain];
    }
}

+(PlateMeSession*) currentSession
{
    static PlateMeSession *instance = nil;
    
    @synchronized(self)
    {
        if (nil == instance)
            instance = [[PlateMeSession alloc] init];
    }
    
    return instance;
}

-(BOOL) accountIsFavorite:(NSString*)accountId
{
    @synchronized(self)
    {
        //If checking same account then return true
        //You are a favorite of yoursef!
        if ([accountId isEqualToString:userData.userId])
            return true;
        
        for (PMFavoriteData *favData in favorites)
        {
            if ([favData.userId isEqualToString:accountId])
                return true;
        }
        
        return false;
    }
}

-(BOOL) accountIsFavoriteRequest:(NSString*)accountId
{
    @synchronized(self)
    {
        //If checking same account then return true
        //You are a favorite of yoursef!
        if ([accountId isEqualToString:userData.userId])
            return true;
        
        for (PMFavoriteData *favData in favoriteRequests)
        {
            if ([favData.userId isEqualToString:accountId])
                return true;
        }
        
        return false;
    }
}

-(void) notificationReceived:(NSDictionary*)userInfo
{
    for (NotificationReceiver *receiver in notificationReceivers)
    {
        [receiver.target performSelector:receiver.selector];
    }
}

-(void) addNotificationReceiver:(id)target :(SEL)selector
{
    NotificationReceiver *receiver = [[NotificationReceiver alloc] init];
    
    receiver.target = target;
    receiver.selector = selector;
    
    [notificationReceivers addObject:receiver];
}


-(void) dealloc
{
    [userData release];
    [plates release];
    [locationData release];
    
    [super dealloc];
}

@end
