//
//  PMWallData.m
//  PlateMe
//
//  Created by Kevin Calcote on 2/4/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PMWallData.h"
#import "PMServer.h"

@implementation PMPostData

@synthesize profilePicUrl;
@synthesize profileImage;
@synthesize postImage;
@synthesize text;
@synthesize posterName;
@synthesize assignedCell;
@synthesize averageRating;
@synthesize postId;
@synthesize ownerId;
@synthesize plateId;
@synthesize timestamp;
@synthesize numRatings;
@synthesize postImageUrl;
@synthesize postVideoUrl;
@synthesize postVideoThumbnailUrl;
@synthesize parentId;
@synthesize comments;
@synthesize textSize;

-(id) init
{
    self = [super init];
    if (self)
    {
        comments = [[[NSMutableArray alloc] init] retain];
    }
    
    profileImage = nil;
    
    return self;
}

-(void) downloadProfileImage:(PostTableCell*)cellToUpdate
{
    @autoreleasepool 
    {
        if (profilePicUrl != nil && profilePicUrl != @"")
        {
            self.profileImage = [[PMServer sharedInstance] DownloadImage:profilePicUrl :0];
            
            if (self.profileImage != nil && cellToUpdate.postData == self)
            {
                [self performSelectorOnMainThread:@selector(showDownloadedImage:) withObject:cellToUpdate waitUntilDone:NO];
            }
        }
    }
}

-(void) downloadPostImage:(PostTableCell*)cellToUpdate
{
    @autoreleasepool 
    {
        if (postImageUrl != nil && postImageUrl != @"")
        {
            self.postImage = [[PMServer sharedInstance] DownloadImage:postImageUrl :0];
            
            if (self.postImage && cellToUpdate.postData == self)
            {
                [self performSelectorOnMainThread:@selector(showDownloadedPostImage:) withObject:cellToUpdate.postImageButton.imageView waitUntilDone:NO];
            }
        }
    }
}

-(void) downloadPostThumbnailImage:(PostTableCell*)cellToUpdate
{
    @autoreleasepool 
    {
        if (postVideoThumbnailUrl != nil && postVideoThumbnailUrl != @"")
        {
            self.postImage = [[PMServer sharedInstance] DownloadImage:postVideoThumbnailUrl :0];
            
            if (self.postImage && cellToUpdate.postData == self)
            {
                [self performSelectorOnMainThread:@selector(showDownloadedPostImage:) withObject:cellToUpdate.postImageButton.imageView waitUntilDone:NO];
            }
        }
    }    
}

-(void) showDownloadedPostImage:(UIImageView*)imageView
{
    if ([imageView.superview isKindOfClass:[UIButton class]])
    {
        UIButton *button = (UIButton*)imageView.superview;
        [button setImage:self.postImage forState:UIControlStateNormal];
        [button setImage:self.postImage forState:UIControlStateSelected];
        [button setImage:self.postImage forState:UIControlStateHighlighted];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    else
    {
        [imageView setImage:self.postImage];
    }    
}

-(void) showDownloadedImage:(PostTableCell*)cellToUpdate
{
    [cellToUpdate.profilePicButton setBackgroundImage:self.profileImage forState:UIControlStateNormal];    
}

-(void) updatePost:(PMPostData*)newData
{
    //Update comments
    for (PMPostData* newComment in newData.comments)
    {
        for (PMPostData* oldComment in comments)
        {
            if ([oldComment.postId isEqualToString:newComment.postId])
            {
                [oldComment updatePost:newComment];
                break;
            }
        }
    }
    
    if (![newData.profilePicUrl isEqualToString:profilePicUrl])
    {
        profilePicUrl = newData.profilePicUrl;
        [profileImage release];
        profileImage = nil;
    }
}

- (void) dealloc
{
    [profileImage release];
    
    [super dealloc];
}

@end

@implementation PMWallData

@synthesize posts;

-(id) init
{
    
    posts = [[[NSMutableArray alloc] init] retain];
    
    return self;
}

-(void) dealloc
{
    [posts release];
    
    [super dealloc];
}

-(PMPostData*) findPost:(NSString*)postId
{
    PMPostData *retPost = nil;
    
    for (PMPostData *post in posts) 
    {
        if ([post.postId isEqualToString:postId])
        {
            retPost = post;
            break;
        }
        
    }
    
    return retPost;
}

+(PMPostData*) findPost:(NSArray*)postsL :(NSString*)postId
{
    PMPostData *retPost = nil;
    
    for (PMPostData *post in postsL) 
    {
        if ([post.postId isEqualToString:postId])
        {
            retPost = post;
            break;
        }
        
    }
    
    return retPost;    
}

@end
