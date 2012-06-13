//
//  ProfileViewController.m
//  PlateMe
//
//  Created by Kevin Calcote on 1/14/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PMLoadingView.h"
#import "CommentsViewController.h"
#import "FollowersViewController.h"
#import "FavoritesViewController.h"
#import "PMUtilities.h"
#import <MediaPlayer/MPMoviePlayerViewController.h>

@interface ProfileViewController()
    
-(void) doProfileLoad;
-(void) clearAndResignPost;
-(void) doPost:(NSNumber*)reqNum :(NSString*) plateId :(NSString*)content :(PostTableCell*)parentPost :(UIImage*)imageToPost :(NSURL*)videoUrl;
-(void) doDeletePost:(NSString*)postId :(UITableView*)tableView;
-(void) loadSelectedProfile:(NSString*)accountId :(ProfileViewController*)profile;
-(void) animateToolbar;
-(void) doRatePost:(NSString*)postId :(NSString*)rating :(PostTableViewController*)postTableController;
-(void) doAddFavorite:(NSString*)accountId;
-(void) doAddFollower:(NSString*)plateId;
-(void) doChangeProfilePic:(NSNumber*)requestId :(UIImage*)imageSelected;

@end

@implementation ProfileViewController

@synthesize skipProfileLoad;

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
    
    postViewDisplayed = NO;
    
    [tableViewInstance setSeparatorColor:[UIColor clearColor]];
    
    defaultProfilePic = [[UIImage imageNamed:@"profile.png"] retain];
    
    postTableViewController = [[PostTableViewController alloc] init];
    postTableViewController.commentButtonHidden = NO;
    postTableViewController.tableView = tableViewInstance;
    postTableViewController.delegate = self;
    
    removeFavoriteImage = [[UIImage imageNamed:@"RemoveFavorite.png"] retain];
    addFavoriteImage = [[UIImage imageNamed:@"profileFavoriteButton.png"] retain];
    
    removeFollowerImage = [[UIImage imageNamed:@"UnFollow-1.png"] retain];
    addFollowerImage = [[UIImage imageNamed:@"profileFollowButton.png"]retain];
    
    followersImage = [[UIImage imageNamed:@"profileFollowers.png"] retain];
    favoritesImage = [[UIImage imageNamed:@"profileFavorites.png"] retain];
    
    profileImageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [postView setClipsToBounds:YES];
    
    imagePostSettings.imageFrame = postImageView.frame;
    imagePostSettings.textFrame = postTextView.frame;
    
    textPostSettings.imageFrame = CGRectMake(0, 0, 0, 0);
    textPostSettings.textFrame = CGRectMake(20, 30, 289, 113);
}


