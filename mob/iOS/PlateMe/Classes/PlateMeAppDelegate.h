//
//  PlateMeAppDelegate.h
//  PlateMe
//
//  Created by User on 8/10/11.
//  Copyright 2011 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMServer.h"

@interface PlateMeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    IBOutlet UINavigationController *navController;
    IBOutlet PMServer *pmServer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
//@property (nonatomic, retain) IBOutlet UINavigationController *navController;

@end



