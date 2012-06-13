//
//  PlacesAnnotationView.h
//  PlateMe
//
//  Created by Kevin Calcote on 2/17/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PlacesAnnotationView : MKAnnotationView
{
    UIImageView *imageView;
}


@property (retain) UIImageView *imageView;

@end
