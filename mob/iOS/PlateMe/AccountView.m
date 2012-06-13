//
//  AccountView.m
//
//  Created by User on 8/11/11.
//  Copyright 2011 PlateMe.com. All rights reserved.
//

#import "AccountView.h"

@implementation AccountView

- (IBAction)showLastView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[self removeFromSuperview];
	[UIView commitAnimations];
}

- (IBAction)showLoginView:(id)sender
{
	//[UIView beginAnimations:Nil context:NULL];
	//[UIView setAnimationDuration:1.0];
	//[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	//[self removeFromSuperview];
	[self addSubview:loginView];
	//[self bringSubviewToFront:loginView];
	//[UIView commitAnimations];
}

- (IBAction)showPrivacyView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[accountView removeFromSuperview];
	[self addSubview:privacyView];
	[UIView commitAnimations];
}

- (IBAction)showAccountSettingsView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[accountView removeFromSuperview];
	[self addSubview:accountSettingsView];
	[UIView commitAnimations];
}

- (IBAction)showHelpCenterView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[accountView removeFromSuperview];
	[self addSubview:helpCenterView];
	[UIView commitAnimations];
}

@end
