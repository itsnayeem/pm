//
//  LegalViewController.h
//  PlateMe
//
//  Created by Kevin Calcote on 1/13/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlateMeViewController.h"
#import "LoginViewController.h"

@interface LegalViewController : PlateMeViewController
{
    IBOutlet LoginViewController *loginViewController;
}

- (IBAction)agreePressed:(id)sender;

@end
