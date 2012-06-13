//
//  StarRatingView.m
//  PlateMe
//
//  Created by Kevin Calcote on 2/15/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "StarRatingView.h"
#import <QuartzCore/QuartzCore.h>
#import "StarRatingCell.h"
#import "PMServer.h"

@interface StarRatingView()

-(UIImage*) fillStar:(CFMutableBitVectorRef)bv :(NSInteger)halfIndex;
-(void) sliderChanged:(UISlider*)sliderItem;

@end

@implementation StarRatingView

@synthesize postIdForRating;
@synthesize delegate;
@synthesize fiveStarArray;
@synthesize star1View;
@synthesize star2View;
@synthesize star3View;
@synthesize star4View;
@synthesize star5View;
@synthesize postCell;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {

    }
    
    return self;
}

-(void) initialize
{
    [starRatingSlider setMaximumValue:5.0f];
    [starRatingSlider setMinimumValue:0.0f];
    [starRatingSlider setContinuous:YES];
    [starRatingSlider setValue:0.0];
    
    [starRatingSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    
    allStarsTable = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain] retain];
    allStarsTable.delegate = self;
    allStarsTable.dataSource = self;
    [allStarsTable setAlpha:self.alpha];
    [allStarsTable setBackgroundColor:[UIColor grayColor]];
    [allStarsTable setSeparatorColor:[UIColor whiteColor]];
    [allStarsTable setClipsToBounds:YES];
    [allStarsTable.layer setCornerRadius:10.0f];
    [allStarsTable.layer setBorderWidth:1.5];
    [allStarsTable.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    noRatingsCell = [[[UITableViewCell alloc] init] retain];
    noRatingsCell.textLabel.textColor = [UIColor whiteColor];
    noRatingsCell.textLabel.textAlignment = UITextAlignmentCenter;
    noRatingsCell.textLabel.text = @"No Ratings";
    noRatingsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] retain];
}

