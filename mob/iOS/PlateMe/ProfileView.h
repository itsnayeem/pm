//
//  ProfileView.h
//
//  Created by User on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ProfileView : UIView
{
	IBOutlet UIView *profileView;
	IBOutlet UILabel *profileNameLabel;
	IBOutlet UITableView *blogView;
	NSMutableArray *blogContentArray;
}

- (IBAction)showLastView:(id)sender;

@end
