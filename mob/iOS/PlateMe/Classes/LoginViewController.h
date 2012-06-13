//
//  LoginViewController.h
//  PlateMe
//
//  Created by Kevin Calcote on 1/13/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlateMeViewController.h"
#import "HomeViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController : PlateMeViewController
<UITextFieldDelegate>
{
    IBOutlet HomeViewController *homeViewController;
    IBOutlet RegisterViewController *registerViewController;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
    IBOutlet UISwitch *keepLoggedInSwitch;
}

@property (nonatomic, retain) HomeViewController *homeViewController;
@property (retain) UITextField *emailField;
@property (retain) UITextField *passwordField;

- (IBAction)loginPressed:(id)sender;
- (IBAction)emailDonePressed:(id)sender;
- (IBAction)registerPressed:(id)sender;
- (IBAction)keepLoggedInChanged:(id)sender;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void) doLogin:(NSString*)email :(NSString*)password;
- (void) initializeLocationManager;

@end
