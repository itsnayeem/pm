//
//  PlacesView.h
//  PlateMe
//
//  Created by User on 12/15/11.
//  Copyright (c) 2011 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PlacesView : UIView
{
	//IBOutlet UIView *platePhotoView;
    MKMapView *mapView;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

- (IBAction)showLastView:(id)sender;

- (IBAction)showUserLocation:(id)sender;

- (id)initWithCoder:(NSCoder *)decoder;

@end
