//
//  CommentsViewController.h
//  PlateMe
//
//  Created by Kevin Calcote on 2/21/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlateMeViewController.h"
#import "PostTableViewController.h"

@class PMPostData;

@interface CommentsViewController : PlateMeViewController  <PostTableViewControllerDelegate>
{
    PostTableViewController *postTableViewController;
    PlateMeViewController *parentProfileViewController;
    IBOutlet UITableView *tableViewInstance;
    PostTableCell *mainPost;
    IBOutlet UIView *headerView;
    BOOL displayAtBottom;
}

@property (retain) PostTableViewController *postTableViewController;
@property (retain) PostTableCell *mainPost;

-(void) initialize:(PlateMeViewController*) profileController :(PostTableCell*)parentCell :(BOOL)showFromBottom;
-(void) refreshCommentsWithWallData:(PMWallData*)wallData;

@end
