//
//  PMTesseract.m
//  PlateMe
//
//  Created by Kevin Calcote on 1/17/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PMPlate.h"

@implementation PMPlate

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initTesseract];
    }
    
    return self;
}


- (void)initTesseract
{
    // Set up the tessdata path. This is included in the application bundle
    // but is copied to the Documents directory on the first run.
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
    
    NSString *dataPath = [documentPath stringByAppendingPathComponent:@"tessdata"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:dataPath]) {
        // get the path to the app bundle (with the tessdata dir)
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:@"tessdata"];
        if (tessdataPath) {
            [fileManager copyItemAtPath:tessdataPath toPath:dataPath error:NULL];
        }
    }
    
    setenv("TESSDATA_PREFIX", [[documentPath stringByAppendingString:@"/"] UTF8String], 1);
    
    // init the tesseract engine.
    pmPlate = new PMLibCpp::PMPlate();
    pmPlate->Init([dataPath cStringUsingEncoding:NSUTF8StringEncoding], "eng");
}

- (void)SetPlateImage:(UIImage *)image
{

}

- (NSString*) GetPlateText:(UIImage *)image
{
    free(pixels);
    
    CGSize size = [image size];
    int width = size.width;
    int height = size.height;
	
	if (width <= 0 || height <= 0)
		return nil;
	
    // the pixels will be painted to this array
    pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
	
	// we're done with the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    pmPlate->SetPlateImage((const unsigned char *) pixels, width, height, sizeof(uint32_t), width * sizeof(uint32_t));
    
    char* utf8Text = pmPlate->GetPlateText();
    
    return [[NSString alloc] initWithUTF8String:utf8Text];
    //[self performSelectorOnMainThread:@selector(ocrProcessingFinished:)
    //                       withObject:[NSString stringWithUTF8String:utf8Text]
    //                    waitUntilDone:NO];
}
 

@end
