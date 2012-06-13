//
//  LoginViewController.m
//  PlateMe
//
//  Created by Kevin Calcote on 1/13/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "LoginViewController.h"
#import "PMLoadingView.h"
#import "PlateMeSession.h"
#import "LocationController.h"
#import "PMOperationQueue.h"

@implementation LoginViewController

@synthesize homeViewController;
@synthesize emailField;
@synthesize passwordField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
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
    //includeSearchBar = true;
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)loginPressed:(id)sender
{
    struct PMSettings settings = [[PlateMeSession currentSession] settings];
    
    if (settings.keepLoggedIn)
    {
        //Update the settings
        strcpy(settings.username, emailField.text.UTF8String);
        strcpy(settings.password, passwordField.text.UTF8String);
        [[PlateMeSession currentSession] setSettings:settings];
    }
    
    [PMLoadingView invokeWithLoading:@selector(doLogin::) onTarget:self :@"Logging In..." :self.view, emailField.text, passwordField.text, nil];
}

- (IBAction)emailDonePressed:(id)sender
{
    //[passwordField becomeFirstResponder];
    [emailField resignFirstResponder]; // Hide keyboard
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([passwordField.text isEqualToString:@""] || [emailField.text isEqualToString:@""])
    {
        //do nothing
    }
    else
    {
        [self loginPressed:nil];
    }
    [textField resignFirstResponder]; // Hide keyboard
    return YES;
}

-(void) initializeLocationManager
{
    //Start getting the location
    [[LocationController sharedInstance] setPmServer:pmServer];
    [[LocationController sharedInstance] setSession:currentSession];
    [[LocationController sharedInstance] start];    
}

- (IBAction)keepLoggedInChanged:(id)sender
{
    UISwitch *theSwitch = (UISwitch*)sender;
    
    struct PMSettings settings = [[PlateMeSession currentSession] settings];
    
    settings.keepLoggedIn = theSwitch.on;
    
    [[PlateMeSession currentSession] setSettings:settings];
}

-(void) doLogin:(NSString*)email :(NSString*)password
{
    @autoreleasepool 
    {
        //Login
        bool loginSuccess = [pmServer Login:email :password :TRUE];
        
        //Check for login success
        if (loginSuccess)   
        {
            //Send the device token to the server
            if (nil != [[PlateMeSession currentSession] deviceToken])
            {
                [pmServer UpdateToken:[[PlateMeSession currentSession] deviceToken]];
            }
            
            //Retrieve the user data for this login and assign it to the current session
            [currentSession setUserData:[pmServer GetUserInfo]];
            [currentSession setFavorites:[pmServer GetFavorites]];
            [currentSession setNotifications:[pmServer GetNotifications]];
            
            //Add the default plate
            PMPlateData *primaryPlate = [pmServer GetPlate];
            if (nil != primaryPlate)
            {            
                [currentSession addPlate:primaryPlate :YES];
                
                //Start the location manager on the main thread
                [self performSelectorOnMainThread:@selector(initializeLocationManager) withObject:nil waitUntilDone:YES];
            }
            
            //Get favorites
            currentSession.favorites = [pmServer GetFavorites];
            currentSession.favoriteRequests = [pmServer GetPendingFavorites];
            
            //Get followers
            currentSession.followers = [pmServer GetFollowers];
            
            //Clear the password
            [passwordField performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:NO];
            
            //Go to the home screen based on the nav controller
            [self.view.window performSelectorOnMainThread:@selector(addSubview:) withObject:homeViewController.navController.view waitUntilDone:YES];
            
            [self.view.window performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
        }
        else
        {
            //Show the failed login alert
            UIAlertView *loginFailureAlert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [loginFailureAlert show];
            [loginFailureAlert release];
        }
    }
}

- (IBAction)registerPressed:(id)sender
{
    [self.navController pushViewController:registerViewController animated:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Change hidden status
    [self.navController setNavigationBarHidden:YES animated:YES];
    
    keepLoggedInSwitch.on = [[PlateMeSession currentSession] settings].keepLoggedIn;
}


@end
