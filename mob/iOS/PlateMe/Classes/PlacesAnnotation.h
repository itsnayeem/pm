//
//  PlacesAnnotation.h
//  PlateMe
//
//  Created by Kevin Calcote on 2/17/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class PMPlateData;
@class PMUserData;

@interface PlacesAnnotation : NSObject<MKAnnotation>
{
    PMPlateData *plateData;
    PMUserData *userData;
    CLLocationCoordinate2D _coordinate;
    NSString * _title;
    NSString * _subtitle;
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *) title;
- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *) title andSubtitle:(NSString *)subtitle;

- (NSString *)title;
- (NSString *)subtitle;


@property (retain) PMPlateData *plateData;
@property (retain) PMUserData *userData;

@end
