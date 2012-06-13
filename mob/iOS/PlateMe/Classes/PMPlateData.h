//
//  PMPlateData.h
//  PlateMe
//
//  Created by Kevin Calcote on 2/5/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMWallData;

@interface PMPlateData : NSObject
{
    NSString *plateId;
    NSString *make;
    NSString *model;
    NSString *plateNumber;
    NSString *color;
    NSString *associatedAccountId;
    NSString *year;
    NSString *state;
    NSString *latitude;
    NSString *longitude;
    NSString *platePicUrl;
    PMWallData *wallData;
    UIImage *plateImage;
}

-(void) downloadProfileImage:(UIImageView*)imageView;
-(NSMutableArray*) updatePosts:(NSMutableArray*)oldPosts :(NSMutableArray*)posts :(BOOL)addToEnd;

@property (retain) PMWallData *wallData;
@property (retain) NSString* plateId;
@property (retain) NSString *make;
@property (retain) NSString *model;
@property (retain) NSString *plateNumber;
@property (retain) NSString *color;
@property (retain) NSString *associatedAccountId;
@property (retain) NSString *year;
@property (retain) NSString *state;
@property (retain) NSString *latitude;
@property (retain) NSString *longitude;
@property (retain) NSString *platePicUrl;
@property (retain) UIImage *plateImage;

@end

@interface PMGalleryImageData : NSObject 
{
    NSString *imageId;
    NSString *plateId;
    NSString *accountId;
    NSString *url;
    NSString *thumbnailUrl;
    NSString *uploadedOn;
    NSString *mediaType;
    UIImage *image;
    UIImage *thumbnailImage;
}

@property (retain) NSString *imageId;
@property (retain) NSString *plateId;
@property (retain) NSString *accountId;
@property (retain) NSString *url;
@property (retain) NSString *thumbnailUrl;
@property (retain) NSString *mediaType;
@property (retain) NSString *uploadedOn;
@property (retain) UIImage *image;
@property (retain) UIImage *thumbnailImage;

-(void) downloadImage:(UIImageView*)imageView;
-(void) downloadImageWithProgress:(NSNumber*)requestId :(UIImageView*)imageView;
-(void) downloadThumbnail:(UIImageView*)imageView;
-(void) showDownloadedImage:(UIImageView*)imageView;
-(void) showDownloadedThumbnailImage:(UIImageView*)imageView;

@end
