//
//  PMLocationData.m
//  PlateMe
//
//  Created by Kevin Calcote on 2/17/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PMLocationData.h"
#import <MapKit/MapKit.h>

@implementation PMLocationData

-(id) init
{
    self = [super init];
    if (self)
    {
        locations = [[[NSMutableDictionary alloc] init] retain];
    }
    
    return self;
}

-(void) addLocation:(NSString*)plateId :(NSString*)latitude :(NSString*)longitude
{
    //Create the location
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    
    //Add the location
    [locations setValue:loc forKey:plateId];
}

-(CLLocation*) getLocation:(NSString*)plateId
{
    return [locations valueForKey:plateId];
}

-(NSDictionary*) getLocations
{
    return locations;
}

-(void) clearLocations
{
    [locations removeAllObjects];
}

@end
