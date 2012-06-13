//
//  LocationController.h
//  PlateMe
//
//  Created by Kevin Calcote on 3/1/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class PMServer;
@class PlateMeSession;

@interface  LocationController : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    PMServer *pmServer;
    PlateMeSession *session;
}

+ (LocationController *)sharedInstance;

-(void) start;
-(void) stop;
-(BOOL) locationKnown;

@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) PMServer *pmServer;
@property (nonatomic, retain) PlateMeSession *session;

@end
