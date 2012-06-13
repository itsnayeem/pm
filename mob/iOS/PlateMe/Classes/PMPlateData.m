//
//  PMPlateData.m
//  PlateMe
//
//  Created by Kevin Calcote on 2/5/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PMPlateData.h"
#import "PMWallData.h"
#import "PMServer.h"

@implementation PMPlateData

@synthesize plateId;
@synthesize plateNumber;
@synthesize color;
@synthesize make;
@synthesize model;
@synthesize associatedAccountId;
@synthesize year;
@synthesize state;
@synthesize latitude;
@synthesize longitude;
@synthesize platePicUrl;
@synthesize plateImage;
@synthesize wallData;

-(id) init
{
    self = [super init];
    
    if (self)
    {
        wallData = [[[PMWallData alloc] init] retain];
        plateImage = nil;
    }
    
    return self;
}

-(void) downloadProfileImage:(UIImageView*)imageView
{
    @autoreleasepool
    {
        if (platePicUrl != nil && platePicUrl != @"")
        {
            self.plateImage = [[PMServer sharedInstance] DownloadImage:platePicUrl :0];
            
            if (self.plateImage != nil)
            {
                [imageView setImage:self.plateImage];
            }
        }
    }
}
/*
-(PMWallData*) wallData
{
    return wallData;
}

-(void) setWallData:(PMWallData *)wallDataL
{
    if (wallData == nil)
    {
        wallData = wallDataL;
    }
    else
    {
        wallData.posts = [self updatePosts:wallData.posts :wallDataL.posts :YES];
    }
}
*/

-(NSMutableArray*) updatePosts:(NSMutableArray*)oldPosts :(NSMutableArray*)posts :(BOOL)addToEnd
{
    for (PMPostData* post in posts)
    {
        BOOL found = NO;
        for (PMPostData* oldPost in oldPosts)
        {
            if ([oldPost.postId isEqualToString:post.postId])
            {
                found = YES;
                [oldPost updatePost:post];
                oldPost.comments = [self updatePosts:oldPost.comments :post.comments :YES];
                break;
            }
        }
        
        if (!found)
        {
            if (addToEnd)
            {
                [oldPosts addObject:post];
            }
            else
            {
                [oldPosts insertObject:post atIndex:0];            
            }
        }
    }
    
    NSMutableArray *indexesToDelete = [[NSMutableArray alloc] init];
    for (PMPostData* post in oldPosts)
    {
        BOOL found = NO;
        
        for (PMPostData* newPostData in posts)
        {
            if ([post.postId isEqualToString:newPostData.postId])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [indexesToDelete addObject:post];
        }
    }
    
    [oldPosts removeObjectsInArray:indexesToDelete];
    
    return oldPosts;
}


-(void)dealloc
{
    [wallData release];
    
    [super dealloc];
}

@end

@implementation PMGalleryImageData

@synthesize imageId;
@synthesize plateId;
@synthesize accountId;
@synthesize url;
@synthesize thumbnailUrl;
@synthesize uploadedOn;
@synthesize mediaType;
@synthesize image;
@synthesize thumbnailImage;

-(void) downloadImage:(UIImageView*)imageView
{
    @autoreleasepool
    {
        if (url != nil && url != @"")
        {
            if ((url.length >= 7) && ![[url substringToIndex:7] isEqualToString:@"http://"])
                self.url = [NSString stringWithFormat:@"%@%@", @"http://", url];
            
            self.image = [[PMServer sharedInstance] DownloadImage:url :0];
            
            if (nil != self.image)
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
        [button setImage:self.image forState:UIControlStateNormal];
        [button setImage:self.image forState:UIControlStateSelected];
        [button setImage:self.image forState:UIControlStateHighlighted];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    else
    {
        [imageView setImage:self.image];
    }
}

-(void) downloadImageWithProgress:(NSNumber*)requestId :(UIImageView*)imageView
{
    @autoreleasepool
    {
        if (url != nil && url != @"")
        {
            if ((url.length >= 7) && ![[url substringToIndex:7] isEqualToString:@"http://"])
                self.url = [NSString stringWithFormat:@"%@%@", @"http://", url];
            
            self.image = [[PMServer sharedInstance] DownloadImage:url :[requestId intValue]];
            
            if (nil != self.image)
            {
                [self performSelectorOnMainThread:@selector(showDownloadedImage:) withObject:imageView waitUntilDone:NO];
            }
        }
    }
}

-(void) downloadThumbnail:(UIImageView*)imageView
{
    @autoreleasepool
    {
        NSString *urlToUse = nil;
        
        if (thumbnailUrl != nil && ![thumbnailUrl isEqualToString:@""])
            urlToUse = thumbnailUrl;
        else if (url != nil && ![url isEqualToString:@""])
            urlToUse = url;
        
        if (nil != urlToUse)
        {
            if ((urlToUse.length >= 7) && ![[urlToUse substringToIndex:7] isEqualToString:@"http://"])
                self.thumbnailUrl = [NSString stringWithFormat:@"%@%@", @"http://", urlToUse];
            
            self.thumbnailImage = [[PMServer sharedInstance] DownloadImage:urlToUse :0];
            
            if (nil != self.thumbnailImage)
            {
                [self performSelectorOnMainThread:@selector(showDownloadedThumbnailImage:) withObject:imageView waitUntilDone:NO];
            }
        }
    }
}

-(void) showDownloadedThumbnailImage:(UIImageView*)imageView
{
    if ([imageView.superview isKindOfClass:[UIButton class]])
    {
        UIButton *button = (UIButton*)imageView.superview;
        [button setImage:self.thumbnailImage forState:UIControlStateNormal];
        [button setImage:self.thumbnailImage forState:UIControlStateSelected];
        [button setImage:self.thumbnailImage forState:UIControlStateHighlighted];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    else
    {
        [imageView setImage:self.thumbnailImage];
    }    
}

-(void) dealloc
{
    [super dealloc];
    
    //[imageId release];
    //[plateId release];
    //[accountId release];
    //[url release];
    //[thumbnailUrl release];
    //[uploadedOn release];
    //[mediaType release];
    [image release];
    [thumbnailImage release];
}

@end
