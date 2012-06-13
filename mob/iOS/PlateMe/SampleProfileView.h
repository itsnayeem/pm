//
//  SampleProfileView.h
//
//  Created by User on 8/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SampleProfileView : UIView
{
	IBOutlet UIView *sampleProfileView;
	IBOutlet UIButton *following;
	IBOutlet UIButton *addedToFavs;
}

- (IBAction)showLastView:(id)sender;
- (IBAction)pressedFollow:(id)sender;
- (IBAction)pressedFavorites:(id)sender;

@end
