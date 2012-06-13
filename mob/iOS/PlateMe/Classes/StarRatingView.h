//
//  StarRatingView.h
//  PlateMe
//
//  Created by Kevin Calcote on 2/15/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StarRatingView;
@class StarRatingCell;
@class PostTableCell;

@protocol StarRatingViewDelegate <NSObject>
@optional
- (void)StarRatingUpdated:(StarRatingView*)starRatingView :(NSString*)rating :(NSString*)postId :(PostTableCell*)postCell;;
- (void)starRatingViewDisappeared:(StarRatingView*)starRatingView;
@end

@interface StarRatingView : UIView <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UISlider *starRatingSlider;
    IBOutlet UIImageView *star1View;
    IBOutlet UIImageView *star2View;
    IBOutlet UIImageView *star3View;
    IBOutlet UIImageView *star4View;
    IBOutlet UIImageView *star5View;
    UIImage *emptyStar;
    UIImage *halfStar;
    UIImage *fullStar;
    NSString *postIdForRating;
    IBOutlet id<StarRatingViewDelegate> delegate;
    IBOutlet UIButton *doneButton;
    UITableView *allStarsTable;
    IBOutlet UIButton *viewAllButton;
    CGRect backupFrame;
    NSMutableArray *fiveStarArray;
    UITableViewCell *noRatingsCell;
    UIActivityIndicatorView *activityIndicator;
    PostTableCell *postCell;
}

@property (retain) NSString* postIdForRating;
@property (retain) id<StarRatingViewDelegate> delegate;
@property (retain) NSMutableArray* fiveStarArray;
@property (retain) UIImageView *star1View;
@property (retain) UIImageView *star2View;
@property (retain) UIImageView *star3View;
@property (retain) UIImageView *star4View;
@property (retain) UIImageView *star5View;
@property (assign) PostTableCell *postCell;

-(void) setStarRating:(float)rating;
-(void) initialize;
-(IBAction)doneButtonClicked:(id)sender;
-(IBAction)cancelButtonClicked:(id)sender;
-(IBAction)viewAllClicked:(id)sender;
-(StarRatingCell*) createNewCell;
-(void) doLoadRatings:(NSString*)postId;
-(void) openTable;
-(void) closeTable;

@end
