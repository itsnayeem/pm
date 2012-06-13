//
//  LocationController.m
//  PlateMe
//
//  Created by Kevin Calcote on 3/1/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "LocationController.h"
#import "PlateMeSession.h"
#import "PMServer.h"

@implementation LocationController

@synthesize currentLocation;
@synthesize pmServer;
@synthesize session;

static LocationController *sharedInstance;

+ (LocationController *)sharedInstance {
    @synchronized(self) {
        if (!sharedInstance)
            sharedInstance=[[LocationController alloc] init];       
    }
    return sharedInstance;
}

+(id)alloc {
    @synchronized(self) {
        NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of a singleton LocationController.");
        sharedInstance = [super alloc];
    }
    return sharedInstance;
}

-(id) init {
    if (self = [super init]) {
        self.currentLocation = [[CLLocation alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
        /* Notify changes when device has moved x meters.
         * Default value is kCLDistanceFilterNone: all movements are reported.
         */
        locationManager.distanceFilter = 10.0f;
        
        /* Notify heading changes when heading is > 5.
         * Default value is kCLHeadingFilterNone: all movements are reported.
         */
        locationManager.headingFilter = 5;
        locationManager.delegate = self;
        [self start];
    }
    return self;
}

-(void) start {
    [locationManager startUpdatingLocation];
}

-(void) stop {
    [locationManager stopUpdatingLocation];
}

-(BOOL) locationKnown { 
    if (round(currentLocation.speed) == -1) return NO; else return YES; 
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //if the time interval returned from core location is more than two minutes we ignore it because it might be from an old session
    if ( (nil != newLocation) && (abs([newLocation.timestamp timeIntervalSinceDate: [NSDate date]]) < 120)) 
    {     
        //Only update the location if it has changed
        if ( (newLocation.coordinate.latitude != oldLocation.coordinate.latitude) &&
             (newLocation.coordinate.longitude != oldLocation.coordinate.longitude) )
        {
            self.currentLocation = newLocation;
            
            double latitude = (double)self.currentLocation.coordinate.latitude;
            double longitude = (double)self.currentLocation.coordinate.longitude;
            
            NSString *latString = [NSString stringWithFormat:@"%f", latitude];
            NSString *lonString = [NSString stringWithFormat:@"%f", longitude];
            
            //TODO: Need to update location of specific plates...may not
            //      be done here though
            PMPlateData *plateData = [session getPlate];
            
            [pmServer UpdateLocation:plateData.plateId :latString :lonString];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void) dealloc {
    [locationManager release];
    [currentLocation release];
    [super dealloc];
}

@end
