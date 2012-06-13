//
//  PhotosViewController.m
//  PlateMe
//
//  Created by Kevin Calcote on 3/18/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PhotosViewController.h"
#import "PMPhotoGalleryButton.h"
#import "PMLoadingView.h"
#import "PMOperationQueue.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "PMUtilities.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <MediaPlayer/MPMoviePlayerViewController.h>

@implementation PhotosViewController

@synthesize galleryData;
@synthesize delegate;
@synthesize initImageUrl;

const CGFloat IMAGESIZE = 73;
const CGFloat IMAGESPACE = 5.5;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    self.view = scrollView;
    
    contentWidth = IMAGESPACE;
    contentHeight = IMAGESPACE;
    
    defaultImageView = [[UIImageView alloc] init];
    
    scrollImages = [[NSMutableArray alloc] init];
    
    imageScrollView = [[UIScrollView alloc] init];
    imageScrollView.pagingEnabled = YES;
    imageScrollView.bounces = NO;
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.showsVerticalScrollIndicator = NO;
    imageScrollView.delegate = self;
    imageScrollView.backgroundColor = [UIColor blackColor];
    
    //Setup the add photo button
    addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPhoto:)];
    // Add this UIButton as a custom view to the self.navigationItem.leftBarButtonItem
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
}
     
-(IBAction)addPhoto:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use Camera", @"Select From Album", nil];
    
    uploadInfo.description = @"Uploading...";
    uploadInfo.viewController = self;
    uploadInfo.requestType = GALLERY;
    
    [actionSheet showInView:[self view]];
    [actionSheet release];
    
    
}

-(IBAction)selectPhoto:(NSString*)description :(UIViewController*)parentViewController
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use Camera", @"Select From Album", nil];
    
    uploadInfo.description = description;
    uploadInfo.viewController = parentViewController;
    uploadInfo.requestType = SELECT;
    
    [actionSheet showInView:[parentViewController view]];
    [actionSheet release];
    
    
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIViewController *parentViewController = uploadInfo.viewController;
    
    //Take action
    switch (buttonIndex) {
        case 0:
        {
            //Handle taking photo
            self.imagePicker.delegate = self;
            
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            NSArray *sourceTypes = 
            [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
            if (![sourceTypes containsObject:(NSString *)kUTTypeMovie ]){
                // no movie type supported...add code to handle that here.
            }
            else
            {
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                
                [mediaTypes addObject:(NSString *)kUTTypeMovie];
                [mediaTypes addObject:(NSString*)kUTTypeImage];
                self.imagePicker.mediaTypes = mediaTypes;
                [mediaTypes release];
            }
            
            [parentViewController presentModalViewController:self.imagePicker animated:YES];
            break;
        }
        case 1:
            //Handle selecting photo from album
            self.imagePicker.delegate = self;
            
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            NSArray *sourceTypes = 
            [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
            if (![sourceTypes containsObject:(NSString *)kUTTypeMovie ]){
                // no movie type supported...add code to handle that here.
            }
            else
            {
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                
                [mediaTypes addObject:(NSString *)kUTTypeMovie];
                [mediaTypes addObject:(NSString*)kUTTypeImage];
                self.imagePicker.mediaTypes = mediaTypes;
                [mediaTypes release];
            }
            
            [parentViewController presentModalViewController:self.imagePicker animated:YES];
            break;
        default:
            //Cancel
            break;
    }
}

-(UIImage*) generateVideoTumbnail:(NSURL*)videoUrl
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    [gen release];
    
    return thumb;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *imageSelected = [[info objectForKey:@"UIImagePickerControllerOriginalImage"] scaleToMax:480];
        
        if (nil != delegate)
            [delegate PhotoSelected:self :imageSelected];
        
        if (uploadInfo.requestType != SELECT)
            [PMLoadingView invokeWithProgress:@selector(doUploadGalleryImage::) onTarget:self :uploadInfo.description :uploadInfo.viewController.view, [imageSelected retain], nil];
    }
    else if ([mediaType isEqualToString:@"public.movie"])
    {
        NSURL *mediaUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        
        if (nil != delegate)
            [delegate VideoSelected:self :[mediaUrl retain]];
        
        if (uploadInfo.requestType != SELECT)
            [PMLoadingView invokeWithProgress:@selector(doUploadGalleryVideo::) onTarget:self :uploadInfo.description :uploadInfo.viewController.view, [mediaUrl retain], nil];
    }
}

