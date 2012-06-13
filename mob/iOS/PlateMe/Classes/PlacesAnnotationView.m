//
//  PlacesAnnotationView.m
//  PlateMe
//
//  Created by Kevin Calcote on 2/17/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PlacesAnnotationView.h"

@implementation PlacesAnnotationView

@synthesize imageView;

-(id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        CGRect tmpFrame = self.frame;
        
        tmpFrame.size.width = 40;
        tmpFrame.size.height = 40;
        [self setFrame:tmpFrame];        
        
        //Set the image view
        imageView = [[[UIImageView alloc] init] retain];
        imageView.image = nil;
        
        //Add the image view
        [self addSubview:imageView];
        //Take up whole view
        [imageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    
    return self;
}


@end
