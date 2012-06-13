//
//  AccountView.h
//
//  Created by User on 8/11/11.
//  Copyright 2011 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AccountView : UIView
{
	IBOutlet UIView *accountView;
	IBOutlet UIView *loginView;
	IBOutlet UIView *privacyView;
	IBOutlet UIView *accountSettingsView;
	IBOutlet UIView *helpCenterView;
}

- (IBAction)showLastView:(id)sender;
- (IBAction)showLoginView:(id)sender;
- (IBAction)showPrivacyView:(id)sender;
- (IBAction)showAccountSettingsView:(id)sender;
- (IBAction)showHelpCenterView:(id)sender;

@end
