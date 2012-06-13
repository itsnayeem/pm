//
//  SampleProfileView.m
//
//  Created by User on 8/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SampleProfileView.h"

@implementation SampleProfileView

- (IBAction)showLastView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[self removeFromSuperview];
	[UIView commitAnimations];
}

- (IBAction)pressedFollow:(id)sender
{
	if (!following.selected)
	{
		following.selected = TRUE;
	}
	else
	{
		following.selected = FALSE;
	}

}

- (IBAction)pressedFavorites:(id)sender
{
	if (!addedToFavs.selected)
	{
		addedToFavs.selected = TRUE;
	}
	else
	{
		addedToFavs.selected = FALSE;
	}
	
}

@end
