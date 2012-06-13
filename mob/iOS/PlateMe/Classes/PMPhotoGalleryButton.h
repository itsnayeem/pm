//
//  PMPhotoGalleryButton.h
//  PlateMe
//
//  Created by Kevin Calcote on 3/19/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMPhotoGalleryButton : UIButton
{
    PMPhotoGalleryButton *nextButton;
    PMPhotoGalleryButton *prevButton;
    NSInteger index;
}

@property (retain) PMPhotoGalleryButton *nextButton;
@property (retain) PMPhotoGalleryButton *prevButton;
@property (assign) NSInteger index;

@end
