//
//  RegisterViewController.h
//  PlateMe
//
//  Created by Kevin Calcote on 1/15/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PlateMeViewController.h"

@class LoginViewController;

@interface RegisterViewController : PlateMeViewController <UITextFieldDelegate>
{
    IBOutlet RegisterViewController *registerViewControllerPg2;
    IBOutlet UITextField *email;
    IBOutlet UITextField *password;
    IBOutlet UITextField *confirmPass;
    IBOutlet UITextField *firstName;
    IBOutlet UITextField *lastName;
    IBOutlet UIButton *birthdayButton;
    //IBOutlet UITextField *dateOfBirth;
    IBOutlet UIDatePicker *datePick;
}

- (IBAction)nextPressed:(id)sender;
- (IBAction)registerPressed:(id)sender;
- (IBAction)enterBirthdayPressed:(id)sender;

@end
