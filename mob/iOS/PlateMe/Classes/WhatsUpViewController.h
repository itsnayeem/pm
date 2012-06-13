//
//  WhatsUpViewController.h
//  PlateMe
//
//  Created by Kevin Calcote on 3/31/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PlateMeViewController.h"
#import "PostTableViewController.h"

@class PMWallData;


@interface WhatsUpViewController : PlateMeViewController <PostTableViewControllerDelegate, UITextViewDelegate>
{
    PMWallData *feedData;
    PostTableViewController *postTableViewController;
    IBOutlet UITableView *tableViewInstance;
    BOOL disablePostEdit;
    PostTableCell* topPost;
}

@property (retain) PMWallData *feedData;

-(void) doFeedLoad;

@end
