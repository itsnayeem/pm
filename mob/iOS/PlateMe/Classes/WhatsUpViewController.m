//
//  WhatsUpViewController.m
//  PlateMe
//
//  Created by Kevin Calcote on 3/31/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "WhatsUpViewController.h"
#import "PostTableViewController.h"
#import "CommentsViewController.h"
#import "ProfileViewController.h"
#import "PMLoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MPMoviePlayerViewController.h>

@implementation WhatsUpViewController

@synthesize feedData;

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
    includeRefreshButton = YES;
    
    [super viewDidLoad];
    
    [tableViewInstance setSeparatorColor:[UIColor clearColor]];
    postTableViewController = [[PostTableViewController alloc] init];
    postTableViewController.tableView = tableViewInstance;
    postTableViewController.delegate = self;
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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [PMLoadingView invokeWithLoading:@selector(doFeedLoad) onTarget:self :@"wut Sup?" :self.view, nil];
}

-(void) doFeedLoad
{
    self.feedData = [pmServer GetFeed];
    
    postTableViewController.posts = self.feedData.posts;
    
    //Finished getting data from server, execute refresh on main thread
    [postTableViewController.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO]; 
}

- (IBAction)refreshViewData:(id)sender
{
    [super refreshViewData:sender];
    
    [PMLoadingView invokeWithLoading:@selector(doFeedLoad) onTarget:self :@"Wut Sup?" :self.view, nil];
}

-(void) dealloc
{
    [postTableViewController release];
}

-(void) deletePost:(PostTableViewController*)postTableController :(NSString*)postId
{
    //Delete the post on a background thread
    [PMLoadingView invokeWithLoading:@selector(doDeletePost::) onTarget:self :@"Deleting..." :postTableController.view.superview, [postId retain], postTableController.tableView,nil];    
}

-(void) doDeletePost:(NSString*)postId :(UITableView*)tableView
{
    //Post the data
    [pmServer DeletePost:postId];
    
    [self doFeedLoad];
    
    if(currentCommentsViewController != nil)
        [currentCommentsViewController refreshCommentsWithWallData:[[currentSession getPlate] wallData]];
    
    if (nil != tableView)
    {
        [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
}

-(void) postOwnerNameClicked:(PostTableViewController *)postTableController :(NSString *)ownerId
{
    if ( (nil !=ownerId) &&
        (![ownerId isEqualToString:@""]) &&
        (![ownerId isEqualToString:@"0"]) &&
        (![ownerId isEqualToString:currentSession.userData.userId]) )
    {
        ProfileViewController *profile = (ProfileViewController*)[PlateMeViewController dequeueReusableView:[ProfileViewController class] :navController];
        
        [PMLoadingView invokeWithLoading:@selector(loadSelectedProfile::::) onTarget:[ProfileViewController class] :@"" :self.view, ownerId, profile, navController, pmServer,nil]; 
    }
}

-(void) doRatePost:(NSString*)postId :(NSString*)rating :(PostTableViewController*)postTableController
{
    [pmServer RatePost:postId :rating];
    
    [self doFeedLoad];
    
    if(currentCommentsViewController != nil)
        [currentCommentsViewController refreshCommentsWithWallData:[[currentSession getPlate] wallData]];
    
    [postTableViewController.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void) StarRatingUpdated:(PostTableViewController*)postTableController :(NSString *)rating :(NSString*)postId
{
    //Invoke rating in the background
    NSMethodSignature *signature = [self methodSignatureForSelector:@selector(doRatePost:::)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:@selector(doRatePost:::)];
    [invocation setArgument:&postId atIndex:2];
    [invocation setArgument:&rating atIndex:3];
    [invocation setArgument:&postTableController atIndex:4];
    
    [invocation performSelectorInBackground:@selector(invoke) withObject:nil];
}

-(CommentsViewController*) displayComments:(PostTableCell*)cell :(BOOL)showFromBottom
{
    CommentsViewController *commentsController = (CommentsViewController*)[PlateMeViewController dequeueReusableView:[CommentsViewController class] :navController];
    
    [commentsController initialize:self :cell :showFromBottom];
    commentsController.postTableViewController.posts = cell.postData.comments;
    [commentsController.postTableViewController.tableView reloadData];
    
    currentCommentsViewController = commentsController;
    
    [navController pushViewController:commentsController animated:YES];
    
    return commentsController;
}

-(BOOL) postCanBeEdited:(PMPostData *)postData
{
    if (!disablePostEdit)
    {
        PMUserData *loggedInUserData = [[PlateMeSession currentSession] userData];
        
        if (nil != postData &&
            nil != postData.ownerId &&
            ![currentSession.userData.userId isEqual:@"0"] &&
            ([postData.ownerId isEqual:loggedInUserData.userId] ||
             (currentSession == [PlateMeSession currentSession])))
        {
            return YES;
        }
    }
    
    return NO;
}

-(void) starRatingViewAppeared:(StarRatingView*)starRatingView
{
    disablePostEdit = YES;
}

-(void) starRatingViewDisappeared:(StarRatingView*)starRatingView
{
    disablePostEdit = NO;
}

-(void) newComment:(PostTableCell *)postCell
{
    topPost = postCell;
    
    UITextView *commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(160, 100, 0, 0)];
    
    commentTextView.delegate = self;
    
    commentTextView.layer.borderWidth = 4.0;
    commentTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    commentTextView.layer.cornerRadius = 10.0;
    
    commentTextView.returnKeyType = UIReturnKeySend;
    
    [self.view addSubview:commentTextView];
    
    [UIView animateWithDuration:0.25
                     animations:^
     {
         CGRect textViewRect = commentTextView.frame;
         textViewRect.origin.x = 0;
         textViewRect.origin.y = 0;
         textViewRect.size.width = 320;
         textViewRect.size.height = 200;
         commentTextView.frame = textViewRect;
         
         [commentTextView becomeFirstResponder];                      
     }
                     completion:^(BOOL finished)
     {
         [commentTextView release];
     }];   
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL isValid = YES;
    
    if (text.length > 0)
    {
        unichar last = [text characterAtIndex:[text length] - 1];
        
        //Check for the return key
        if (text.length == 1 && last == '\n')
        {
            //Drop down keyboard
            [textView resignFirstResponder];

            //Duplicate the text to prevent contention
            NSString *textToPost = [[NSString stringWithString:textView.text] retain];
            
            [PMLoadingView invokeWithLoading:@selector(doPost:::) onTarget:self :@"Posting..." :self.view, topPost.postData.plateId, textToPost, topPost, nil];
            [textView removeFromSuperview];
            
            return NO;
        }
    }
    
    return isValid;
}

-(CommentsViewController*) displayCommentsAndGoToBottom:(PostTableCell*)cell
{
    CommentsViewController *addedController = [self displayComments:cell :YES];
    
    return addedController;
}

-(void) doPost:(NSString*) plateId :(NSString*)content :(PostTableCell*)parentPost
{
    //Post the data
    if (nil == parentPost)
        [pmServer AddPost:plateId :content :@"0"];
    else
        [pmServer AddPost:plateId :content :parentPost.postData.postId];
    
    //Reload the profile
    [self doFeedLoad];
    
    if (nil != parentPost)
    {
        //Get the new post data and display it for the user
        PMPostData *postData = [PMWallData findPost:postTableViewController.posts:parentPost.postData.postId];
        
        parentPost.postData = [postData retain];
        
        [self performSelectorOnMainThread:@selector(displayCommentsAndGoToBottom:) withObject:[parentPost retain] waitUntilDone:NO];
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
