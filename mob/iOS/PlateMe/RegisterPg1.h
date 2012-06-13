//
//  RegisterPg1.h
//
//  Created by User on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface RegisterPg1 : UIView
{
	IBOutlet UITextField *emailTextField;
	IBOutlet UITextField *passwordTextField;
	IBOutlet UITextField *confirmPasswordTextField;
	IBOutlet UIView *registerPg1View;
	IBOutlet UIView *homeScreenView;
	IBOutlet UIView *platePhotoView;
	IBOutlet UIView *searchPlateView;
	IBOutlet UIView *registerPg2View;
}

- (IBAction)showRegisterPg2View:(id)sender;
- (IBAction)showPlatePhotoView:(id)sender;
- (IBAction)showSearchPlateView:(id)sender;
- (IBAction)emailNextPressed:(id)sender;
- (IBAction)passwordNextPressed:(id)sender;
- (IBAction)confirmPasswordDonePressed:(id)sender;
- (IBAction)birthdayDonePressed:(id)sender;
- (IBAction)showLastView:(id)sender;
- (IBAction)showHomeScreenView:(id)sender;

@end
