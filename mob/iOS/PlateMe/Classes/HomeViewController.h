//
//  HomeViewController.h
//  PlateMe
//
//  Created by Kevin Calcote on 1/14/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlateMeViewController.h"
#import "PlacesViewController.h"
#import "PlatePhotoViewController.h"
#import "ComingSoonViewController.h"

@class LoginViewController;
@class CustomBadge;

@interface HomeViewController : PlateMeViewController <UIActionSheetDelegate>
{
    IBOutlet PlacesViewController *placesViewController;
    IBOutlet ComingSoonViewController *comingSoonViewController;
    IBOutlet LoginViewController *loginViewController;
    
    IBOutlet UIButton *profileButton;
    IBOutlet UIButton *notificationsButton;
    
    CustomBadge *notificationsBadge;
    CustomBadge *profileBadge;
    
    //Tmp
    UIImagePickerController *imagePicker;
}

- (IBAction) accountButtonPressed:(id)sender;
- (IBAction) buttonPressed:(id)sender;
- (IBAction)notificationsPressed:(id)sender;
- (void) stopLocationManager;
- (void) refreshNotifications;
- (void) notificationReceived:(NSDictionary*)userInfo;

- (void) doLogout;

@end
