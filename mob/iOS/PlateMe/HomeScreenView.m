//
//  HomeScreenView.m
//
//  Created by User on 8/11/11.
//  Copyright 2011 PlateMe.com. All rights reserved.
//

#import "HomeScreenView.h"

@implementation HomeScreenView

- (IBAction)showAccountView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[homeScreenView removeFromSuperview];
	[self addSubview:accountView];
	[UIView commitAnimations];
}

- (IBAction)showOwnProfileView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[homeScreenView removeFromSuperview];
	[self addSubview:profileView];
	[UIView commitAnimations];
	
	UIFont *licensePlateFont = [UIFont fontWithName:@"LicensePlate" size:30];
	plateNumLabel.font = licensePlateFont;
	[plateNumLabel setTextColor:[UIColor redColor]];
    plateNumLabel.text = @"6RCU129";
}

- (IBAction)showFeedView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[homeScreenView removeFromSuperview];
	[self addSubview:feedView];
	[UIView commitAnimations];
}

- (IBAction)showFavoritesView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[homeScreenView removeFromSuperview];
	[self addSubview:favoritesView];
	[UIView commitAnimations];
}

- (IBAction)showChatView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[homeScreenView removeFromSuperview];
	[self addSubview:chatView];
	[UIView commitAnimations];
}

- (IBAction)showMessagesView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[homeScreenView removeFromSuperview];
	[self addSubview:messagesView];
	[UIView commitAnimations];
}

- (IBAction)showPhotosView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[homeScreenView removeFromSuperview];
	[self addSubview:photosView];
	[UIView commitAnimations];
}

- (IBAction)showFollowersView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[homeScreenView removeFromSuperview];
	[self addSubview:followersView];
	[UIView commitAnimations];
}

- (IBAction)showPrivacyView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[homeScreenView removeFromSuperview];
	[self addSubview:privacyView];
	[UIView commitAnimations];
}

- (IBAction)showPlacesView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[homeScreenView removeFromSuperview];
	[self addSubview:placesView];
	[UIView commitAnimations];
}

- (IBAction)showNotificationsView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[homeScreenView removeFromSuperview];
	[self addSubview:notificationsView];
	[UIView commitAnimations];
}

- (IBAction)showSearchPlateView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[homeScreenView removeFromSuperview];
	[self addSubview:searchPlateView];
	[UIView commitAnimations];
}

- (IBAction)showPlatePhotoView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[homeScreenView removeFromSuperview];
	[self addSubview:platePhotoView];
	[UIView commitAnimations];
}

- (IBAction)refreshPage:(id)sender
{
	UIImage	*notificationSymbol = [UIImage imageNamed:@"Notification Symbol 2.png"];
	[messagesNotifyView setImage:notificationSymbol];
	[chatNotifyView setImage:notificationSymbol];
	//[notificationsNotifyView setImage:notificationSymbol];
	UIImage *modifiedNotifications = [UIImage imageNamed:@"NotificationsButton2.png"];
	[notificationsButton setImage:modifiedNotifications forState:UIControlStateNormal];
}

- (IBAction)swipeNextPage:(id)sender
{
}

@end
