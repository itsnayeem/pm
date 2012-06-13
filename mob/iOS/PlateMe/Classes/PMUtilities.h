//
//  PMUtilities.h
//  PlateMe
//
//  Created by Kevin Calcote on 3/15/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (scale)

-(UIImage*)scaleToSize:(CGSize)size;
-(UIImage*)scaleToMax:(CGFloat)maxSize;

@end

@interface NSObject (perform)

-(id) performOperationWithSelector:(SEL)selector;

@end
