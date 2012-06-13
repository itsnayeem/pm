//
//  RegisterPg2.h
//
//  Created by User on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface RegisterPg2 : UIView
{
	IBOutlet UIView *platePhotoView;
	IBOutlet UIView *searchPlateView;
	IBOutlet UIView *registerPg2View;
	IBOutlet UIView *homeScreenView;
	IBOutlet UIView *cameraEnableView;	
}

- (IBAction)showPlatePhotoView:(id)sender;
- (IBAction)showSearchPlateView:(id)sender;
- (IBAction)showLastView:(id)sender;
- (IBAction)showHomeScreenView:(id)sender;
- (IBAction)showCameraEnableView:(id)sender;

@end
