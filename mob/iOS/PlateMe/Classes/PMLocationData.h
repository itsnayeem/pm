//
//  PMLocationData.h
//  PlateMe
//
//  Created by Kevin Calcote on 2/17/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface PMLocationData : NSObject
{
    NSMutableDictionary *locations;
}

-(void) addLocation:(NSString*)plateId :(NSString*)latitude :(NSString*)longitude;
-(CLLocation*) getLocation:(NSString*)plateId;
-(NSDictionary*) getLocations;
-(void) clearLocations;

@end
