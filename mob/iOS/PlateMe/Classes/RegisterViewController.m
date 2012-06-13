//
//  RegisterViewController.m
//  PlateMe
//
//  Created by Kevin Calcote on 1/15/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "RegisterViewController.h"
#import "PMLoadingView.h"

@interface RegisterViewController()

-(void)doRegister:(NSString*)emailToRegister :(NSString*)passwordToRegsiter;

@end

@implementation RegisterViewController

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

- (IBAction)nextPressed:(id)sender
{
    [navController pushViewController:registerViewControllerPg2 animated:YES];
}

-(void)doRegister:(NSString*)emailToRegister :(NSString*)passwordToRegsiter
{
    //Tell the server to register the data
    if ([pmServer Register:emailToRegister :passwordToRegsiter])
    {
        PMUserData *tmpUserData = [pmServer GetUserInfo];
        
        //Create user data
        tmpUserData.firstName = firstName.text;
        tmpUserData.lastName = lastName.text;
        
        //Update the profile with profile data
        //TODO: check for error
        [pmServer UpdateProfile:tmpUserData];
        
        // Notification
        UIAlertView *registrationAlert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"Your information has been submitted and an email will be sent to you within the next 72 hours confirming your registration.  Please continue to use PlateMe anonymously until then." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    
        [registrationAlert show];
        [registrationAlert release];
    
        // Go to the login screen
        [self.navController popToRootViewControllerAnimated:YES];
    }
    else
    {
        // Notification
        UIAlertView *registrationAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Registration Failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        
        [registrationAlert show];
        [registrationAlert release];        
    }
}

- (IBAction)registerPressed:(id)sender
{
    if ([password.text isEqual:confirmPass.text])
    {
        if (![firstName.text isEqual:@""] && ![lastName.text isEqual:@""])
        {
            //Everything checks out, register with the server
            [PMLoadingView invokeWithLoading:@selector(doRegister::) onTarget:self :@"Registering..." :self.view, email.text, password.text,nil];
        }
        else
        {
            // Notification
            UIAlertView *registrationAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please enter a valid first and last name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            
            [registrationAlert show];
            [registrationAlert release];             
        }
    }
    else
    {
        // Notification
        UIAlertView *registrationAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Passwords do not match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        
        [registrationAlert show];
        [registrationAlert release];        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (IBAction)enterBirthdayPressed:(id)sender
{
    if(datePick.hidden==YES)
    {
        datePick.hidden=NO;
        birthdayButton.selected=YES;
        //dateOfBirth.text = @"Done";
    }
    else if(datePick.hidden==NO)
    {
        datePick.hidden=YES;
        //dateOfBirth.text = datePick.date;
    }
    //[dateOfBirth resignFirstResponder];
}

@end
