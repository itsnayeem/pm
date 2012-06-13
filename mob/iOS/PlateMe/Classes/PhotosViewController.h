//
//  PhotosViewController.h
//  PlateMe
//
//  Created by Kevin Calcote on 3/18/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PlateMeViewController.h"

@class PMPhotoGalleryButton;
@class PhotosViewController;

struct GalleryVideoUrls
{
    NSString *videoUrl;
    NSString *videoThumbnailUrl;
};

@protocol PhotosViewControllerDelegate <NSObject>
@optional
    -(void) PhotoSelected:(PhotosViewController*)photosViewController :(UIImage*)image;
    -(void) VideoSelected:(PhotosViewController*)photosViewController :(NSURL*)videoUrl;
    -(void) PhotoUploadFinished:(PhotosViewController*)photosViewController;
@end

@interface PhotosViewController : PlateMeViewController <UIScrollViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    enum PhotoUploadType
    {
        GALLERY = 1,
        POST,
        SELECT
    };
    
    struct PhotoUploadInfo
    {
        enum PhotoUploadType requestType;
        UIViewController *viewController;
        NSString *description;
    };
    
    UIScrollView *scrollView;
    NSMutableArray *galleryData;
    UIScrollView *imageScrollView;
    NSMutableArray *scrollImages;
    UIImageView *defaultImageView;
    CGFloat contentHeight;
    CGFloat contentWidth;
    id<PhotosViewControllerDelegate> delegate;
    enum PhotoUploadType uploadType;
    struct PhotoUploadInfo uploadInfo;
    UIBarButtonItem *addBarButtonItem;
}

@property (retain) NSMutableArray *galleryData;
@property (retain) id<PhotosViewControllerDelegate> delegate;
@property (retain) NSString *initImageUrl;

-(IBAction)imageSelected:(id)sender;
- (void) showImageInScrollView:(NSInteger) index :(UIView*)parentView;
-(IBAction)addPhoto:(id)sender;
-(NSString*) doUploadGalleryImage:(NSNumber*)requestId :(UIImage*)imageSelecteddoUploadGalleryImage;
-(struct GalleryVideoUrls) doUploadGalleryVideo:(NSNumber*)requestId :(NSURL*)mediaUrl;
-(void) refreshGalleryData;
-(IBAction)selectPhoto:(NSString*)description :(UIViewController*)parentViewController;
- (void) initialize;
- (void) showImageFromGallery:(NSString*)imageUrl;
-(void) viewAllPhotos;
-(UIImage*) generateVideoTumbnail:(NSURL*)videoUrl;
-(NSString*)doThumbnailUpload:(NSNumber*)requestId :(UIImage*)imageSelected;

@end
