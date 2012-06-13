//
//  StarRatingCell.h
//  PlateMe
//
//  Created by Kevin Calcote on 3/3/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarRatingCell : UITableViewCell
{
    IBOutlet UIImageView *star1View;
    IBOutlet UIImageView *star2View;
    IBOutlet UIImageView *star3View;
    IBOutlet UIImageView *star4View;
    IBOutlet UIImageView *star5View;
    UIImage *emptyStar;
    UIImage *halfStar;
    UIImage *fullStar;
    IBOutlet UILabel *nameLabel;
}

@property (retain) UILabel *nameLabel;

-(void) setStarRating:(float)rating;
-(UIImage*) fillStar:(CFMutableBitVectorRef)bv :(NSInteger)halfIndex;

@end