- (void)viewDidUnload
{

    [super viewDidUnload];
    
    [postTableViewController release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //dynamically take on parent view nav controller
    self.navController = (UINavigationController*)self.parentViewController;
    
    //Store the previous hidden state
    navBarPrevHidden = self.navController.navigationBar.hidden;
    
    //Override the back button
    [self overrideBackButton];
    
    //Change hidden status
    [self.navController setNavigationBarHidden:NO animated:YES];
    
    //Populate the user info
    [name setText:[NSString stringWithFormat:@"%@%@%@", currentSession.userData.firstName, @" ", currentSession.userData.lastName]];
    
    //Grab plate from session
    PMPlateData *plateData = [currentSession getPlate];
    
    //Set plate info on profile page
    [vehicle setText:[NSString stringWithFormat:@"%@%@%@%@%@", plateData.year, @" ", plateData.make, @" ", plateData.model]];
    [color setText:plateData.color];
    [plate setText:[NSString stringWithFormat:@"%@%@%@", plateData.plateNumber, @", ", plateData.state]];
    
    //Set ther profile image view to the default
    profileImageButton.imageView.image = defaultProfilePic;
    
    //Clear the table
    [postTableViewController clearTable];
    
    //Check if this is the logged in users profile
    if ([PlateMeSession currentSession] == currentSession)
    {
        [addFavoriteButton setImage:favoritesImage forState:UIControlStateNormal];
        [addFollowerButton setImage:followersImage forState:UIControlStateNormal];
    }
}

-(void) setCurrentSession:(PlateMeSession *)currentSessionL
{
    [super setCurrentSession:currentSessionL];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //invoke the profile loading in the background with a loading cicle
    if(!skipProfileLoad)
    {
        [PMLoadingView invokeWithLoading:@selector(doProfileLoad) onTarget:self :@"Loading..." :self.view, nil];
    }
    else
    {
        [tableViewInstance reloadData];
        skipProfileLoad = NO;
    }
}

-(void) doProfileLoad
{
    //User data shoul already be available, update it
    currentSession.userData = [pmServer GetUserInfo:currentSession.userData.userId];
    
    //Start background task to get the profile pic
    [currentSession.userData performSelectorInBackground:@selector(downloadProfileImage:) withObject:profileImageButton.imageView];
    
    //Grab plate from session
    PMPlateData *plateData = [currentSession getPlate];    
    
    //Get wall data from server
    plateData.wallData = [pmServer GetWallData:plateData.plateId];
    
    PlateMeSession *mainSession = [PlateMeSession currentSession];
    
    //Determine if this profile is a favorite
    struct FavoriteStatus favStatus = {false, false};
    
    if (nil != currentSession.userData.userId && ![currentSession.userData.userId isEqualToString:mainSession.userData.userId])
    {
        favStatus = [pmServer CheckFavoriteStatus:currentSession.userData.userId];
        
        //If pending or favorite then hide the fav button
        if (favStatus.isFavorite || favStatus.isPending)
        {
            [addFavoriteButton setImage:removeFavoriteImage forState:UIControlStateNormal];
        }
        else
        {
            [addFavoriteButton setImage:addFavoriteImage forState:UIControlStateNormal];
        }
        
        if ([pmServer CheckFollowing:plateData.plateId])
        {
            [addFollowerButton setImage:removeFollowerImage forState:UIControlStateNormal];
        }
        else
        {
            [addFollowerButton setImage:addFollowerImage forState:UIControlStateNormal];
        }
    }
    
    postTableViewController.posts = [[[currentSession getPlate] wallData] posts];
    
    //Finished getting data from server, execute refresh on main thread
    [postTableViewController.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO]; 
}


- (IBAction)refreshViewData:(id)sender
{
    [super refreshViewData:sender];
    
    //invoke the profile loading in the background with a loading cicle
    [PMLoadingView invokeWithLoading:@selector(doProfileLoad) onTarget:self :@"Refreshing..." :self.view, nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Restore hidden state
    [self.navController setNavigationBarHidden:navBarPrevHidden animated:YES];
    
    if (postViewDisplayed)
    {
        postTextView.text = @"";
        [self postClicked:nil];
    }
}

-(void) clearAndResignPost
{
    postTextView.text = @"";
    postImageView.image = nil;
    [self postClicked:nil];
}

-(void) animateToolbar
{
    static BOOL atTop = false;
    
    CGFloat yMove = 0;
    CGFloat tableNegation = 1.0;
    
    // The transform matrix
    if (atTop)
    {
        yMove = 375;
        atTop = NO;
        tableNegation = -1.0f;
    }
    else
    {
        yMove = -375;
        atTop = YES;
        tableNegation = 1.0f;
        
        //Adjust the tableview size before animating the toolbar
        postTableViewController.tableView.frame = CGRectMake(postTableViewController.tableView.frame.origin.x, postTableViewController.tableView.frame.origin.y, postTableViewController.tableView.frame.size.width, postTableViewController.tableView.frame.size.height+(toolBar.frame.size.height*tableNegation));         
    }
    
    //Animation block
    [UIView animateWithDuration:0.25
                     animations:^
     {
         //Do animation part here
         //We are transforming the bar by translation
         CGAffineTransform transform = CGAffineTransformTranslate(toolBar.transform, 0, yMove);
         
         //Set the transform
         //Transform is better since we can keep track of the bar better
         toolBar.transform = transform;                         
     }
                     completion:^(BOOL finished)
     {
         //If moving to the bottom then adjust the tableview after
         //the animation has finished
         if (!atTop)
         {
             postTableViewController.tableView.frame = CGRectMake(postTableViewController.tableView.frame.origin.x, postTableViewController.tableView.frame.origin.y, postTableViewController.tableView.frame.size.width, postTableViewController.tableView.frame.size.height+(toolBar.frame.size.height*tableNegation));  
         }                         
     }];    
}

-(void) adjustForPostClick:(PostTableCell*)parentToPost
{
    if (!postViewDisplayed)
    {
        //The the post parent
        postParent = parentToPost;
        
        [self.view addSubview:postView];
        
        if (nil != postImageView.image)
        {
            postImageView.frame = imagePostSettings.imageFrame;
            postTextView.frame = imagePostSettings.textFrame;
        }
        else
        {
            postImageView.frame = textPostSettings.imageFrame;
            postTextView.frame = textPostSettings.textFrame;
        }
        
        //Put view at bottom of page so we can animae it up
        postView.transform = CGAffineTransformMakeTranslation(0, 320);
        
        //Animate the post text view coming into view
        [UITextView beginAnimations:nil context:NULL];  
        [UITextView setAnimationDuration:0.25]; 
        
        postView.transform = CGAffineTransformMakeTranslation(0, toolBar.frame.origin.y+toolBar.frame.size.height);
        
        [UIView commitAnimations];
        
        //Make keyboard appear automatically
        [postTextView becomeFirstResponder];
        
        postViewDisplayed = YES;
    }
    else
    {
        [postView removeFromSuperview];
        postViewDisplayed = NO;
    }    
}

-(IBAction)postClicked:(id)sender
{
    postImageView.image = nil;
    
    //Move the toolbar
    [self animateToolbar];
    
    [self adjustForPostClick:nil];    
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
            NSString *textToPost = [[NSString stringWithString:postTextView.text] retain];
            
            //Post the data with no parent
            NSNumber *num = [NSNumber numberWithInt:0];
            if (nil == postImageView.image)
            {
                [PMLoadingView invokeWithLoading:@selector(doPost::::::) onTarget:self :@"Posting..." :self.view, num, [currentSession getPlate].plateId, textToPost, postParent, postImageView.image, videoUrlToPost];
            }
            else
            {
                [PMLoadingView invokeWithProgress:@selector(doPost::::::) onTarget:self :@"Posting..." :self.view, [currentSession getPlate].plateId, textToPost, postParent, postImageView.image, videoUrlToPost];
            }
            
            return NO;
        }
    }
    
    return isValid;
}

