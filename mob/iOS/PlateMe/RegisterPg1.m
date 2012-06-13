//
//  RegisterPg1.m
//
//  Created by User on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RegisterPg1.h"

@implementation RegisterPg1

- (IBAction)showRegisterPg2View:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[registerPg1View removeFromSuperview];
	[self addSubview:registerPg2View];
	[UIView commitAnimations];
}

- (IBAction)showPlatePhotoView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[registerPg1View removeFromSuperview];
	[self addSubview:platePhotoView];
	[UIView commitAnimations];
}

- (IBAction)showSearchPlateView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[registerPg1View removeFromSuperview];
	[self addSubview:searchPlateView];
	[UIView commitAnimations];
}

- (IBAction)emailNextPressed:(id)sender
{
	[passwordTextField becomeFirstResponder];
	return;
}

- (IBAction)passwordNextPressed:(id)sender
{
	[confirmPasswordTextField becomeFirstResponder];
	return;
}

- (IBAction)confirmPasswordDonePressed:(id)sender
{
	return;
}

- (IBAction)birthdayDonePressed:(id)sender
{
	return;
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
	[registerPg1View removeFromSuperview];
	[self addSubview:homeScreenView];
	[UIView commitAnimations];
}

@end
