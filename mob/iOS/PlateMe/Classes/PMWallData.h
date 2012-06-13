//
//  PMWallData.h
//  PlateMe
//
//  Created by Kevin Calcote on 2/4/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostTableCell.h"

@interface PMPostData : NSObject 
{
    NSString *profilePicUrl;
    UIImage *profileImage;
    UIImage *postImage;
    NSString *text;
    NSString *posterName;
    NSString *averageRating;
    NSString *postId;
    NSString *ownerId;
    NSString *plateId;
    NSString *parentId;
    NSString *timestamp;
    NSString *numRatings;
    NSString *postImageUrl;
    NSString *postVideoUrl;
    NSString *postVideoThumbnailUrl;
    CGSize textSize;
    NSMutableArray *comments;
    PostTableCell *assignedCell;
}

@property (retain) NSString *profilePicUrl;
@property (retain) UIImage *profileImage;
@property (retain) UIImage *postImage;
@property (retain) NSString *text;
@property (retain) NSString *posterName;
@property (retain) NSString *averageRating;
@property (retain) NSString *postId;
@property (retain) NSString *ownerId;
@property (retain) NSString *plateId;
@property (retain) NSString *parentId;
@property (retain) NSString *timestamp;
@property (retain) NSString *numRatings;
@property (retain) NSString *postImageUrl;
@property (retain) NSString *postVideoUrl;
@property (retain) NSString *postVideoThumbnailUrl;
@property (assign) PostTableCell *assignedCell;
@property (assign) CGSize textSize;
@property (retain) NSMutableArray *comments;

-(void) updatePost:(PMPostData*)newData;
-(void) downloadProfileImage:(PostTableCell*) cellToUpdate;
-(void) downloadPostImage:(PostTableCell*)cellToUpdate;
-(void) downloadPostThumbnailImage:(PostTableCell*)cellToUpdate;
-(void) showDownloadedImage:(PostTableCell*)cellToUpdate;
-(void) showDownloadedPostImage:(UIImageView*)imageView;

@end

@interface PMWallData : NSObject
{
    NSMutableArray *posts;
}

@property (retain) NSMutableArray *posts;

-(PMPostData*) findPost:(NSString*)postId;
+(PMPostData*) findPost:(NSArray*)postsL :(NSString*)postId;

@end
