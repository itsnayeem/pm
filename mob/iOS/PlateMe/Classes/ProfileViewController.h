//
//  ProfileViewController.h
//  PlateMe
//
//  Created by Kevin Calcote on 1/14/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PlateMeViewController.h"
#import "PostTableCell.h"
#import "StarRatingView.h"
#import "PostTableViewController.h"
#import "PhotosViewController.h"

@class CommentsViewController;

@interface ProfileViewController : PlateMeViewController <PostTableViewControllerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotosViewControllerDelegate>
{
    struct PostViewSettings
    {
        CGRect textFrame;
        CGRect imageFrame;
    };
    
    struct PostViewSettings imagePostSettings;
    struct PostViewSettings textPostSettings;
    IBOutlet UIImageView *postImageView;
    IBOutlet UIToolbar *toolBar;
    IBOutlet UITableView *tableViewInstance;
    UIImage *defaultProfilePic;
    IBOutlet UILabel *name;
    IBOutlet UILabel *vehicle;
    IBOutlet UILabel *color;
    IBOutlet UILabel * plate;
    IBOutlet UIButton *profileImageButton;
    IBOutlet UIView *postView;
    IBOutlet UITextView *postTextView;
    BOOL postViewDisplayed;
    PostTableViewController *postTableViewController;
    PostTableCell *postParent;
    BOOL disablePostEdit;
    IBOutlet UIButton *addFavoriteButton;
    UIImage *removeFavoriteImage;
    UIImage *addFavoriteImage;
    UIImage *addFollowerImage;
    UIImage *removeFollowerImage;
    UIImage *followersImage;
    UIImage *favoritesImage;
    IBOutlet UIButton *addFollowerButton;
    BOOL skipProfileLoad;
    UIImage *preliminaryPostImage;
    PhotosViewController *photosViewController;
    NSURL *videoUrlToPost;
}

@property (assign) BOOL skipProfileLoad;

-(IBAction)postClicked:(id)sender;
-(void) adjustForPostClick:(PostTableCell*)parentToPost;
-(CommentsViewController*) displayComments:(PostTableCell*)cell :(BOOL)showComments;
-(CommentsViewController*) displayCommentsAndGoToBottom:(PostTableCell*)cell;
-(IBAction)addFavoriteClicked:(id)sender;
-(IBAction)addFollowerClicked:(id)sender;
-(IBAction)cameraClicked:(id)sender;
-(IBAction)profileImageButtonClicked:(id)sender;

+ (void) loadSelectedProfile:(NSString*)accountId :(ProfileViewController*)profile :(UINavigationController*)navController :(PMServer*)pmServer;

@end
