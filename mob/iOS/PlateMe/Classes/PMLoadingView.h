//
//  PMLoadingView.h
//  PlateMe
//
//  Created by Kevin Calcote on 1/20/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMLoadingView;

@interface PMProgress :  NSObject
{
    float progressValue;
    float prevProgressValue;
    PMLoadingView *loadingView;
}

@property (assign) float progressValue;
@property (assign) float prevProgressValue;
@property (retain) PMLoadingView *loadingView;

@end

@interface InvokeData : NSObject{
    NSInvocation *invocation;
    UIActivityIndicatorView *spinner;
    UIView *loadingView;
}

@property (retain) UIActivityIndicatorView *spinner;
@property (retain) NSInvocation *invocation;
@property (retain) UIView *loadingView;

@end

@interface PMLoadingView : UIView
{
    UIActivityIndicatorView *spinner;
    UIProgressView *progress;
    UILabel *loadingDetails;
    PMProgress *pmProgress;
}

@property (retain) UIActivityIndicatorView *spinner;
@property (retain) UIProgressView *progress;
@property (retain) PMProgress *pmProgress;

+(void)invokeWithLoading:(SEL)method onTarget:(id)target :(NSString*)details :(id)parentView, ...;
+(void)invokeWithProgress:(SEL)method onTarget:(id)target :(NSString*)details :(id)parentView, ...;
+(void)invokeFinished;
+(PMLoadingView*) dequeuePMLoadingView:(UIView*)parentView;
+(void)enqueuePMLoadingView:(PMLoadingView*)loadingView;
+(NSMutableArray*) pmLoadingViewQueue;
+(NSMutableDictionary*) pmProgressDictionary;
+(PMProgress*) getProgressForRequest:(NSInteger)requestId;
+(NSLock*) progressDictLock;
-(void)execute:(InvokeData*)invokeData;
-(void)setLoadingDetails:(NSString*)details;
-(void)progressThreadEntry;
-(void)updateProgress:(NSNumber*)progressNumber;

+(void)setProgressValue:(double)progValue :(NSInteger)requestId;

@end
