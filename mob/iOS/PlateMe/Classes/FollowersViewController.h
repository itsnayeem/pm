//
//  FollowersViewController.h
//  PlateMe
//
//  Created by Kevin Calcote on 3/11/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PlateMeViewController.h"

@interface FollowersViewController : PlateMeViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tableViewInstance;
    UITableViewCell *noFollowCell;
    NSMutableArray *followersArray;
}

@property (retain) NSMutableArray *followersArray;

-(void) doLoadFollowers;

@end
