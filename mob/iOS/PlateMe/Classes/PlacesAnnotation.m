//
//  PlacesAnnotation.m
//  PlateMe
//
//  Created by Kevin Calcote on 2/17/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PlacesAnnotation.h"
#import "PMPlateData.h"

@implementation PlacesAnnotation

@synthesize plateData;
@synthesize userData;

@synthesize coordinate = _coordinate;

-(id) alloc
{
    self = [super alloc];
    
    return self;
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate 
{
    coordinate = coordinate;
    return self;
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString*) title 
{
    _coordinate = coordinate;
    _title = [title retain];
    return self;
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString*) title andSubtitle:(NSString*) subtitle 
{
    _coordinate = coordinate;
    _title = [title retain];
    _subtitle = [subtitle retain];
    return self;
}

- (NSString *)title 
{
    return _title;
}

- (NSString *)subtitle 
{
    return _subtitle;
}

-(void) dealloc 
{
    [_title release];
    [_subtitle release];
    [super dealloc];
}


@end