-(struct GalleryVideoUrls) doUploadGalleryVideo:(NSNumber*)requestId :(NSURL*)mediaUrl
{
    NSString *retUrl = nil;
    
    // This creates a string with the path to the app's Documents Directory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // This is where you would select the file name for the image you want to save.
    NSString *videoPath = [NSString stringWithFormat:@"%@/MobileVideo_%f.mov", documentsDirectory, [[NSDate date] timeIntervalSince1970]];
    
    NSData *videoData = [NSData dataWithContentsOfURL:mediaUrl];
    
    [[NSFileManager defaultManager] createFileAtPath:videoPath contents:videoData attributes:nil];
    
    UIImage *thumbImage = [self generateVideoTumbnail:mediaUrl];
    NSString *videoThumbnailUrl = [self doThumbnailUpload:[NSNumber numberWithInt:0] :thumbImage];
    
    retUrl = [pmServer UploadGalleryVideo:currentSession.userData.primaryPlateId :videoPath :[requestId intValue] :videoThumbnailUrl];
    
    [self performSelectorOnMainThread:@selector(refreshGalleryData) withObject:nil waitUntilDone:NO];
    
    if (nil != delegate)
        [delegate PhotoUploadFinished:self];
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:videoPath error:&error]; 
    
    struct GalleryVideoUrls urls = {retUrl, videoThumbnailUrl};
    
    return urls;
}

-(NSString*) doUploadGalleryImage:(NSNumber*)requestId :(UIImage*)imageSelected
{
    NSString *retUrl = nil;
    
    // This creates a string with the path to the app's Documents Directory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // This is where you would select the file name for the image you want to save.
    NSString *imagePath = [NSString stringWithFormat:@"%@/MobileImage_%f.png", documentsDirectory, [[NSDate date] timeIntervalSince1970]];
    
    // This creates PNG NSData for the UIImageView imageView's image.
    NSData *imageData = UIImageJPEGRepresentation(imageSelected, 0.5);
    
    // This actually creates the image at the file path specified, with the image's NSData.
    [[NSFileManager defaultManager] createFileAtPath:imagePath contents:imageData attributes:nil];
    
    retUrl = [pmServer UploadGalleryImage:currentSession.userData.primaryPlateId :imagePath :[requestId intValue]];
    
    [self performSelectorOnMainThread:@selector(refreshGalleryData) withObject:nil waitUntilDone:NO];
    
    if (nil != delegate)
        [delegate PhotoUploadFinished:self];
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&error]; 
    
    return retUrl;
}

