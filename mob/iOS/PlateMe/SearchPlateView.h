//
//  SearchPlateView.h
//
//  Created by User on 8/11/11.
//  Copyright 2011 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SearchPlateView : UIView
{
    IBOutlet UIView *profileView;
    IBOutlet UIView *searchPlateView;
	IBOutlet UIView *platePhotoView;
	UIImage *currentStatePlate; 
	IBOutlet UIImageView *stateImage;
	IBOutlet UIImageView *stateImageMini;
	IBOutlet UILabel *plateDisplay;
	IBOutlet UILabel *plateDisplayMini;
	IBOutlet UITextField *plateNum;
	IBOutlet UIPickerView *pickerView;
	NSMutableArray *listOfStates;
	UIFont *licensePlateFont;
}

- (IBAction)showLastView:(id)sender;
- (IBAction)showProfileView:(id)sender;
- (IBAction)showPlatePhotoView:(id)sender;
- (IBAction)enteringPlateNum:(id)sender;
- (IBAction)clickPlateImage:(id)sender;


// cookies, get post requests

@end
