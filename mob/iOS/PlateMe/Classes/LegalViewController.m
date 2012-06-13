//
//  LegalViewController.m
//  PlateMe
//
//  Created by Kevin Calcote on 1/13/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "LegalViewController.h"
#import "PMLoadingView.h"

@implementation LegalViewController

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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (IBAction)agreePressed:(id)sender
{
    struct PMSettings settings = [[PlateMeSession currentSession] settings];
    
    //Go to the home screen based on the nav controller
    [self.view.window addSubview:loginViewController.navController.view];
    
    if (settings.keepLoggedIn && (settings.username[0] != 0) && (settings.password[0] != 0))
    {
        NSString *password = [NSString stringWithCString:settings.password encoding:NSUTF8StringEncoding];
        NSString *username = [NSString stringWithCString:settings.username encoding:NSUTF8StringEncoding];
        
        loginViewController.emailField.text = username;
        loginViewController.passwordField.text = password;
        
       [PMLoadingView invokeWithLoading:@selector(doLogin::) onTarget:loginViewController :@"Logging In..." :loginViewController.navController.view, username, password, nil]; 
    }
    
    [self.view removeFromSuperview];
}
@end
