//
//  FollowersViewController.m
//  PlateMe
//
//  Created by Kevin Calcote on 3/11/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "FollowersViewController.h"
#import "ProfileViewController.h"
#import "PMLoadingView.h"

@implementation FollowersViewController

@synthesize followersArray;

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
    
    noFollowCell = [[UITableViewCell alloc] init];
    self.followersArray = [[NSMutableArray alloc] init];
    
    noFollowCell.textLabel.textAlignment = UITextAlignmentCenter;
    noFollowCell.textLabel.text = @"Not Following Anyone";
    noFollowCell.userInteractionEnabled = NO;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Load the favorites in the background
    [PMLoadingView invokeWithLoading:@selector(doLoadFollowers) onTarget:self :@"..." :self.view, nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.followersArray = [[PlateMeSession currentSession] followers];
    
    [tableViewInstance reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.followersArray.count == 0)
    {
        return 1;
    }
    
    return self.followersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static UIImage *defaultPostPic = nil;
    UITableViewCell *cell = nil;
    
    if (nil == defaultPostPic)
        defaultPostPic = [[UIImage imageNamed:@"background.png"] retain];
    
    if (self.followersArray.count > 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"FollowersCell"];
        
        if (nil == cell)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FollowersCell"] retain];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        PMFollowerData *followData = [followersArray objectAtIndex:indexPath.row];
        
        //If image hasn't been grabbed then grab it
        if (nil == followData.profileImage)
        {
            //Download the image for the cell in the background
            //If cell is still in view once the image finishes downloading
            //then the downloadProfileImage will assign the image to it
            [cell.imageView setImage:defaultPostPic];
            [followData performSelectorInBackground:@selector(downloadProfileImage:) withObject:cell];
        }
        else
        {
            //Assign the image since it already has been downloaded
            [cell.imageView setImage:followData.profileImage];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",followData.firstName, followData.lastName];
    }
    else
    {
        cell = noFollowCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMFollowerData *followData = [followersArray objectAtIndex:indexPath.row];
    ProfileViewController *profile = (ProfileViewController*)[PlateMeViewController dequeueReusableView:[ProfileViewController class] :navController];
    
    [PMLoadingView invokeWithLoading:@selector(loadSelectedProfile::::) onTarget:[ProfileViewController class] :@"" :self.view, followData.accountId, profile, navController, pmServer,nil]; 
}

-(void) viewControllerRemovedFromNavController
{
    [super viewControllerRemovedFromNavController];
    
    self.followersArray = nil;
}

-(void) doLoadFollowers
{
    //Reload favorites data
    self.followersArray = [pmServer GetFollowers:currentSession.userData.userId]; 
    
    [tableViewInstance performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

-(void) dealloc
{
    [noFollowCell release];
    self.followersArray = nil;
}

@end
