//
//  PMUserData.m
//  PlateMe
//
//  Created by Kevin Calcote on 2/4/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PMUserData.h"
#import "PMServer.h"

@implementation PMUserData

@synthesize userId;
@synthesize email;
@synthesize firstName;
@synthesize lastName;
@synthesize primaryPlateId;
@synthesize profilePicUrl;
@synthesize profileImage;

-(void) downloadProfileImage:(UIImageView*)imageView
{
    @autoreleasepool 
    {
        if (profilePicUrl != nil && profilePicUrl != @"")
        {
            self.profileImage = [[PMServer sharedInstance] DownloadImage:profilePicUrl :0];
            
            [self performSelectorOnMainThread:@selector(showDownloadedImage:) withObject:imageView waitUntilDone:NO];
        }
    }
}

-(void) showDownloadedImage:(UIImageView*)imageView
{
    if ([imageView.superview isKindOfClass:[UIButton class]])
    {
        UIButton *button = (UIButton*)imageView.superview;
        [button setImage:self.profileImage forState:UIControlStateNormal];
        [button setImage:self.profileImage forState:UIControlStateSelected];
        [button setImage:self.profileImage forState:UIControlStateHighlighted];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    else
    {
        [imageView setImage:self.profileImage];
    }    
}

@end

@implementation PMFavoriteData

@synthesize userId;
@synthesize firstName;
@synthesize lastName;
@synthesize profilePicUrl;
@synthesize primaryPlateId;
@synthesize primaryPlateLat;
@synthesize primaryPlateLon;
@synthesize profileImage;

-(void) downloadProfileImage:(UIImageView*)imageView
{
    @autoreleasepool 
    {
        if (profilePicUrl != nil && profilePicUrl != @"")
        {
            self.profileImage = [[PMServer sharedInstance] DownloadImage:profilePicUrl :0];
            
            [self performSelectorOnMainThread:@selector(showDownloadedImage:) withObject:imageView waitUntilDone:NO];
        }
    }
}

-(void) showDownloadedImage:(UIImageView*)imageView
{
    if ([imageView.superview isKindOfClass:[UIButton class]])
    {
        UIButton *button = (UIButton*)imageView.superview;
        [button setImage:self.profileImage forState:UIControlStateNormal];
        [button setImage:self.profileImage forState:UIControlStateSelected];
        [button setImage:self.profileImage forState:UIControlStateHighlighted];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    else
    {
        [imageView setImage:self.profileImage];
    }    
}

@end

@implementation PMFiveStarData

@synthesize postId;
@synthesize accountId;
@synthesize rating;
@synthesize firstName;
@synthesize lastName;

@end

@implementation PMFollowerData

@synthesize plateId;
@synthesize accountId;
@synthesize firstName;
@synthesize lastName;
@synthesize plate;
@synthesize profilePicUrl;
@synthesize profileImage;

-(void) downloadProfileImage:(UIImageView*)imageView
{
    @autoreleasepool 
    {
        if (profilePicUrl != nil && profilePicUrl != @"")
        {
            self.profileImage = [[PMServer sharedInstance] DownloadImage:profilePicUrl :0];
            
            if (self.profileImage != nil)
            {
                [self performSelectorOnMainThread:@selector(showDownloadedImage:) withObject:imageView waitUntilDone:NO];
            }
        }
    }
}

-(void) showDownloadedImage:(UIImageView*)imageView
{
    if ([imageView.superview isKindOfClass:[UIButton class]])
    {
        UIButton *button = (UIButton*)imageView.superview;
        [button setImage:self.profileImage forState:UIControlStateNormal];
        [button setImage:self.profileImage forState:UIControlStateSelected];
        [button setImage:self.profileImage forState:UIControlStateHighlighted];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    else
    {
        [imageView setImage:self.profileImage];
    }
}

@end
