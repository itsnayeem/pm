//
//  PlateMeViewController.m
//  PlateMe
//
//  Created by Kevin Calcote on 1/14/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PlateMeViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "ProfileViewController.h"
#import "SearchPlateViewController.h"
#import "PlatePhotoViewController.h"

@implementation PlateMeViewController

@synthesize navController;
@synthesize currentCommentsViewController;

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

- (void) overrideBackButton
{
    if (![self isEqual:self.navigationController.topViewController])
    {
        // Create an UIButton
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom]; 
        // Set its background image for some states...
        [button setBackgroundImage: [UIImage imageNamed:@"BackButton.png"] forState:UIControlStateNormal];  
        // Add target to receive Action
        [button addTarget: self action:@selector(backToLastView:) forControlEvents:UIControlEventTouchUpInside]; 
        // Set frame width, height
        button.frame = CGRectMake(0, 0, 40, 20);  
        // Add this UIButton as a custom view to the self.navigationItem.leftBarButtonItem
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView: button] autorelease];       
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pmServer = [PMServer sharedInstance];
    currentSession = [PlateMeSession currentSession];
    
    if (includeRefreshButton)
    {
        // Create an UIButton
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom]; 
        // Set its background image for some states...
        [button setBackgroundImage: [UIImage imageNamed:@"RefreshButton.png"] forState:UIControlStateNormal];  
        // Add target to receive Action
        [button addTarget: self action:@selector(refreshViewData:) forControlEvents:UIControlEventTouchUpInside]; 
        // Set frame width, height
        button.frame = CGRectMake(0, 0, 25, 25);  
        // Add this UIButton as a custom view to the self.navigationItem.leftBarButtonItem
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView: button] autorelease];
    }
    
    [self overrideBackButton];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)searchByImage:(id)sender
{
    PlatePhotoViewController* photoSearchController = (PlatePhotoViewController*)[PlateMeViewController dequeueReusableView:[PlatePhotoViewController class] :navController];    
    
    [self.navController pushViewController:(UIViewController *)photoSearchController animated:YES];
}

- (IBAction)searchByText:(id)sender
{
    SearchPlateViewController* searchController = (SearchPlateViewController*)[PlateMeViewController dequeueReusableView:[SearchPlateViewController class] :navController];
    
    [self.navController pushViewController:(UIViewController *)searchController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)refreshViewData:(id)sender
{
}

- (IBAction)backToLastView:(id)sender
{
    [self.navController popViewControllerAnimated:YES];
}

-(void)setCurrentSession:(PlateMeSession *)currentSessionL
{
    if (currentSession != [PlateMeSession currentSession])
    {
        [currentSession release];
    }
    
    currentSession = currentSessionL;
}

- (void) viewControllerRemovedFromNavController
{
    //Nothing
}

-(PlateMeSession*)currentSession
{
    return currentSession;
}

+ (id) createNewViewFromNib:(NSString*)nibName :(Class)classType
{
    id nibItem = nil;
    
    //Loop through nib looking for the proper view
    for (id loadedObject in [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil]) 
    {
        //Check for the postcell
        if ([loadedObject isKindOfClass:classType]) 
        {
            nibItem = loadedObject;
            [nibItem retain];
            break;
        }
    }
    
    return nibItem;    
}

+ (id) dequeueReusableView:(Class)classType :(UINavigationController*)navC
{
    return [PlateMeViewController dequeueReusableView:classType :navC :@"Dynamic"];
}

+ (id) dequeueReusableView:(Class)classType :(UINavigationController*)navC :(NSString*)nibName
{
    id reusableView = nil;
    NSMutableArray *arrayToUse = [PlatePhotoViewController reusableViews:classType :YES];
    
    
    if ([arrayToUse count] > 0)
    {
        reusableView = [arrayToUse objectAtIndex:0];
        [arrayToUse removeObject:reusableView];
    }
    else
    {
        reusableView = [PlateMeViewController createNewViewFromNib:nibName :classType];
    }    
    
    if ([reusableView isKindOfClass:[PlateMeViewController class]])
        ((PlateMeViewController*)reusableView).navController = navC;
    
    return reusableView;
}

+ (void)enqueueReusableView:(id)reusableView
{
    [[PlateMeViewController reusableViews:[reusableView class] :NO] addObject:reusableView];
}

+ (NSMutableArray*)reusableViews:(Class)classType :(BOOL)allowCreate
{
    NSMutableDictionary *viewDictionary = [PlateMeViewController reusableViewDictionary];
    
    NSMutableArray *views = [viewDictionary valueForKey:[classType description]];
    
    if (allowCreate && (nil == views))
    {
        views = [[[NSMutableArray alloc] init] retain];
        [viewDictionary setValue:views forKey:[classType description]];
    }
    
    return views;
}

+ (NSMutableDictionary*)reusableViewDictionary
{
    static NSMutableDictionary *viewDictionary;
    
    if (nil == viewDictionary)
    {
        viewDictionary = [[[NSMutableDictionary alloc] init] retain];
    }
    
    return viewDictionary;
}

+ (void) removeAllReusableViews
{
    [[PlateMeViewController reusableViewDictionary] removeAllObjects];
}

- (void) searchWithPlateInfo:(NSString*)plate :(NSString*)state
{
    SearchPlateViewController* searchController = (SearchPlateViewController*)[PlateMeViewController dequeueReusableView:[SearchPlateViewController class] :navController];
    
    [searchController initializeSearch:plate :state];
    
    [self.navController pushViewController:(UIViewController *)searchController animated:YES];
}

- (UIImagePickerController*) imagePicker
{
    static UIImagePickerController *picker = nil;
    
    if (nil == picker)
        picker = [[[UIImagePickerController alloc] init] retain];
    
    return picker;
}

@end
