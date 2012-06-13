//
//  HomeScreenView.h
//
//  Created by User on 8/11/11.
//  Copyright 2011 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface HomeScreenView : UIView
{
	IBOutlet UIView *homeScreenView;
	IBOutlet UIView *accountView;
	IBOutlet UIView *feedView;
	IBOutlet UIView *favoritesView;
	IBOutlet UIView *chatView;
	IBOutlet UIView *messagesView;
	IBOutlet UIView *photosView;
	IBOutlet UIView *followersView;
	IBOutlet UIView *privacyView;
	IBOutlet UIView *placesView;
	IBOutlet UIView *profileView;
	IBOutlet UIView *searchPlateView;
	IBOutlet UIView *platePhotoView;
	IBOutlet UIView *notificationsView;
	IBOutlet UILabel *plateNumLabel; 
	IBOutlet UIImageView *messagesNotifyView;
	IBOutlet UIImageView *chatNotifyView;
	IBOutlet UIImageView *notificationsNotifyView;
	IBOutlet UIButton *notificationsButton;
}

- (IBAction)showAccountView:(id)sender;
- (IBAction)showOwnProfileView:(id)sender;
- (IBAction)showFeedView:(id)sender;
- (IBAction)showFavoritesView:(id)sender;
- (IBAction)showChatView:(id)sender;
- (IBAction)showMessagesView:(id)sender;
- (IBAction)showPhotosView:(id)sender;
- (IBAction)showFollowersView:(id)sender;
- (IBAction)showPrivacyView:(id)sender;
- (IBAction)showPlacesView:(id)sender;
- (IBAction)showNotificationsView:(id)sender;
- (IBAction)refreshPage:(id)sender;
- (IBAction)swipeNextPage:(id)sender;
- (IBAction)showSearchPlateView:(id)sender;
- (IBAction)showPlatePhotoView:(id)sender;


@end
