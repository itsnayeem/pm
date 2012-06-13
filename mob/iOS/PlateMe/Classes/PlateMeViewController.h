//
//  PlateMeViewController.h
//  PlateMe
//
//  Created by Kevin Calcote on 1/14/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMServer.h"
#import "PlateMeSession.h"

@class CommentsViewController;

@interface PlateMeViewController : UIViewController
{
    IBOutlet UINavigationController *navController;
    BOOL includeRefreshButton;
    PMServer *pmServer;
    BOOL navBarPrevHidden;
    PlateMeSession *currentSession;
    CommentsViewController *currentCommentsViewController;
}

@property (retain) PlateMeSession *currentSession;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (assign) CommentsViewController *currentCommentsViewController;

- (IBAction)refreshViewData:(id)sender;
- (IBAction)backToLastView:(id)sender;
- (IBAction)searchByImage:(id)sender;
- (IBAction)searchByText:(id)sender;

- (void) overrideBackButton;
- (void) viewControllerRemovedFromNavController;
- (void) searchWithPlateInfo:(NSString*)plate :(NSString*)state;
- (UIImagePickerController*) imagePicker;
+ (id) dequeueReusableView:(Class)classType :(UINavigationController*)navC;
+ (NSMutableArray*)reusableViews:(Class)classType :(BOOL)allowCreate;
+ (void)enqueueReusableView:(id)reusableView;
+ (id) createNewViewFromNib:(NSString*)nibName :(Class)classType;
+ (id) dequeueReusableView:(Class)classType :(UINavigationController*)navC :(NSString*)nibName;
+ (void) removeAllReusableViews;
+ (NSMutableDictionary*)reusableViewDictionary;

@end
