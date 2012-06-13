//
//  SearchPlateViewController.h
//  PlateMe
//
//  Created by Kevin Calcote on 1/15/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlateMeViewController.h"

@class ProfileViewController;

@interface SearchPlateViewController : PlateMeViewController <UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource,  UIAlertViewDelegate>
{
    IBOutlet UIImageView *stateImageView;
    IBOutlet UILabel *plateLabel;
    IBOutlet UISearchBar *plateSearchBar;
    IBOutlet UIPickerView *statePicker;
    NSMutableArray *listOfStates;
    NSString *validString;
    NSString *currentState;
    BOOL isDefaultedSearch;
}

- (void) doSearch:(NSString*)plate :(NSString*)state :(ProfileViewController*)profile;
- (void) initializeSearch:(NSString*)plate :(NSString*)state;

@end