- (NSString*)doThumbnailUpload:(NSNumber*)requestId :(UIImage*)imageSelected
{
    NSString *retUrl = nil;
    
    // This creates a string with the path to the app's Documents Directory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // This is where you would select the file name for the image you want to save.
    NSString *imagePath = [NSString stringWithFormat:@"%@/MobileThumb_%f.jpg", documentsDirectory, [[NSDate date] timeIntervalSince1970]];
    
    UIImage *thumbImage = [imageSelected scaleToMax:100];
    
    // This creates PNG NSData for the UIImageView imageView's image.
    NSData *imageData = UIImageJPEGRepresentation(thumbImage, 0.3);
    
    // This actually creates the image at the file path specified, with the image's NSData.
    [[NSFileManager defaultManager] createFileAtPath:imagePath contents:imageData attributes:nil];
    
    retUrl = [pmServer UploadImage:imagePath :[requestId intValue]];
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&error]; 
    
    return retUrl;    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (currentSession == [PlateMeSession currentSession])
        self.navigationItem.rightBarButtonItem = addBarButtonItem;
    else
        self.navigationItem.rightBarButtonItem = nil;
    
    [self refreshGalleryData];

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) showImageFromGallery:(NSString*)imageUrl
{
    [self refreshGalleryData];
    
    if (nil != imageUrl)
    {
        int index = 0;
        
        for (PMGalleryImageData *imageData in galleryData)
        {
            if ([imageData.url isEqualToString:imageUrl])
            {
                break;
            }
            index++;
        }
        
        if (index < galleryData.count )
        {
            for (PMPhotoGalleryButton *photoButton in scrollView.subviews)
            {
                if (photoButton.index == index)
                {
                    [self imageSelected:photoButton];
                    break;
                }
            }
        }
        else
        {
            PlateMeViewController *tmpImageController = [[PlateMeViewController alloc] init];
            tmpImageController.navController = navController;
            [tmpImageController viewDidLoad];
            
            //Allocate and download the image
            UIImageView *imageView = [[UIImageView alloc] init];
            PMGalleryImageData *imageData = [[PMGalleryImageData alloc] init];
            imageData.url = imageUrl;
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [tmpImageController.view addSubview:imageView];
            imageView.backgroundColor = [UIColor blackColor];
            imageView.frame = tmpImageController.view.bounds;
            //Initiate download in the background
            [PMLoadingView invokeWithProgress:@selector(downloadImageWithProgress::) onTarget:imageData :@"" :tmpImageController.view, imageView, nil];
        
            [self.navController pushViewController:tmpImageController animated:YES];

            [imageView release];
            [tmpImageController release];
        }
    }    
}

-(void) viewAllPhotos
{
    bool found = false;
    for (UIViewController *viewController in self.navController.viewControllers)
    {
        if (viewController == self)
        {
            [self.navController popToViewController:viewController animated:YES];
            found = true;
        }
    }
    
    if (!found)
        [self.navController pushViewController:self animated:YES];
}