-(void) doPost:(NSNumber*)reqNum :(NSString*) plateId :(NSString*)content :(PostTableCell*)parentPost :(UIImage*)imageToPost :(NSURL*)videoUrl
{
    NSString *imgUrl = nil;
    struct GalleryVideoUrls videoUrls = {nil};
    
    if (nil != videoUrl)
    {
        videoUrls = [photosViewController doUploadGalleryVideo:reqNum :videoUrl];
    }
    else if (nil != imageToPost)
        imgUrl = [photosViewController doUploadGalleryImage:reqNum :imageToPost];
    
    postImageView.image = nil;
    videoUrlToPost = nil;
    
    //Post the data
    if (nil == parentPost)
    {
        [pmServer AddPost:plateId :content :@"0": imgUrl :videoUrls.videoUrl :videoUrls.videoThumbnailUrl];
    }
    else
    {
        [pmServer AddPost:plateId :content :parentPost.postData.postId: imgUrl :videoUrls.videoUrl :videoUrls.videoThumbnailUrl];
    }
    
    //Reload the profile
    [self doProfileLoad];
    
    //Clear the post on the main thread
    [self performSelectorOnMainThread:@selector(clearAndResignPost) withObject:nil waitUntilDone:YES];
    
    if (nil != parentPost)
    {
        //Get the new post data and display it for the user
        PMPostData *postData = [[[currentSession getPlate] wallData] findPost:parentPost.postData.postId];
        
        parentPost.postData = [postData retain];
        
        [self performSelectorOnMainThread:@selector(displayCommentsAndGoToBottom:) withObject:[parentPost retain] waitUntilDone:NO];
    }
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
    
    //Reload the profile
    [self doProfileLoad];
    
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
    
        [PMLoadingView invokeWithLoading:@selector(loadSelectedProfile::) onTarget:self :@"" :self.view, ownerId, profile, nil]; 
    }
}

- (void) loadSelectedProfile:(NSString*)accountId :(ProfileViewController*)profile
{
    PlateMeSession *newSession = [[PlateMeSession alloc] init];
    
    if ((accountId != nil) && ![accountId isEqualToString:@""] )
    {
        //Get user data for the profile
        PMUserData *userData = [pmServer GetUserInfo:accountId];   
        [newSession setUserData:userData];
        
        //Assign plate data to the new session
        PMPlateData *plateData = [pmServer GetPlate:userData.primaryPlateId];
        
        if (nil != plateData)
        {
            [newSession addPlate:plateData :YES];
            
            [profile setCurrentSession:newSession];
            
            //Load the full profile
            [profile doProfileLoad];
            
            //Already loaded the profile, don;t load it again
            profile.skipProfileLoad = YES;
            
            [self.navController performSelectorOnMainThread:@selector(pushViewController:animated:) withObject:profile waitUntilDone:YES];
        }
    }
}

