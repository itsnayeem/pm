//
//  FavoritesViewController.m
//  PlateMe
//
//  Created by Kevin Calcote on 2/26/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "FavoritesViewController.h"
#import "ProfileViewController.h"
#import "PMLoadingView.h"

@implementation FavoritesViewController

@synthesize favoritesArray;
@synthesize requestsArray;

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
    
    noFavoritesCell = [[UITableViewCell alloc] init];
    noRequestsCell = [[UITableViewCell alloc] init];
    
    noFavoritesCell.textLabel.textAlignment = UITextAlignmentCenter;
    noRequestsCell.textLabel.textAlignment = UITextAlignmentCenter;
    
    noFavoritesCell.textLabel.text = @"No Favorites";
    noRequestsCell.textLabel.text = @"No Requests";
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Set to favorites as default
    segmentControl.selectedSegmentIndex = 0;
    
    self.favoritesArray = [[PlateMeSession currentSession] favorites];
    self.requestsArray = [[PlateMeSession currentSession] favoriteRequests];
    
    [self loadSelectedData];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Load the favorites in the background
    [PMLoadingView invokeWithLoading:@selector(doLoadFavorites) onTarget:self :@"Getting Favs" :self.view, nil];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (activeArray.count == 0)
    {
        return 1;
    }
    
    return activeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static UIImage *defaultPostPic = nil;
    UITableViewCell *cell = nil;
    
    if (nil == defaultPostPic)
        defaultPostPic = [[UIImage imageNamed:@"background.png"] retain];
    
    if (activeArray.count > 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"FavoritesCell"];
        
        if (nil == cell)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FavoritesCell"] retain];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        PMFavoriteData *favData = [activeArray objectAtIndex:indexPath.row];
        
        //If image hasn't been grabbed then grab it
        if (nil == favData.profileImage)
        {
            //Download the image for the cell in the background
            //If cell is still in view once the image finishes downloading
            //then the downloadProfileImage will assign the image to it
            [cell.imageView setImage:defaultPostPic];
            [favData performSelectorInBackground:@selector(downloadProfileImage:) withObject:cell];
        }
        else
        {
            //Assign the image since it already has been downloaded
            [cell.imageView setImage:favData.profileImage];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",favData.firstName, favData.lastName];
    }
    else if(activeArray == self.favoritesArray)
    {
        cell = noFavoritesCell;
    }
    else if(activeArray == self.requestsArray)
    {
        cell = noRequestsCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMFavoriteData *favData = [activeArray objectAtIndex:indexPath.row];
    ProfileViewController *profile = (ProfileViewController*)[PlateMeViewController dequeueReusableView:[ProfileViewController class] :navController];
    
    [PMLoadingView invokeWithLoading:@selector(loadSelectedProfile::::) onTarget:[ProfileViewController class] :@"" :self.view, favData.userId, profile, navController, pmServer,nil]; 
}

-(IBAction)favSegmentIndexChanged:(id)sender
{
    [self loadSelectedData];
}

- (void) loadSelectedData
{
    switch (segmentControl.selectedSegmentIndex) 
    {
        case 0:
            activeArray = self.favoritesArray;
            break;
        case 1:
            activeArray = self.requestsArray;
            break;
        default:
            break;
    }
    
    [tableViewInstance reloadData];
}

-(void) doLoadFavorites
{
    //Reload favorites data
    self.favoritesArray = [pmServer GetFavorites:currentSession.userData.userId];
    self.requestsArray = [pmServer GetPendingFavorites:currentSession.userData.userId];
    
    //Reload the table data
    [self performSelectorOnMainThread:@selector(loadSelectedData) withObject:nil waitUntilDone:NO];    
}

-(void) viewControllerRemovedFromNavController
{
    [super viewControllerRemovedFromNavController];
    
    self.favoritesArray = nil;
    self.requestsArray = nil;
}

-(void) dealloc
{
    [noFavoritesCell release];
    [noRequestsCell release];
}

@end
