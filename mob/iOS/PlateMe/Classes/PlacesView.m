//
//  PlacesView.m
//  PlateMe
//
//  Created by User on 12/15/11.
//  Copyright (c) 2011 PlateMe.com. All rights reserved.
//

#import "PlacesView.h"

@implementation PlacesView

@synthesize mapView;

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        
    }
    return self;
}

- (IBAction)showUserLocation:(id)sender
{
    [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:true];
    [mapView setShowsUserLocation:true];
}

- (IBAction)showLastView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[self removeFromSuperview];
	[UIView commitAnimations];
}


@end
