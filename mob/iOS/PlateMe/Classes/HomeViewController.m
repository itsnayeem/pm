//
//  HomeViewController.m
//  PlateMe
//
//  Created by Kevin Calcote on 1/14/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "PMLoadingView.h"
#import "ProfileViewController.h"
#import "FavoritesViewController.h"
#import "FollowersViewController.h"
#import "LocationController.h"
#import "PhotosViewController.h"
#import "WhatsUpViewController.h"
#import "CustomBadge.h"

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    //Tell the view controller to include the refresh button
    includeRefreshButton = YES;
    
    [super viewDidLoad];
    
    /******WEIRD WORKAROUND TO GET SCROLL TO TOP TO WORK, actually a no op***************/
    UIActionSheet *accountAction = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Log Out" otherButtonTitles:@"Account Settings", @"Privacy Settings", @"Help Center", nil];
    
    [accountAction showInView:[self view]];
    [accountAction dismissWithClickedButtonIndex:0xFFFFFFFF animated:NO];
    [accountAction release];
    /*************************************************************************************/
    
    //Tmp
    imagePicker = [[[UIImagePickerController alloc] init] retain];
    
    [[PlateMeSession currentSession] addNotificationReceiver:self :@selector(notificationReceived:)];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshNotifications];
}

- (void) refreshNotifications
{
    [notificationsBadge removeFromSuperview];
    [profileBadge removeFromSuperview];
    
    if (nil != currentSession.notifications && currentSession.notifications.count > 0)
    {
        NSInteger profileNotifications = 0;
        
        notificationsBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", currentSession.notifications.count] withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor whiteColor] withScale:1.0 withShining:YES];
        
        [self.view addSubview:notificationsBadge];
        
        notificationsBadge.center = CGPointMake(notificationsButton.center.x - 80, notificationsButton.center.y);
        
        for (PMNotificationData *notificationData in currentSession.notifications)
        {
            if ([notificationData.type isEqualToString:@"plate"])
                profileNotifications++;
        }
        
        if (profileNotifications > 0)
        {
            profileBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d",profileNotifications] withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor whiteColor] withScale:1.0 withShining:YES];
            
            [self.view addSubview:profileBadge];
            
            profileBadge.center = CGPointMake(profileButton.frame.origin.x + profileButton.frame.size.width, profileButton.frame.origin.y);
        }
    }
    else
    {
        notificationsBadge = nil;
    }
}

- (IBAction)notificationsPressed:(id)sender
{
    //Refresh notifications
    [self refreshNotifications];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) accountButtonPressed:(id)sender
{
    UIActionSheet *accountAction = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Log Out" otherButtonTitles:@"Account Settings", @"Privacy Settings", @"Help Center", nil];
    
    [accountAction showInView:[self view]];
    [accountAction release];
}

- (void) notificationReceived:(NSDictionary*)userInfo
{
    PlateMeSession *session = [PlateMeSession currentSession];
    
    session.notifications = [pmServer GetNotifications];
    
    [self refreshNotifications];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Take some account action
    switch (buttonIndex) {
        case 0:
            //Handle Log Out
            [PMLoadingView invokeWithLoading:@selector(doLogout) onTarget:self :@"Logging Out..." :self.view, nil];
            break;
        case 1:
            //Handle Account Settings
            break;
        case 3:
            //Handle Privacy Settings
            break;
        case 4:
            //Handle Help Center
            break;
        default:
            //Cancel
            break;
    }
}

- (void) doLogout
{
    
    //Logout, no need to check status
    [pmServer Logout];
    
    //Delete the logged in data
    PlateMeSession *session = [PlateMeSession currentSession];
    [session setUserData:nil];
    [session.locationData clearLocations];
    [session.favoriteRequests removeAllObjects];
    [session.favorites removeAllObjects];
    [session.followers removeAllObjects];
    
    //Stop location manager on the main thread
    [self performSelectorOnMainThread:@selector(stopLocationManager) withObject:nil waitUntilDone:YES];
    
    //Go to the login screen since we have logged out
    [self.view.window performSelectorOnMainThread:@selector(addSubview:) withObject:loginViewController.navController.view waitUntilDone:YES];
        
    [self.view.window performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
    
    [PlateMeViewController performSelectorOnMainThread:@selector(removeAllReusableViews) withObject:nil waitUntilDone:YES];
}

-(void) stopLocationManager
{
    //Stop collecting location data
    [[LocationController sharedInstance] stop];    
}

- (IBAction) buttonPressed:(id)sender
{
    UIButton *theButton = (UIButton *)sender;
    
    //Determine what homescreen button was pressed
    switch (theButton.tag) {
        case 1:
        {
            //Profile button
            
            //Dequeue an available profile view
            ProfileViewController *profile = (ProfileViewController*)[PlateMeViewController dequeueReusableView:[ProfileViewController class] :navController];
            
            //Show it
            [profile setCurrentSession:[PlateMeSession currentSession]];
            [self.navController pushViewController:profile animated:YES];
            break;
        }
        case 2:
        {
            //Favorites view
            //Dequeue an available favorites view
            WhatsUpViewController *supViewController = (WhatsUpViewController*)[PlateMeViewController dequeueReusableView:[WhatsUpViewController class] :navController];
            
            //Set session as the logged in one
            supViewController.currentSession = [PlateMeSession currentSession];
            
            //Show it
            [self.navController pushViewController:supViewController animated:YES];
            break;
        }
        case 3:
        {
            //Favorites view
            //Dequeue an available favorites view
            FavoritesViewController *favController = (FavoritesViewController*)[PlateMeViewController dequeueReusableView:[FavoritesViewController class] :navController];
            
            //Set session as the logged in one
            favController.currentSession = [PlateMeSession currentSession];
            
            //Show it
            [self.navController pushViewController:favController animated:YES];
            break;
        }
        case 6:
        {            
            //Photos view
            PhotosViewController *photoController = [[PhotosViewController alloc] init];
            
            photoController.navController = self.navController;
            photoController.currentSession = currentSession;
            [photoController viewDidLoad];
            
            //Show it
            [self.navController pushViewController:photoController animated:YES];
            
            [photoController release];
            
            break;
        }
        case 7:
        {
            //Following  view
            //Dequeue an available followers view
            FollowersViewController *followController = (FollowersViewController*)[PlateMeViewController dequeueReusableView:[FollowersViewController class] :navController];
            
            //Set session as the logged in one
            followController.currentSession = [PlateMeSession currentSession];
            
            //Show it
            [self.navController pushViewController:followController animated:YES];
            break;
        }
        case 9:
            //Places button
            [self.navController pushViewController:placesViewController animated:YES];
            break;
        default:
            //Default to coming soon
            [self.navController pushViewController:comingSoonViewController animated:YES];
            break;
    }
}

-(void) dealloc
{
    [notificationsBadge release];
}

@end