-(void) refreshGalleryData
{
    NSMutableArray *tmpGalleryData = [pmServer GetGalleryImages:[[currentSession userData] primaryPlateId]];
    NSMutableArray *imagesToAdd = nil;
    NSInteger indexOffset = 0;
    
    if (galleryData == nil)
    {
        self.galleryData = tmpGalleryData;
        imagesToAdd = tmpGalleryData;
    }
    else
    {
        imagesToAdd =  [[[NSMutableArray alloc] init] autorelease];
        indexOffset = galleryData.count;
        
        for (PMGalleryImageData *imageData in tmpGalleryData)
        {
            BOOL found = NO;
            
            for (PMGalleryImageData* oldImageData in galleryData)
            {
                if ([imageData.imageId isEqualToString:oldImageData.imageId])
                {
                    if (![oldImageData.url isEqualToString:imageData.url])
                    {
                        oldImageData = imageData;
                    }
                    
                    found = YES;
                    break;
                }
            }
            
            if (!found)
            {
                [galleryData addObject:imageData];
                [imagesToAdd addObject:imageData];
            }
        }
    }
    
    for (uint32_t i = 0; i < imagesToAdd.count; i++)
    {
        PMGalleryImageData *imageData = [imagesToAdd objectAtIndex:i];
        
        PMPhotoGalleryButton *imageButton = [[PMPhotoGalleryButton alloc] init];
        [imageButton addTarget:self action:@selector(imageSelected:)  forControlEvents:UIControlEventTouchUpInside];
        
        imageButton.index = i+indexOffset;
        
        [imageButton.layer setBorderWidth:1.0f];
        
        [imageButton setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
        
        [PMOperationQueue performLowPrioritySelector:imageData :@selector(downloadThumbnail:), imageButton.imageView];
        
        [scrollView addSubview:imageButton];
        
        imageButton.frame = CGRectMake(contentWidth, contentHeight, IMAGESIZE, IMAGESIZE);
        
        contentWidth += (IMAGESIZE + IMAGESPACE);
        
        if ((contentWidth + IMAGESIZE) > 320)
        {
            contentWidth = IMAGESPACE;
            contentHeight += (IMAGESIZE + IMAGESPACE);
        }
        
        [scrollImages addObject:defaultImageView];
        [imageButton release];
    }
    
    scrollView.contentSize = CGSizeMake(320, contentHeight);
    [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void) initialize
{
    [scrollImages removeAllObjects];
    for (UIView *subView in scrollView.subviews)
    {
        [subView removeFromSuperview];
    }
    self.galleryData = nil;
    contentWidth = IMAGESPACE;
    contentHeight = IMAGESPACE;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)imageSelected:(id)sender
{
    PMPhotoGalleryButton *photoButton = (PMPhotoGalleryButton*)sender;
    PMGalleryImageData *imageData = (PMGalleryImageData*)[galleryData objectAtIndex:photoButton.index];
    
    if ([imageData.mediaType isEqualToString:@"image"])
    {
        PlateMeViewController *imageController = [[PlateMeViewController alloc] init];
        imageController.navController = self.navController;
        [imageController viewDidLoad];
        imageController.view = imageScrollView;
        imageController.view.frame = [[UIScreen mainScreen] applicationFrame];
        
        //Set the content offset for the selected image
        [imageScrollView setContentOffset:CGPointMake(photoButton.index*320, 0) animated:NO];
        
        //Setup the add photo button
        UIBarButtonItem *imageBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(viewAllPhotos)];
        // Add this UIButton as a custom view to the self.navigationItem.rightBarButtonItem
        imageController.navigationItem.rightBarButtonItem = imageBarButtonItem;
        [imageBarButtonItem release];
        
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        ((UIScrollView*)imageController.view).contentSize = CGSizeMake(320*galleryData.count, 480-self.navController.navigationBar.bounds.size.height-statusBarFrame.size.height);
        
        //Show the image
        [self showImageInScrollView:photoButton.index :imageController.view];
        
        //Push the scroll view controller
        [self.navController pushViewController:imageController animated:YES];
        [imageController release];
    }
    else if ([imageData.mediaType isEqualToString:@"video"])
    {
        NSURL *videoURL = [NSURL URLWithString:imageData.url];
        MPMoviePlayerViewController *moviePlayerView = [[[MPMoviePlayerViewController alloc] initWithContentURL:videoURL] autorelease];
        [self presentMoviePlayerViewControllerAnimated:moviePlayerView];        
    }
}

- (void) showImageInScrollView:(NSInteger) index :(UIView*)parentView
{
    if ([scrollImages objectAtIndex:index] == defaultImageView)
    {
        PMGalleryImageData *imageData = (PMGalleryImageData*)[galleryData objectAtIndex:index];
        
        UIImageView *imageView = nil;
        
        if (imageData.image != nil)
        {
            //Image has already been downloaded but isnt visible, allocate it
            imageView = [[UIImageView alloc] initWithImage:imageData.image];
        }
        else if ((nil != imageData.url) && (![imageData.url isEqualToString:@""]) &&(![imageData.url isEqualToString:@"0"]))
        {
            //Allocate and download the image
            imageView = [[UIImageView alloc] init];
            //A frame needs to be set for the loading view
            CGRect imageFrame = parentView.bounds;
            imageFrame.origin.x = 320 * index;
            [imageView setFrame:imageFrame];
            if ([imageData.mediaType isEqualToString:@"video"])
            {
                imageView.image = imageData.thumbnailImage;
            }
            else
            {
                //Initiate download in the background
                [PMLoadingView invokeWithProgress:@selector(downloadImageWithProgress::) onTarget:imageData :@"" :imageScrollView, imageView, nil];
            }
        }
        
        //If an image was allocated then set properties
        if (nil != imageView)
        {
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            CGRect imageFrame = parentView.bounds;
            imageFrame.origin.x = 320 * index;
            [imageView setFrame:imageFrame];
            [parentView addSubview:imageView];
            [scrollImages replaceObjectAtIndex:index withObject:imageView];
            [imageView release];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollViewL
{
    if (scrollViewL == imageScrollView)
    {
        NSInteger index = scrollViewL.contentOffset.x/320;
        [self showImageInScrollView:index :scrollViewL];
    }
}

- (void) dealloc
{
    [super dealloc];
    
    [scrollImages removeAllObjects];
    
    [imageScrollView release];
    [scrollView release];
    [scrollImages release];
    [defaultImageView release];
}

@end
