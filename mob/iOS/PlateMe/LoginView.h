//
//  LegalView.h
//
//  Created by User on 8/11/11.
//  Copyright 2011 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface LoginView : UIView
{
	IBOutlet UITextField *emailTextField;
	IBOutlet UITextField *passwordTextField;
	IBOutlet UIView *loginView;
    IBOutlet UIView *homeScreenView;
	IBOutlet UIView *platePhotoView;
	IBOutlet UIView *searchPlateView;
	IBOutlet UIView *accountView;
	IBOutlet UIView *registerView;
}

- (IBAction)showHomeScreenView:(id)sender;
- (IBAction)showPlatePhotoView:(id)sender;
- (IBAction)showSearchPlateView:(id)sender;
- (IBAction)emailNextPressed:(id)sender;
- (IBAction)showRegisterView:(id)sender;
- (BOOL)loginSuccess;
//+ (MysqlConnection *)connectToHost:(NSString *)host
              //                user:(NSString *)user
                //          password:(NSString *)password
                  //          schema:(NSString *)schema
                    //         flags:(unsigned long)flags;

@end