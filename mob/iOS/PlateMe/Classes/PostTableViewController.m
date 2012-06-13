//
//  PostTableViewController.m
//  PlateMe
//
//  Created by Kevin Calcote on 2/21/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PostTableViewController.h"
#import "PMPlateData.h"
#import "PMWallData.h"
#import "PlateMeSession.h"
#import "PMLoadingView.h"
#import "PlateMeViewController.h"
#import "PhotosViewController.h"
#import "PMOperationQueue.h"
#import <QuartzCore/QuartzCore.h>

@implementation PostTableViewController

@synthesize delegate;
@synthesize commentButtonHidden;
@synthesize starRatingView;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self.tableView setSeparatorColor:[UIColor clearColor]];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        noPostsCell = [[[UITableViewCell alloc] init] retain];
        noPostsCell.textLabel.text = @"No Recent Posts";
        [noPostsCell.textLabel setTextAlignment:UITextAlignmentCenter];
    }
    
    return self;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewDidUnload
{
    [noPostsCell release];
}

-(void) clearTable
{
    clearTableIndicator = YES;
    [self.tableView reloadData];
    clearTableIndicator = NO;
}

-(NSMutableArray*) posts
{
    return posts;
}

-(void) setPosts:(NSMutableArray *)postsL
{
    posts = postsL;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (clearTableIndicator)
        return 0;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    NSInteger numPosts = 1;
    
    if (posts.count > 0)
        numPosts = posts.count*2;
    
    return numPosts;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{    
    return @"";
}

- (PostTableCell*) createNewPost
{
    PostTableCell *cell = nil;
    
    //Loop through nib looking for the proper view
    for (id loadedObject in [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:nil options:nil]) 
    {
        //Check for the postcell
        if ([loadedObject isKindOfClass:[PostTableCell class]]) 
        {
            cell = (PostTableCell*)loadedObject;
            [cell retain];
            break;
        }
    }

    //Set the delegate
    cell.delegate = self;
    
    //Set some basic properties that should not change
    cell.clipsToBounds = YES;
    cell.userInteractionEnabled = YES;
    cell.profilePicButton.clipsToBounds = YES;
    
    //Make sure he cell background is white
    UIView *cellBackground = [[UIView alloc] initWithFrame:CGRectZero];
    cellBackground.backgroundColor =[UIColor whiteColor];
    cell.backgroundView = cellBackground;
    
    //Set the border around the cell
    [cell.layer setCornerRadius:17.0f];
    [cell.layer setBorderWidth:1.0];
    [cell.layer setBorderColor:[[UIColor blackColor] CGColor]];
    
    //Set the post view border
    [cell.postView.layer setBorderWidth:1.0];
    [cell.postView.layer setBorderColor:[[UIColor blackColor] CGColor]];
    
    //Set Profile pic border
    [cell.profilePicButton.layer setCornerRadius:13.0f];
    [cell.profilePicButton.layer setBorderWidth:2.5];
    [cell.profilePicButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    
    //Set text autoresize for the poster name button
    [cell.posterName.titleLabel setAdjustsFontSizeToFitWidth:YES];
    
    //TODO: Add shine to pic border
    
    return cell;    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Default size to seperator size
    CGFloat cellHeight = 15.0f;
    
    //If this is an actual post then set the proper size
    if (indexPath.row % 2 == 0)
    {
        //Default the post cell height
        cellHeight = 65;
        
        //Determine post size
        if (posts.count > (indexPath.row/2))
        {
            PMPostData *postData = (PMPostData*)[posts objectAtIndex:indexPath.row/2];
            
            CGSize textSize = [postData.text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(tableView.frame.size.width-115, 2000.0f)];
            postData.textSize = textSize;
            
            NSInteger minContentHeight = 45;
            NSInteger contentHeight = 0;
            
            contentHeight += textSize.height;
            
            if (![postData.postImageUrl isEqualToString:@""] || ![postData.postVideoUrl isEqualToString:@""])
                contentHeight += 100;
            
            if (contentHeight < minContentHeight)
                cellHeight += minContentHeight;
            else
                cellHeight += contentHeight;
        }
    }
    
    return cellHeight;
}

- (CGSize) postTextSize:(NSString*)text
{
   return [text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(self.tableView.frame.size.width-115, 2000.0f)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Declare cell var
    PostTableCell *cell = nil;
    
    //Determine if this row should be a post or seperator
    if (indexPath.row % 2 == 0)
    {
        //Get an available cell
        cell = [tableView dequeueReusableCellWithIdentifier:[PostTableCell CellIdentifier]];
        
        //If no base posts available then create a new one
        if (cell == nil)
        {
            //Creates a cell based on the xib
            cell = [self createNewPost];
        }
        
        //Fill the cell with post data
        if (posts.count > (indexPath.row/2))
        {
            //Get post data from the session
            PMPostData *postData = [posts objectAtIndex:indexPath.row/2];
            
            [self fillCellWithPostData:cell :postData];
            
            //Set comment button hidden property
            [cell.commentButton setHidden:commentButtonHidden]; 
        }
        else
        {
            cell = noPostsCell;
        }
        
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[PostTableCell SeperatorIdentifier]];
        
        //If no base posts available then create a new one
        if (cell == nil)
        {
            cell = (PostTableCell*)[[UITableViewCell alloc] initWithFrame:CGRectZero];
            
            //Set seperator properties
            cell.backgroundColor = [UIColor clearColor];
            cell.userInteractionEnabled = NO;
        }
    }
    
    //Return the cell to be viewed
    return cell;
}

- (void) fillCellWithPostData:(PostTableCell*)cell :(PMPostData*)postData
{
    static UIImage *defaultPostPic = nil;
    
    if (nil == defaultPostPic)
        defaultPostPic = [[UIImage imageNamed:@"background.png"] retain];
    
    
    //Assign post data so this cell can be referenced
    cell.postData = postData;
    postData.assignedCell = cell;
    
    //Set the post text
    CGRect textFrame = cell.textView.frame;
    textFrame.size.height = postData.textSize.height;
    [cell.textView setFrame:textFrame];
    [cell.textView setText:postData.text];
    
    //If image hasn't been grabbed then grab it
    if (nil == postData.profileImage)
    {
        //Download the image for the cell in the background
        //If cell is still in view once the image finishes downloading
        //then the downloadProfileImage will assign the image to it
        [cell.profilePicButton setBackgroundImage:defaultPostPic forState:UIControlStateNormal];
        [PMOperationQueue performLowPrioritySelector:postData :@selector(downloadProfileImage:), cell];
    }
    else
    {
        //Assign the image since it already has been downloaded
        [cell.profilePicButton setBackgroundImage:postData.profileImage forState:UIControlStateNormal];
    }
    
    //Dpwnload any images
    if (![postData.postImageUrl isEqualToString:@""] || ![postData.postVideoUrl isEqualToString:@""])
    {
        SEL callback = @selector(postImageClicked:) ;
        SEL downloadCallback = @selector(downloadPostImage:);
        
        if ([postData.postImageUrl isEqualToString:@""] && ![postData.postVideoUrl isEqualToString:@""])
        {
            callback = @selector(postVideoClicked:);
            downloadCallback = @selector(downloadPostThumbnailImage:);
        }
        
        if (cell.postImageButton == nil)
        {
            cell.postImageButton = [[UIButton alloc] init];
            cell.postImageButton.contentMode = UIViewContentModeScaleAspectFit;
            
            cell.postImageButton.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
            cell.postImageButton.imageView.layer.shadowOffset = CGSizeMake(0, 1.5);
            cell.postImageButton.imageView.layer.shadowOpacity = 1;
            cell.postImageButton.imageView.layer.shadowRadius = 1.5;
            cell.postImageButton.imageView.clipsToBounds = NO;
            
            [cell.postView addSubview:cell.postImageButton];
        }
        
        [cell.postImageButton removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
        [cell.postImageButton addTarget:self action:callback forControlEvents:UIControlEventTouchUpInside];
        
        [cell.postImageButton setFrame:CGRectMake(cell.textView.frame.origin.x+5, cell.textView.frame.origin.y + cell.textView.frame.size.height + 10, 100, 100)];
        
        if (nil == postData.postImage)
        {
            [cell.postImageButton setImage:defaultPostPic forState:UIControlStateNormal];
            [cell.postImageButton setImage:defaultPostPic forState:UIControlStateSelected];
            [cell.postImageButton setImage:defaultPostPic forState:UIControlStateHighlighted];
            [PMOperationQueue performLowPrioritySelector:postData :downloadCallback, cell];
        }
        else
        {
            [postData showDownloadedPostImage:cell.postImageButton.imageView];
        }
    }
    else
    {
        [cell.postImageButton setFrame:CGRectMake(0, 0, 0, 0)];
    }
    
    //Set the post name
    [cell setPostOwnerNameText:postData.posterName];
    
    //Set the star rating
    [cell setStarRating:postData.averageRating];
    
    //Set the timestamp
    [cell.timestamp setText:postData.timestamp];
    
    //Set the number of ratings
    cell.numRatings.text = [NSString stringWithFormat:@"%@ Ratings", postData.numRatings];
    
    //Add comments button
    if (postData.comments.count > 0)
    {
        //Set button number count
        [cell.turnButton setTitle:[NSString stringWithFormat:@"%d", postData.comments.count] forState:UIControlStateNormal];
        [cell.turnButton setHidden:NO];
    }
    else
    {
        [cell.turnButton setHidden:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (posts.count > indexPath.row/2)
    {
        //Get post data based on the row
        PMPostData *postData = (PMPostData *)[posts objectAtIndex:indexPath.row/2];
        
        //Check if the post Id is owned by the current person logged in
        //HACK: Check if the current session equals the login session
        //this should not be the usual way to check if the post can be edited
        //due to the post being on the owners wall
        return [delegate postCanBeEdited:postData];
    }
    
    return NO;
}

- (IBAction) postImageClicked:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    PostTableCell *cell = (PostTableCell*)button.superview;
    while(![cell isKindOfClass:[PostTableCell class]])
    {
        cell = (PostTableCell*)cell.superview;
    }
    
    [delegate postImageClicked:self :cell];
}

-(IBAction)postVideoClicked:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    PostTableCell *cell = (PostTableCell*)button.superview;
    while(![cell isKindOfClass:[PostTableCell class]])
    {
        cell = (PostTableCell*)cell.superview;
    }
    
    [delegate postVideoClicked:self :cell];    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        //If plate data is valid then attempt to get post data
        if (posts.count > indexPath.row/2)
        {
            //Get the post data based on the row
            PMPostData *postData = (PMPostData *)[posts objectAtIndex:indexPath.row/2];
            
            if (nil != postData)
            {
                [delegate deletePost:self :postData.postId];
            }
        }
    }    
}

- (void) postOwnerNameClicked:(PostTableCell *)postCell
{
    [delegate postOwnerNameClicked:self :postCell.postData.ownerId];
}

-(void) displayComments:(PostTableCell*)postCell
{
    [delegate displayComments:[postCell retain] :NO];
}

- (void) starsClicked:(PostTableCell *)postCell
{
    //Allocate the star rating view if it hasn't been allocated
    if (nil == starRatingView)
    {
        starRatingView = (StarRatingView*)[PlateMeViewController dequeueReusableView:[StarRatingView class] :nil];

        starRatingView.delegate = self;
        [starRatingView.layer setCornerRadius:10.0f];
        [starRatingView initialize];
    }
    
    //Start getting star ratings in background
    [starRatingView performSelectorInBackground:@selector(doLoadRatings:) withObject:postCell.postData.postId];
    
    //Initialize and show the star rating.
    [starRatingView setPostIdForRating:postCell.postData.postId];
    
    [starRatingView setPostCell:postCell];
    
    [postCell.superview.superview addSubview:starRatingView];
    
    [starRatingView setCenter:[[starRatingView superview] center]];
    
    [delegate starRatingViewAppeared:starRatingView];
}

- (void) StarRatingUpdated:(StarRatingView *)starRatingViewL :(NSString *)rating :(NSString*)postId :(PostTableCell*)postCell;
{
    [delegate StarRatingUpdated:self :rating :postId];
    
    /*
    //While the server is being updated, animate the stars
    UIImageView *star1 = [[UIImageView alloc] initWithImage:starRatingViewL.star1View.image];
    UIImageView *star2 = [[UIImageView alloc] initWithImage:starRatingViewL.star2View.image];
    UIImageView *star3 = [[UIImageView alloc] initWithImage:starRatingViewL.star3View.image];
    UIImageView *star4 = [[UIImageView alloc] initWithImage:starRatingViewL.star4View.image];
    UIImageView *star5 = [[UIImageView alloc] initWithImage:starRatingViewL.star5View.image];
    
    [self.view.window addSubview:star1];
    star1.frame = starRatingViewL.star1View.frame;
    star1.center = [starRatingViewL convertPoint:starRatingViewL.star1View.center toView:nil];
    
    [self.tableView addSubview:star2];
    star2.frame = starRatingViewL.star2View.frame;
    star2.center = [star2 convertPoint:starRatingViewL.star2View.center fromView:self.view];
    
    [self.tableView addSubview:star3];
    star3.frame = starRatingViewL.star3View.frame;
    star3.center = [star3 convertPoint:starRatingViewL.star3View.center fromView:self.view];
    
    [self.tableView addSubview:star4];
    star4.frame = starRatingViewL.star4View.frame;
    star4.center = [star4 convertPoint:starRatingViewL.star4View.center fromView:self.view];
    
    [self.tableView addSubview:star5];
    star5.frame = starRatingViewL.star5View.frame;
    star5.center = [star5 convertPoint:starRatingViewL.star5View.center fromView:self.view];
    
    //Animate showing the table
    [UIView animateWithDuration:0.50 animations:^
     {
         star1.frame = [postCell.star1 convertRect:postCell.star1.frame toView:self.tableView];
         star2.frame = [postCell.star2 convertRect:postCell.star2.frame toView:self.tableView];
         star3.frame = [postCell.star3 convertRect:postCell.star3.frame toView:self.tableView];
         star4.frame = [postCell.star4 convertRect:postCell.star4.frame toView:self.tableView];
         star5.frame = [postCell.star5 convertRect:postCell.star5.frame toView:self.tableView];
     }
     completion:^(BOOL finished)
     {
         [star1 removeFromSuperview];
         [star2 removeFromSuperview];
         [star3 removeFromSuperview];
         [star4 removeFromSuperview];
         [star5 removeFromSuperview];
         
         [star1 release];
         [star2 release];
         [star3 release];
         [star4 release];
         [star5 release];
         
     }];
     */
}

-(void) newComment:(PostTableCell *)postCell
{
    [delegate newComment:[postCell retain]];
}

- (void)starRatingViewDisappeared:(StarRatingView*)starRatingViewL
{
    [delegate starRatingViewDisappeared:starRatingViewL];
    [starRatingViewL setFiveStarArray:nil];
}

@end
