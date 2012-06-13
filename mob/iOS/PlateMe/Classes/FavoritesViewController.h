//
//  FavoritesViewController.h
//  PlateMe
//
//  Created by Kevin Calcote on 2/26/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PlateMeViewController.h"

@interface FavoritesViewController : PlateMeViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tableViewInstance;
    IBOutlet UISegmentedControl *segmentControl;
    UITableViewCell *noFavoritesCell;
    UITableViewCell *noRequestsCell;
    NSMutableArray *favoritesArray;
    NSMutableArray *requestsArray;
    NSMutableArray *activeArray;
}

@property (retain) NSMutableArray *favoritesArray;
@property (retain) NSMutableArray *requestsArray;

-(IBAction)favSegmentIndexChanged:(id)sender;
-(void) loadSelectedData;
-(void) doLoadFavorites;

@end
