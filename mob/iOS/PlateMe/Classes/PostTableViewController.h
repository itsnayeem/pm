//
//  PostTableViewController.h
//  PlateMe
//
//  Created by Kevin Calcote on 2/21/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarRatingView.h"
#import "PostTableCell.h"
#import "PullRefreshTableViewController.h"

@class PlateMeSession;
@class PostTableViewController;
@class CommentsViewController;

@protocol PostTableViewControllerDelegate <NSObject>
@optional
-(void) deletePost:(PostTableViewController*)postTableController :(NSString*)postId;
-(void) postOwnerNameClicked:(PostTableViewController*)postTableController :(NSString*)ownerId;
-(void) StarRatingUpdated:(PostTableViewController*)postTableController :(NSString *)rating :(NSString*)postId;
-(CommentsViewController*) displayComments:(PostTableCell*)cell :(BOOL)showFromBottom;
-(BOOL) postCanBeEdited:(PMPostData*)postData;
-(void) newComment:(PostTableCell*)postCell;
-(void) starRatingViewAppeared:(StarRatingView*)starRatingView;
-(void) starRatingViewDisappeared:(StarRatingView*)starRatingView;
-(void) postImageClicked:(PostTableViewController*)postTableController :(PostTableCell*)cell;
-(void) postVideoClicked:(PostTableViewController*)postTableController :(PostTableCell*)cell;
@end

@interface PostTableViewController : UITableViewController <StarRatingViewDelegate, PostTableCellDelegate>
{
    UIImage *defaultProfilePic;
    UITableViewCell *noPostsCell;
    IBOutlet StarRatingView *starRatingView;
    BOOL clearTableIndicator;
    NSMutableArray *posts;
    IBOutlet id<PostTableViewControllerDelegate> delegate;
    BOOL commentButtonHidden;
}

@property (retain) id<PostTableViewControllerDelegate> delegate;
@property (retain) NSMutableArray *posts;
@property (assign) BOOL commentButtonHidden;
@property (retain) StarRatingView *starRatingView;

-(void)clearTable;
-(PostTableCell*) createNewPost;
- (CGSize) postTextSize:(NSString*)text;
-(void) fillCellWithPostData:(PostTableCell*)cell :(PMPostData*)postData;

-(IBAction)postImageClicked:(id)sender;
-(IBAction)postVideoClicked:(id)sender;

@end
