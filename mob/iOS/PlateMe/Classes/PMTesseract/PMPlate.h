//
//  PMTesseract.h
//  PlateMe
//
//  Created by Kevin Calcote on 1/17/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#include <PMLib/PMLib.h>
#import <Foundation/Foundation.h>

@interface PMPlate : NSObject
{
    uint32_t *pixels;
    PMLibCpp::PMPlate* pmPlate;
}

- (void)initTesseract;
- (void)SetPlateImage:(UIImage *)image;
- (NSString*)GetPlateText:(UIImage *)image;

@end
