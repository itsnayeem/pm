//
//  RegisterPg2.m
//
//  Created by User on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RegisterPg2.h"

@implementation RegisterPg2

- (IBAction)showPlatePhotoView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[registerPg2View removeFromSuperview];
	[self addSubview:platePhotoView];
	[UIView commitAnimations];
}

- (IBAction)showSearchPlateView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[registerPg2View removeFromSuperview];
	[self addSubview:searchPlateView];
	[UIView commitAnimations];
}

- (IBAction)showLastView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[self removeFromSuperview];
	[UIView commitAnimations];
}

- (IBAction)showHomeScreenView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[registerPg2View removeFromSuperview];
	[self addSubview:homeScreenView];
	[UIView commitAnimations];
}

- (IBAction)showCameraEnableView:(id)sender
{
}

@end
