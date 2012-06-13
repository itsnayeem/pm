//
//  LoginView.m
//
//  Created by User on 8/11/11.
//  Copyright 2011 PlateMe.com. All rights reserved.
//

#import "LegalView.h"

@implementation LegalView

- (IBAction)showLoginView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[legalView removeFromSuperview];
	[self addSubview:loginView];
	[UIView commitAnimations];
}

@end
