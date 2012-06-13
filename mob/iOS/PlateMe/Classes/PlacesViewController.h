//
//  PlacesViewController.h
//  PlateMe
//
//  Created by Kevin Calcote on 1/14/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PlateMeViewController.h"
#import <MapKit/MapKit.h>

@interface PlacesViewController : PlateMeViewController <MKMapViewDelegate>
{
    IBOutlet MKMapView *nibMapView;
    MKAnnotationView *selfAnnotation;
    UIImage *defaultUserPic;
    NSMutableArray *annotationArray;
}

-(void) doAnnotationLoad;

@end
