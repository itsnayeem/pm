//
//  PostTableCell.h
//  PlateMe
//
//  Created by Kevin Calcote on 2/5/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMPostData;
@class PostTableCell;

@protocol PostTableCellDelegate <NSObject>
@optional
- (void)postOwnerNameClicked:(PostTableCell *)postCell;
- (void)starsClicked:(PostTableCell *)postCell;
- (void)displayComments:(PostTableCell*)postCell;
- (void)newComment:(PostTableCell*)postCell;
@end

@interface PostTableCell : UITableViewCell
{
    PMPostData *postData;
    IBOutlet UIView *postView;
    //IBOutlet UIImageView *profilePic;
    IBOutlet UIButton *profilePicButton;
    IBOutlet UITextView *textView;
    IBOutlet UIButton *postImageButton;
    IBOutlet UIButton *posterName;
    IBOutlet UIImageView *star1;
    IBOutlet UIImageView *star2;
    IBOutlet UIImageView *star3;
    IBOutlet UIImageView *star4;
    IBOutlet UIImageView *star5;
    UIImage *emptyStar;
    UIImage *halfStar;
    UIImage *fullStar;
    IBOutlet id <PostTableCellDelegate> delegate;
    IBOutlet UIButton *turnButton;
    IBOutlet UIButton *commentButton;
    IBOutlet UILabel *timestamp;
    IBOutlet UILabel *numRatings;
}

//@property (assign) UIImageView *profilePic;
@property (assign) PMPostData *postData;
@property (assign) UITextView *textView;
@property (retain) UIButton *postImageButton;
@property (readonly) UIView *postView;
@property (assign) UIButton *posterName;
@property (retain) UIButton *profilePicButton;
@property (retain) id <PostTableCellDelegate> delegate;
@property (retain) UIButton *turnButton;
@property (retain) UIButton *commentButton;
@property (retain) UILabel *timestamp;
@property (retain) UILabel *numRatings;
@property (retain) UIImageView *star1;
@property (retain) UIImageView *star2;
@property (retain) UIImageView *star3;
@property (retain) UIImageView *star4;
@property (retain) UIImageView *star5;

-(void) setStarRating:(NSString*)rating;
-(void) setPostOwnerNameText:(NSString *)text;

+(NSString *)SeperatorIdentifier;
+(NSString *)CellIdentifier;

-(IBAction)postNameClicked:(id)sender;
-(IBAction)internalStarsClicked:(id)sender;
-(IBAction)postComment:(id)sender;
-(IBAction)showComments:(id)sender;

@end
