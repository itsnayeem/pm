//
//  PMUserData.h
//  PlateMe
//
//  Created by Kevin Calcote on 2/4/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMUserData : NSObject
{
    NSString *userId;
    NSString *email;
    NSString *firstName;
    NSString *lastName;
    NSString *primaryPlateId;
    NSString *profilePicUrl;
    UIImage *profileImage;
}

@property (retain) NSString *userId;
@property (retain) NSString *email;
@property (retain) NSString *firstName;
@property (retain) NSString *lastName;
@property (retain) NSString *primaryPlateId;
@property (retain) NSString *profilePicUrl;
@property (retain) UIImage *profileImage;

-(void) downloadProfileImage:(UIImageView*)imageView;
-(void) showDownloadedImage:(UIImageView*)imageView;

@end

@interface PMFavoriteData : NSObject 
{
    NSString *userId;
    NSString *firstName;
    NSString *lastName;
    NSString *profilePicUrl;
    NSString* primaryPlateId;
    NSString* primaryPlateLat;
    NSString* primaryPlateLon;
    UIImage *profileImage;
}

@property (retain) NSString* userId;
@property (retain) NSString* firstName;
@property (retain) NSString* lastName;
@property (retain) NSString* profilePicUrl;
@property (retain) NSString* primaryPlateId;
@property (retain) NSString* primaryPlateLat;
@property (retain) NSString* primaryPlateLon;
@property (retain) UIImage *profileImage;

-(void) downloadProfileImage:(UIImageView*)imageView;
-(void) showDownloadedImage:(UIImageView*)imageView;

@end

@interface PMFollowerData : NSObject 
{
    NSString *plateId;
    NSString *accountId;
    NSString *firstName;
    NSString *lastName;
    NSString *plate;
    NSString *profilePicUrl;
    UIImage *profileImage;
}

@property (retain) NSString *plateId;
@property (retain) NSString *accountId;
@property (retain) NSString *firstName;
@property (retain) NSString *lastName;
@property (retain) NSString *profilePicUrl;
@property (retain) NSString *plate;
@property (retain) UIImage *profileImage;

-(void) downloadProfileImage:(UIImageView*)imageView;
-(void) showDownloadedImage:(UIImageView*)imageView;

@end

@interface PMFiveStarData : NSObject 
{
    NSString *postId;
    NSString *accountId;
    NSString *rating;
    NSString *firstName;
    NSString *lastName;
}

@property (retain) NSString *postId;
@property (retain) NSString *accountId;
@property (retain) NSString *rating;
@property (retain) NSString *firstName;
@property (retain) NSString *lastName;

@end
