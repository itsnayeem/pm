//
//  PostTableCell.m
//  PlateMe
//
//  Created by Kevin Calcote on 2/5/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#define POST_HEADER_HEIGHT 25
#define COMMENT_FOOTHER_HEIGHT 20

#import "PostTableCell.h"
#import "PlateMeSession.h"

@interface PostTableCell()

-(UIImage*) fillStar:(CFMutableBitVectorRef)bv :(NSInteger)halfIndex;

@end

@implementation PostTableCell

//@synthesize profilePic;
@synthesize postData;
@synthesize textView;
@synthesize postImageButton;
@synthesize postView;
@synthesize posterName;
@synthesize delegate;
@synthesize profilePicButton;
@synthesize turnButton;
@synthesize commentButton;
@synthesize timestamp;
@synthesize numRatings;
@synthesize star1;
@synthesize star2;
@synthesize star3;
@synthesize star4;
@synthesize star5;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+(NSString *)SeperatorIdentifier
{
    return @"CellSeperator";
}

+(NSString *)CellIdentifier
{
    return @"BasePostCell";
}

- (void)setFrame:(CGRect)frame 
{
    //Set margins around the cell
    frame.origin.x += 12;
    frame.size.width -= 2 * 12;
    
    //Update via super
    [super setFrame:frame];
    
    //Adjust post view size with cell and account for header/footer
    CGFloat postHeight = (frame.size.height - POST_HEADER_HEIGHT) - COMMENT_FOOTHER_HEIGHT;
    
    [postView setFrame:CGRectMake(0, POST_HEADER_HEIGHT, frame.size.width, postHeight)];
}

-(void) setStarRating:(NSString*)rating
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
    NSInteger starRating = (NSInteger)(2 * [rating doubleValue]);
    
    //Create bitvector
    CFRange range;
    range.length = starRating;
    range.location = 0;
    
    CFMutableBitVectorRef bv = CFBitVectorCreateMutable( 0, 10 );
    
    CFBitVectorSetBits(bv, range, 1);
    
    star5.image = [self fillStar:bv :8];
    star4.image = [self fillStar:bv :6];
    star3.image = [self fillStar:bv :4];
    star2.image = [self fillStar:bv :2];
    star1.image = [self fillStar:bv :0];

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

-(IBAction)postNameClicked:(id)sender
{
    [delegate postOwnerNameClicked:self];
}

-(void) setPostOwnerNameText:(NSString *)text
{
    [posterName setTitle:text forState:UIControlStateNormal];
}

-(IBAction)internalStarsClicked:(id)sender
{
    if ( ([[[PlateMeSession currentSession] userData] userId] != nil) &&
         (![[[[PlateMeSession currentSession] userData] userId] isEqualToString:@""]) && 
         (![[[[PlateMeSession currentSession] userData] userId] isEqualToString:@"0"]) )
    {
        [delegate starsClicked:self];
    }
}

-(IBAction)showComments:(id)sender
{
    [delegate displayComments:self];
}

-(IBAction)postComment:(id)sender
{
    [delegate newComment:self];
}

-(void) dealloc
{
    [fullStar release];
    [halfStar release];
    [emptyStar release];
}

@end
