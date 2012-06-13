//
//  LegalView.m
//
//  Created by User on 8/11/11.
//  Copyright 2011 PlateMe.com. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (IBAction)showHomeScreenView:(id)sender
{
    if([emailTextField.text isEqual:@"robfilip@gmail.com"] && [passwordTextField.text isEqual:@"password"])// [self loginSuccess])//
    {
    	[UIView beginAnimations:Nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
        [loginView removeFromSuperview];
        [self addSubview:homeScreenView];
        [UIView commitAnimations];    
    }
    else if([emailTextField.text isEqual:@"steve@gmail.com"] && [passwordTextField.text isEqual:@"steve"])
    {
    	[UIView beginAnimations:Nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
        [loginView removeFromSuperview];
        [self addSubview:homeScreenView];
        [UIView commitAnimations];    
    }
    else
    {
        // Login Failed Alert
        UIAlertView *locationServicesAlert = [[UIAlertView alloc] initWithTitle:@"Login Failed.  Try Again." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [locationServicesAlert show];
        [locationServicesAlert release];
    }
    emailTextField.text = @"";
    passwordTextField.text = @"";
}

- (BOOL)loginSuccess
{
    //MysqlConnection *sqlCon = [[MysqlConnection alloc] init];
    //MysqlConnection *sqlCon = [MysqlConnection connectToHost:@"reconuserbase.db.7884262.hostedresource.com"
    //                                                 user:@"reconuserbase" 
      //                                           password:@"Chicken12!"
        //                                           schema:nil//@"myForumName"
          //                                          flags:MYSQL_DEFAULT_CONNECTION_FLAGS];
    // see if emailTextField.text is in DB MyISAM
    // if it is, see if passwordTextField.text is in DB corresponding to username
    return NO;
}

- (IBAction)showSearchPlateView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[loginView removeFromSuperview];
	[self addSubview:searchPlateView];
	[UIView commitAnimations];
}

- (IBAction)showPlatePhotoView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[loginView removeFromSuperview];
	[self addSubview:platePhotoView];
	[UIView commitAnimations];
}

- (IBAction)showRegisterView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[loginView removeFromSuperview];
	[self addSubview:registerView];
	[UIView commitAnimations];	
}

- (IBAction)emailNextPressed:(id)sender
{
	[passwordTextField becomeFirstResponder];
	return;
}

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

@end
