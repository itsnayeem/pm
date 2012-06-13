//
//  PMUtilities.m
//  PlateMe
//
//  Created by Kevin Calcote on 3/15/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PMUtilities.h"

@implementation UIImage (scale)

-(UIImage*)scaleToSize:(CGSize)size
{
    // Create a bitmap graphics context
    // This will also set it as the current context
    UIGraphicsBeginImageContext(size);
    
    // Draw the scaled image in the current context
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // Create a new image from current context
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Pop the current context from the stack
    UIGraphicsEndImageContext();
    
    // Return our new scaled image
    return scaledImage;
}

-(UIImage*)scaleToMax:(CGFloat)maxSize
{
    //Scale the image
    CGSize newSize;
    
    if (self.size.width > self.size.height)
    {
        newSize.width = maxSize;
        newSize.height =  (maxSize * (self.size.height / self.size.width));
    }
    else
    {
        newSize.height = maxSize;
        newSize.width = (maxSize * (self.size.width / self.size.height));
    }
    
    return [self scaleToSize:CGSizeMake(newSize.width, newSize.height)];    
}

@end

@implementation NSObject (perform)

-(id) performOperationWithSelector:(SEL)selector
{
    
}

@end
