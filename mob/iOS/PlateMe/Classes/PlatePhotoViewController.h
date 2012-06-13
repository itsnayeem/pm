//
//  PlatePhotoViewController.h
//  PlateMe
//
//  Created by Kevin Calcote on 1/13/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlateMeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PlatePhotoViewController : PlateMeViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UIImageView *cameraImageView;
    IBOutlet UIImageView *headerImageView;
    IBOutlet UIImageView *footerImageView;
    
    AVCaptureSession *session;
    AVCaptureDeviceInput *input;
}

- (IBAction)takePicturePressed:(id)sender;

@end
