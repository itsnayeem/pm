//
//  PlatePhotoViewController.m
//  PlateMe
//
//  Created by Kevin Calcote on 1/13/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PlatePhotoViewController.h"

@implementation PlatePhotoViewController

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
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
	input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    //If the input exists then continue
	if (input) 
    {
        session = [[AVCaptureSession alloc] init];
        session.sessionPreset = AVCaptureSessionPresetMedium;
        
        AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        
        //Temporary hack to make things look good
        //should set sizes properly
        [cameraImageView.layer addSublayer:captureVideoPreviewLayer];
        [captureVideoPreviewLayer setFrame:[[UIScreen mainScreen] bounds]];
        [self.view sendSubviewToBack:cameraImageView];
        
        [session addInput:input];
    }
     
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //dynamically take on parent view nav controller
    self.navController = (UINavigationController*)self.parentViewController;
    
    //Store the previous hidden state
    navBarPrevHidden = self.navController.navigationBar.hidden;
    
    //Change hidden status
    [self.navController setNavigationBarHidden:NO animated:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Restore hidden state
    [self.navController setNavigationBarHidden:navBarPrevHidden animated:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    if (input)
    {
        [session startRunning];
	}    
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (input)
    {
        [session stopRunning];
    }
}

- (IBAction)takePicturePressed:(id)sender
{
    // Snap picture
    // Save UIImage into Album "Plate Photos"
    // Crop UIImage to PlateCharacters
    // Use decoding software to extact characters
    NSString *extractedPlateNumber = @"6RCU129";
    NSString *extractedState = @"CA";
    
    // Transition to searchPlateView
    [self searchWithPlateInfo:extractedPlateNumber :extractedState];
}

@end