-(void) sliderChanged:(UISlider*)sliderItem
{
    [self setStarRating:floorf(((float)sliderItem.value)*2)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

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

-(IBAction)doneButtonClicked:(id)sender
{
    //Remove star rating
    [self removeFromSuperview];
    
    int iRating = (int)((float)starRatingSlider.value*10);
    iRating -= (iRating % 5);
    
    //Create rating string
    NSString *rating = [NSString stringWithFormat:@"%.1f", ((float)iRating)/10];
    
    //Tell delegate
    [delegate StarRatingUpdated:self :rating :postIdForRating :postCell];
    
    [delegate starRatingViewDisappeared:self];
    
    //Hide table if it is visible
    if (allStarsTable.superview == self)
    {
        [self viewAllClicked:nil];
    }
    
    //Reset values
    [starRatingSlider setValue:0.0f];
    [self setStarRating:0.0f];
    postIdForRating = @"0";
}

-(IBAction)cancelButtonClicked:(id)sender
{
    //Remove star rating
    [self removeFromSuperview];
    
    //Hide table if it is visible
    if (allStarsTable.superview == self)
    {
        [self viewAllClicked:nil];
    }
    
    [delegate starRatingViewDisappeared:self];
    
    //Reset values
    [starRatingSlider setValue:0.0f];
    [self setStarRating:0.0f];
    postIdForRating = @"0";  
}

-(void) willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [doneButton setHighlighted:YES];
}

-(void) doLoadRatings:(NSString*)postId
{
    [allStarsTable performSelectorOnMainThread:@selector(addSubview:) withObject:activityIndicator waitUntilDone:YES];
    
    [activityIndicator setCenter:CGPointMake(110, 20)];
    
    [activityIndicator performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:YES];
    
    //Grab ratings from the server
    NSMutableArray *ratings = [[[PMServer sharedInstance] GetFiveStarRatings:postId] retain];
    
    //set the five star array
    [self performSelectorOnMainThread:@selector(setFiveStarArray:) withObject:ratings waitUntilDone:YES];
    
    [ratings release];
    
    if(allStarsTable.superview == self)
    {
        //Adjust table since we have the data
        [self performSelectorOnMainThread:@selector(openTable) withObject:nil waitUntilDone:YES];
    }
    
    [activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:YES];
    
    [activityIndicator performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
}

-(void) openTable
{
    if (allStarsTable.superview != self)
        [self addSubview:allStarsTable];
    
    //Reload the table data
    [allStarsTable reloadData];
    
    //Set location prior to animation
    [allStarsTable setFrame:CGRectMake(starRatingSlider.frame.origin.x, starRatingSlider.frame.origin.y+starRatingSlider.frame.size.height+5, starRatingSlider.frame.size.width, allStarsTable.frame.size.height)];
    
    //Animate showing the table
    [UIView animateWithDuration:0.25 animations:^
     {
         GLuint tableHeight = (allStarsTable.contentSize.height > 150) ? 150 : allStarsTable.contentSize.height;
         
         //Set star frame before the stable frame
         CGRect currentFrame = self.frame;
         currentFrame.origin.y -= ((tableHeight - allStarsTable.frame.size.height)/2);
         currentFrame.size.height += (tableHeight - allStarsTable.frame.size.height);
         self.frame = currentFrame;
         
         CGRect tableFrame = allStarsTable.frame;
         tableFrame.size.height = tableHeight;
         allStarsTable.frame = tableFrame;
     }
     completion:^(BOOL finished)
     {
         [allStarsTable reloadData];
     }];
    
    [viewAllButton setTitle:@"Hide All" forState:UIControlStateNormal];
}

-(void) closeTable
{
    //Animate showing the table
    [UIView animateWithDuration:0.25 animations:^
     {
         self.frame = backupFrame;
         
         CGRect tableFrame = allStarsTable.frame;
         tableFrame.size.height = 0;
         allStarsTable.frame = tableFrame;
     }
     completion:^(BOOL finished)
     {
         [allStarsTable removeFromSuperview];
         [viewAllButton setTitle:@"View All" forState:UIControlStateNormal];             
     }];    
}

-(IBAction)viewAllClicked:(id)sender
{
    //If the table is not visible then show it
    if (allStarsTable.superview != self)
    {
        backupFrame = self.frame;
        [self openTable];
    }
    else
    {
        [self closeTable];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ((nil == fiveStarArray) || (fiveStarArray.count == 0))
    {
        return 1;
    }
    
    return fiveStarArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StarRatingCell *cell = nil;
    
    if ((nil != fiveStarArray) && (fiveStarArray.count > 0))
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"RatingCell"];
        
        if (nil == cell)
        {
            cell = [self createNewCell];
            
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else
        {
            PMFiveStarData *fiveStarData = [fiveStarArray objectAtIndex:indexPath.row];
            
            //Set rating and name
            [cell setStarRating:floorf(([fiveStarData.rating floatValue])*2)];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",fiveStarData.firstName, fiveStarData.lastName];
        }
    }
    else if (nil != fiveStarArray)
    {
        noRatingsCell.textLabel.text = @"No Ratings";
        cell = (StarRatingCell*)noRatingsCell;
    }
    else
    {
        noRatingsCell.textLabel.text = @"";
        cell = (StarRatingCell*)noRatingsCell;
    }
    
    return cell;
}

- (StarRatingCell*) createNewCell
{
    StarRatingCell *cell = nil;
    
    //Loop through nib looking for the proper view
    for (id loadedObject in [[NSBundle mainBundle] loadNibNamed:@"Dynamic" owner:nil options:nil]) 
    {
        //Check for the postcell
        if ([loadedObject isKindOfClass:[StarRatingCell class]]) 
        {
            cell = (StarRatingCell*)loadedObject;
            [cell retain];
            break;
        }
    }
    
    return cell;
}

-(void) dealloc
{
    [fullStar release];
    [halfStar release];
    [emptyStar release];
}

@end