+ (void) loadSelectedProfile:(NSString*)accountId :(ProfileViewController*)profile :(UINavigationController*)navController :(PMServer*)pmServer
{
    PlateMeSession *newSession = [[PlateMeSession alloc] init];
    
    if ((accountId != nil) && ![accountId isEqualToString:@""] )
    {
        //Get user data for the profile
        PMUserData *userData = [pmServer GetUserInfo:accountId];   
        [newSession setUserData:userData];
        
        //Assign plate data to the new session
        PMPlateData *plateData = [pmServer GetPlate:userData.primaryPlateId];
        
        if (nil != plateData)
        {
            [newSession addPlate:plateData :YES];
            
            [profile setCurrentSession:newSession];
            
            [profile doProfileLoad];
            
            //Already loaded the profile, don;t load it again
            profile.skipProfileLoad = YES;
            
            [navController performSelectorOnMainThread:@selector(pushViewController:animated:) withObject:profile waitUntilDone:YES];
        }
    }
}

- (void) postImageClicked:(PostTableViewController *)postTableController :(PostTableCell *)cell
{
    //Photos view
    PhotosViewController *photoController = [[PhotosViewController alloc] init];
    photoController.navController = self.navController;
    [photoController viewDidLoad];
    
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

-(CommentsViewController*) displayCommentsAndGoToBottom:(PostTableCell*)cell
{
    CommentsViewController *addedController = [self displayComments:cell :YES];
    
    return addedController;
}

-(void) doRatePost:(NSString*)postId :(NSString*)rating :(PostTableViewController*)postTableController
{
    [pmServer RatePost:postId :rating];
    
    [self doProfileLoad];
    
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
-(void) newComment:(PostTableCell *)postCell
{
    //Move the toolbar
    [self animateToolbar];
    
    [self adjustForPostClick:postCell]; 
}

-(void) starRatingViewAppeared:(StarRatingView*)starRatingView
{
    disablePostEdit = YES;
}

-(void) starRatingViewDisappeared:(StarRatingView*)starRatingView
{
    disablePostEdit = NO;
}

-(void) doAddFavorite:(NSString*)accountId
{
    if (addFavoriteButton.imageView.image != removeFavoriteImage)
    {
        //Grab favorites to make sure they are up to date
        PlateMeSession *session = [PlateMeSession currentSession];
        
        session.favorites = [pmServer GetFavorites];
        session.favoriteRequests = [pmServer GetPendingFavorites];
        
        //Confirm favorite if already requested
        if ([session accountIsFavoriteRequest:currentSession.userData.userId])
        {
            if ([pmServer ConfirmFavoriteRequest:currentSession.userData.userId])
            {
                //Change to the remove button since we successfully confirmed
                [addFavoriteButton setImage:removeFavoriteImage forState:UIControlStateNormal];
            }
        }
        //Add the favorite
        else if ([pmServer AddFavorite:currentSession.userData.userId])
        {
            //Change to remove since we requested
            [addFavoriteButton setImage:removeFavoriteImage forState:UIControlStateNormal];
        }
    }
    else
    {
        //Add the favorite
        if ([pmServer RemoveFavorite:currentSession.userData.userId])
        {
            //Hide the favorite button since we successfully sent the request
            //TODO: set to pending image instead of hiding
            [addFavoriteButton setImage:addFavoriteImage forState:UIControlStateNormal];
        }        
    }
    
}

-(void) doAddFollower:(NSString*)plateId
{
    if (addFollowerButton.imageView.image == addFollowerImage)
    {
        //Grab followers to make sure they are up to date
        PlateMeSession *session = [PlateMeSession currentSession];
        
        session.followers = [pmServer GetFollowers];
        
        //Add follower
        if ([pmServer AddFollower:plateId])
        {
            //Change to remove since we requested
            [addFollowerButton setImage:removeFollowerImage forState:UIControlStateNormal];
        }
    }
    else if (addFollowerButton.imageView.image == removeFavoriteImage)
    {
        //Remove the follower
        if ([pmServer RemoveFollower:plateId])
        {
            //Hide the follower button since we successfully sent the request
            [addFollowerButton setImage:addFollowerImage forState:UIControlStateNormal];
        }        
    }
    
}

-(IBAction)addFavoriteClicked:(id)sender
{
    if (addFavoriteButton.imageView.image == favoritesImage)
    {
        //Favorites view
        //Dequeue an available favorites view
        FavoritesViewController *favController = (FavoritesViewController*)[PlateMeViewController dequeueReusableView:[FavoritesViewController class] :navController];
        
        //Set session as the logged in one
        favController.currentSession = [PlateMeSession currentSession];
        
        //Show it
        [self.navController pushViewController:favController animated:YES];
    }
    else
    {
        [PMLoadingView invokeWithLoading:@selector(doAddFavorite:) onTarget:self :@"" :self.view, [currentSession.userData.userId retain], nil];
    }
}

-(IBAction)addFollowerClicked:(id)sender
{
    if (addFollowerButton.imageView.image == followersImage)
    {
        //Dequeue an available followers view
        FollowersViewController *followController = (FollowersViewController*)[PlateMeViewController dequeueReusableView:[FollowersViewController class] :navController];
        
        //Set session as the logged in one
        followController.currentSession = [PlateMeSession currentSession];
        
        //Show it
        [self.navController pushViewController:followController animated:YES];  
    }
    else
    {
        [PMLoadingView invokeWithLoading:@selector(doAddFollower:) onTarget:self :@"" :self.view, [currentSession.userData.primaryPlateId retain], nil]; 
    }
}

-(IBAction)cameraClicked:(id)sender
{
    if (nil == photosViewController)
        photosViewController = (PhotosViewController*)[PlateMeViewController dequeueReusableView:[PhotosViewController class] :navController];
    
    //Set session as the logged in one
    photosViewController.currentSession = [PlateMeSession currentSession];
    photosViewController.delegate = self;
    
    skipProfileLoad = YES;
    
    [photosViewController selectPhoto:@"Posting..." :self];    
}

-(void) PhotoSelected:(PhotosViewController *)photosViewController :(UIImage *)image
{
    [postTextView setText:@""];
    [postImageView setImage:image];
    
    //Move the toolbar
    [self animateToolbar];
    
    [self adjustForPostClick:nil];
}

-(void) VideoSelected:(PhotosViewController *)photosViewControllerL :(NSURL *)videoUrl
{
    UIImage *thumbnail = [photosViewControllerL generateVideoTumbnail:videoUrl];
    
    [postTextView setText:@""];
    [postImageView setImage:thumbnail];
    videoUrlToPost = videoUrl;
    
    //Move the toolbar
    [self animateToolbar];
    
    [self adjustForPostClick:nil];
}

- (void) PhotoUploadFinished:(PhotosViewController *)photosViewController
{
    [self doProfileLoad];
}

-(IBAction)profileImageButtonClicked:(id)sender
{
    if ([PlateMeSession currentSession] == currentSession)
    {
        self.imagePicker.delegate = self;
        
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentModalViewController:self.imagePicker animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
    
    UIImage *imageSelected = [[info objectForKey:@"UIImagePickerControllerOriginalImage"] scaleToMax:200];
    
    //Do not load the profile when we return back
    self.skipProfileLoad = YES;
    
    [PMLoadingView invokeWithProgress:@selector(doChangeProfilePic::) onTarget:self :@"Uploading..." :self.view, imageSelected, nil];
}

-(void) doChangeProfilePic:(NSNumber*)requestId :(UIImage*)imageSelected
{
    // This creates a string with the path to the app's Documents Directory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // This is where you would select the file name for the image you want to save.
    NSString *imagePath = [NSString stringWithFormat:@"%@/MobileImage_%f.png", documentsDirectory, [[NSDate date] timeIntervalSince1970]];
    
    // This creates PNG NSData for the UIImageView imageView's image.
    NSData *imageData = UIImageJPEGRepresentation(imageSelected, 0.5);
    
    // This actually creates the image at the file path specified, with the image's NSData.
    [[NSFileManager defaultManager] createFileAtPath:imagePath contents:imageData attributes:nil];
    
    NSString *newPicUrl = [pmServer UploadImage:imagePath :[requestId intValue]];
    
    if (nil != newPicUrl)
    {
        currentSession.userData.profilePicUrl = newPicUrl;
        if ([pmServer UpdateProfile:currentSession.userData])
        {
            currentSession.userData.profilePicUrl = newPicUrl;
        }
        
        //Start background task to get the profile pic
        [currentSession.userData performSelectorInBackground:@selector(downloadProfileImage:) withObject:profileImageButton.imageView];
    }
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&error];    
}


-(void) dealloc
{
    [super dealloc];
    
    [defaultProfilePic release];
    [removeFavoriteImage release];
    [addFavoriteImage release];
    [removeFollowerImage release];
    [addFollowerImage release];
    [followersImage release];
    [favoritesImage release];
}
 
@end
