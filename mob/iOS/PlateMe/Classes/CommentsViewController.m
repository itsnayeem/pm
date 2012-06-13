//
//  CommentsViewController.m
//  PlateMe
//
//  Created by Kevin Calcote on 2/21/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "CommentsViewController.h"
#import "ProfileViewController.h"
#import "WhatsUpViewController.h"
#import "PMLoadingView.h"
#import <MediaPlayer/MPMoviePlayerViewController.h>

@interface CommentsViewController()
-(void) doCommentsLoad;
-(void) loadComments:(PMPostData*)postData;
-(void) renewMainPost:(PMPostData*)postData;
-(void) setupMainPost:(PostTableCell*)refCell;
@end

@implementation CommentsViewController

@synthesize postTableViewController;
@synthesize mainPost;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void) initialize:(PlateMeViewController*) profileController :(PostTableCell*)parentCell :(BOOL)showFromBottom
{
    parentProfileViewController = profileController;
    
    if ([profileController isKindOfClass:[ProfileViewController class]])
        postTableViewController.delegate = (ProfileViewController*)parentProfileViewController;
    else  if ([profileController isKindOfClass:[WhatsUpViewController class]])
        postTableViewController.delegate = (WhatsUpViewController*)parentProfileViewController;
    
    mainPost = [postTableViewController createNewPost];
    
    [postTableViewController fillCellWithPostData:mainPost :parentCell.postData];
    
    //Set bottom flag
    displayAtBottom = showFromBottom;
    
    [self setupMainPost:parentCell];
}

- (void) setupMainPost:(PostTableCell*)refCell
{
    //Adjust header view
    CGRect headerFrame = headerView.frame;
    headerFrame.size.height = refCell.frame.size.height+30;
    [headerView setFrame:headerFrame];
    
    //Set the main posts size
    CGRect mainPostFrame = refCell.bounds;
    mainPostFrame.origin.x = 0;
    mainPostFrame.origin.y = 0;
    mainPostFrame.size.width += 47;
    [mainPost setFrame:mainPostFrame];
    
    [mainPost.commentButton setHidden:YES];
    [mainPost.turnButton setHidden:YES];
    [headerView addSubview:[mainPost retain]];
    CGRect parentPostFrame = mainPost.frame;
    parentPostFrame.origin.x = 0;
    parentPostFrame.origin.y = 10;
    [mainPost setFrame:parentPostFrame];    
}

-(void) refreshCommentsWithWallData:(PMWallData*)wallData
{
    for (PMPostData *post in wallData.posts)
    {
        if ([post.postId isEqualToString:mainPost.postData.postId])
        {
            [self loadComments:post];
        }
    }    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (displayAtBottom)
    {
        //Move to bottom
        [postTableViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(([mainPost.postData.comments count] * 2) - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void) viewControllerRemovedFromNavController
{
    [super viewControllerRemovedFromNavController];

    parentProfileViewController.currentCommentsViewController = nil;
    [mainPost removeFromSuperview];
    [mainPost release];
}

-(void) viewDidLoad
{
    includeRefreshButton = YES;
    
    [super viewDidLoad];
    
    [tableViewInstance setSeparatorColor:[UIColor clearColor]];
    
    postTableViewController = [[[PostTableViewController alloc] init] retain];
    postTableViewController.commentButtonHidden = YES;
    postTableViewController.tableView = tableViewInstance;
    
    [headerView setClipsToBounds:YES];
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

- (IBAction)refreshViewData:(id)sender
{
    [super refreshViewData:sender];
    
    //invoke the profile loading in the background with a loading cicle
    [PMLoadingView invokeWithLoading:@selector(doCommentsLoad) onTarget:self :@"Refreshing..." :self.view, nil];
}

-(void) renewMainPost:(PMPostData*)postData
{
    //Release the main post at the top and create/fill the new one
    PostTableCell *tmpCell = mainPost;
    [mainPost removeFromSuperview];
    
    mainPost = [postTableViewController createNewPost];
    [postTableViewController fillCellWithPostData:mainPost :postData];
    
    [self setupMainPost:tmpCell];
    
    [tmpCell release];
}

-(void)loadComments:(PMPostData*)postData
{
    [self performSelectorOnMainThread:@selector(renewMainPost:) withObject:postData waitUntilDone:YES];
    
    //Assign the comments
    postTableViewController.posts = postData.comments;
    
    [mainPost setNeedsDisplay];
    
    //Finished getting data from server, execute refresh on main thread
    [postTableViewController.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO]; 
}

-(void) doCommentsLoad
{
    //Grab plate from session
    PMPlateData *plateData = [parentProfileViewController.currentSession getPlate];    
    
    //Get wall data from server
    plateData.wallData = [pmServer GetWallData:plateData.plateId];
    
    NSMutableArray *posts = [[[parentProfileViewController.currentSession getPlate:plateData.plateId] wallData] posts];
    
    for (PMPostData *post in posts)
    {
        if ([post.postId isEqualToString:mainPost.postData.postId])
        {
            [self loadComments:post];
        }
    }
}

- (void) postImageClicked:(PostTableViewController *)postTableController :(PostTableCell *)cell
{
    //Photos view
    //Dequeue an available photos view
    PhotosViewController *photoController = (PhotosViewController*)[PlateMeViewController dequeueReusableView:[PhotosViewController class] :navController];
    
    if (photoController.currentSession != currentSession)
    {
        [photoController initialize];
    }
    
    if ([[[[PlateMeSession currentSession] userData] userId] isEqualToString:cell.postData.ownerId])
    {
        photoController.currentSession = currentSession;
    }
    else
    {
        PlateMeSession *session = [[PlateMeSession alloc] init];
        session.userData = [pmServer GetUserInfo:cell.postData.ownerId];
        photoController.currentSession = session;
    }
    
    //Show it
    //[self.navController pushViewController:photoController animated:YES];  
    [photoController showImageFromGallery:cell.postData.postImageUrl];
}

- (void) postVideoClicked:(PostTableViewController *)postTableController :(PostTableCell *)cell
{
    NSURL *videoURL = [NSURL URLWithString:cell.postData.postVideoUrl];
    MPMoviePlayerViewController *moviePlayerView = [[[MPMoviePlayerViewController alloc] initWithContentURL:videoURL] autorelease];
    [self presentMoviePlayerViewControllerAnimated:moviePlayerView];
}

@end