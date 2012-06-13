//
//  StarRatingCell.m
//  PlateMe
//
//  Created by Kevin Calcote on 3/3/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "StarRatingCell.h"

@implementation StarRatingCell

@synthesize nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setStarRating:(float)rating
{
    //Make sure the stars are created
    if (nil == emptyStar)
    {
        emptyStar = [[UIImage imageNamed:@"star_empty.png"] retain];
    }
    
    if (nil == halfStar)
    {
        halfStar = [[UIImage imageNamed:@"star_half.png"] retain];
    }
    
    if (nil == fullStar)
    {
        fullStar = [[UIImage imageNamed:@"star_full.png"] retain];
    }
    
    //Convert string to useable value
    NSInteger starRating = (NSInteger)rating;
    
    //Create bitvector
    CFRange range;
    range.length = starRating;
    range.location = 0;
    
    CFMutableBitVectorRef bv = CFBitVectorCreateMutable( 0, 10 );
    
    CFBitVectorSetBits(bv, range, 1);
    
    star5View.image = [self fillStar:bv :8];
    star4View.image = [self fillStar:bv :6];
    star3View.image = [self fillStar:bv :4];
    star2View.image = [self fillStar:bv :2];
    star1View.image = [self fillStar:bv :0];
}

-(UIImage*) fillStar:(CFMutableBitVectorRef)bv :(NSInteger)halfIndex
{
    UIImage *starImage = nil;
    
    //Use bitvector to determine the stars
    if (CFBitVectorGetBitAtIndex(bv, halfIndex))
    {
        if (CFBitVectorGetBitAtIndex(bv, halfIndex+1))
        {
            starImage = fullStar;
        }
        else
        {
            starImage = halfStar;
        }
    }
    else
    {
        starImage = emptyStar;
    }
    
    return starImage;
}

-(void) dealloc
{
    [super dealloc];
    
    [fullStar release];
    [halfStar release];
    [emptyStar release];
}

@end
