//
//  PlateMeAppDelegate.h
//  PlateMe
//
//  Created by User on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlateMeViewController;

@interface PlateMeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PlateMeViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PlateMeViewController *viewController;

@end

