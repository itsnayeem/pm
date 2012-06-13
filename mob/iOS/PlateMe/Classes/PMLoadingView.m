//
//  PMLoadingView.m
//  PlateMe
//
//  Created by Kevin Calcote on 1/20/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#include "stdarg.h"
#import "PMLoadingView.h"
#import "PMOperationQueue.h"
#import <QuartzCore/QuartzCore.h>

@implementation PMProgress

@synthesize progressValue;
@synthesize prevProgressValue;
@synthesize loadingView;

@end

@implementation InvokeData

@synthesize invocation;
@synthesize spinner;
@synthesize loadingView;

@end

@implementation PMLoadingView

@synthesize progress;
@synthesize spinner;
@synthesize pmProgress;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Allocate progress
        pmProgress = [[PMProgress alloc] init];
        pmProgress.loadingView = self;
        pmProgress.progressValue = 0;
        pmProgress.prevProgressValue = 0;
        
        //Allocate the spinner
        spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] retain];
        
        //Allocate progress view
        progress = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] retain];
        
        //Allocate the loading details label
        loadingDetails = [[[UILabel alloc] init] retain];
        loadingDetails.textColor = [UIColor whiteColor];
        [loadingDetails setBackgroundColor:[UIColor clearColor]];
        
        //Set spinner details
        [spinner setAutoresizingMask:UIViewAutoresizingNone];
        
        //Set view details
        [self addSubview:spinner];
        [self addSubview:loadingDetails];
        [self bringSubviewToFront:spinner];
        [self bringSubviewToFront:loadingDetails];
        [self clipsToBounds];
        [self setBackgroundColor:[UIColor blackColor]];
        [self setAlpha:0.7f];
        [self.layer setCornerRadius:15.0f];
        
        [self addSubview:progress];
    }
    
    return self;
}

+(NSLock*) progressDictLock
{
    static NSLock *lock = nil;
    
    if (nil == lock)
    {
        lock = [[NSLock alloc] init];
    }
    
    return lock;
}

+(PMProgress*) getProgressForRequest:(NSInteger)requestId
{
    [[PMLoadingView progressDictLock] lock];
    PMProgress *progress = [[PMLoadingView pmProgressDictionary] valueForKey:[NSString stringWithFormat:@"%i", requestId]];
    [[PMLoadingView progressDictLock] unlock];
    
    return progress;
}

+(void) setProgressForRequest:(PMProgress*)thePmProgress :(NSInteger)requestId
{
    [[PMLoadingView progressDictLock] lock];
    [[PMLoadingView pmProgressDictionary] setValue:thePmProgress forKey:[NSString stringWithFormat:@"%i", requestId]];
    [[PMLoadingView progressDictLock] unlock];
}

+(void)setProgressValue:(double)progValue :(NSInteger)requestId
{
    PMProgress *thePmProgress = [PMLoadingView getProgressForRequest:requestId];
    thePmProgress.progressValue = (float)progValue;
    
    if ((thePmProgress.progressValue - thePmProgress.prevProgressValue) >= 0.01f)
    {
        thePmProgress.prevProgressValue = thePmProgress.progressValue;
        
        //Update the progress on the main thread
        NSNumber *progressNumber = [[NSNumber numberWithFloat:thePmProgress.progressValue] retain];
        
        [thePmProgress.loadingView performSelectorOnMainThread:@selector(updateProgress:) withObject:progressNumber waitUntilDone:YES];
    }
}


-(void)updateProgress:(NSNumber*)progressNumber
{
    [progress setProgress:[progressNumber floatValue]];
}

-(void)setLoadingDetails:(NSString*)details
{
    //Set the text
    [loadingDetails setText:details];
    
    //Determine the text size
    CGSize textSize = [loadingDetails.text 
                       sizeWithFont:loadingDetails.font 
                       constrainedToSize:CGSizeMake(self.bounds.size.width, 2000)
                       lineBreakMode:UILineBreakModeWordWrap];
    
    //Set the text frame
    [loadingDetails setFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
    [loadingDetails setCenter:CGPointMake(self.bounds.size.width/2, textSize.height)];
}

+(NSMutableArray*) pmLoadingViewQueue
{
    static NSMutableArray *loadingArray = nil;
    
    if (nil == loadingArray)
    {
        loadingArray = [[NSMutableArray alloc] init];
    }
    
    return loadingArray;
}

+(PMLoadingView*) dequeuePMLoadingView:(UIView*)parentView
{
    NSMutableArray *loadingArray = [PMLoadingView pmLoadingViewQueue];
    PMLoadingView *loadingView = nil;
    
    if (loadingArray.count > 0)
    {
        loadingView = [loadingArray objectAtIndex:0];
    }
    else
    {
        loadingView = [[PMLoadingView alloc] init];
    }
    
    [loadingView setFrame:parentView.bounds];
    [loadingView setCenter:CGPointMake((loadingView.frame.origin.x + loadingView.frame.size.width)/2, (loadingView.frame.origin.y + loadingView.frame.size.height)/2)];
    [loadingView setFrame:CGRectMake(loadingView.bounds.origin.x, loadingView.bounds.origin.y, 150, 100)];
    
    //Set after added details
    [loadingView.spinner setCenter:loadingView.center];
    [loadingView.spinner startAnimating];
    
    [loadingView.progress setBounds:CGRectMake(0,0, loadingView.frame.size.width-10, loadingView.progress.frame.size.height)];
    [loadingView.progress setCenter:loadingView.center];
    
    return loadingView;
}

+(void)enqueuePMLoadingView:(PMLoadingView*)loadingView;
{
    NSMutableArray *loadingArray = [PMLoadingView pmLoadingViewQueue];
    
    [loadingView.spinner stopAnimating];
    
    [loadingArray addObject:loadingView];
}

+(NSMutableDictionary*) pmProgressDictionary
{
    static NSMutableDictionary *progressDict = nil;
    
    if (nil == progressDict)
    {
        progressDict = [[NSMutableDictionary alloc] init];
    }
    
    return progressDict;
}

+(void)invokeWithLoading:(SEL)method onTarget:(id)target :(NSString*)details :(id)parentView, ...
{
    PMLoadingView *loadingView = [PMLoadingView dequeuePMLoadingView:parentView];
    
    loadingView.pmProgress.progressValue = 0;
    loadingView.pmProgress.prevProgressValue = 0;
    [loadingView.progress removeFromSuperview];
    
    if (loadingView != loadingView.spinner.superview)
        [loadingView addSubview:loadingView.spinner];
    
    //Support scroll views
    if ([(UIView*)parentView isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scrollView = (UIScrollView*)parentView;
        
        CGPoint center = scrollView.contentOffset;
        
        center.x = center.x + 160;
        center.y = center.y + 220;
        [loadingView setCenter:center];
    }
    else
    {
        [loadingView setCenter:((UIView*)parentView).center];
    }
    
    NSMethodSignature *signature = [target methodSignatureForSelector:method];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:target];
    [invocation setSelector:method];
    
    if (nil != parentView)
    {
        va_list args;
        va_start(args, parentView);
        
        id value;
        NSInteger argCount = [signature numberOfArguments] - 2;
        
        for (int argIndex = 0; argIndex < argCount; argIndex++)
        {
            value = va_arg(args, id);
            [invocation setArgument:&value atIndex:argIndex+2];
        }
        
        va_end(args);
    }
    
    //Set the details for the loading view
    [loadingView setLoadingDetails:details];
    
    //Add the loading view to the parent view
    [parentView addSubview:loadingView];
    
    //Create invoke data
    InvokeData *invokeData = [InvokeData alloc];
    invokeData.invocation = invocation;    
    invokeData.loadingView = loadingView;
    
    [loadingView performSelectorInBackground:@selector(execute:) withObject:invokeData];
    //Perform the invoke
    //[PMOperationQueue performHighPrioritySelector:loadingView :@selector(execute:), invokeData];
}

+(void)invokeWithProgress:(SEL)method onTarget:(id)target :(NSString*)details :(id)parentView, ...
{
    PMLoadingView *loadingView = [PMLoadingView dequeuePMLoadingView:parentView];
    
    [loadingView.spinner removeFromSuperview];
    
    if (loadingView != loadingView.progress.superview)
        [loadingView addSubview:loadingView.progress];
    
    loadingView.pmProgress.progressValue = 0;
    loadingView.pmProgress.prevProgressValue = 0;
    [loadingView.progress setProgress:0];
    
    //Support scroll views
    if ([(UIView*)parentView isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scrollView = (UIScrollView*)parentView;
        
        CGPoint center = scrollView.contentOffset;
        
        center.x = center.x + 160;
        center.y = center.y + 220;
        [loadingView setCenter:center];
    }
    else
    {
        [loadingView setCenter:((UIView*)parentView).center];
    }
    
    NSMethodSignature *signature = [target methodSignatureForSelector:method];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:target];
    [invocation setSelector:method];
    
    if (nil != parentView)
    {
        static NSInteger requestId = 1;
        
        //Store the request id
        NSNumber *nsRequestId = [[NSNumber numberWithInt:requestId] retain];
        [invocation setArgument:&nsRequestId atIndex:2];
        [PMLoadingView setProgressForRequest:loadingView.pmProgress :requestId];
        requestId++;
        
        va_list args;
        va_start(args, parentView);
        
        id value;
        NSInteger argCount = [signature numberOfArguments] - 3;
        
        for (int argIndex = 0; argIndex < argCount; argIndex++)
        {
            value = va_arg(args, id);
            [invocation setArgument:&value atIndex:argIndex+3];
        }
        
        va_end(args);
    }
    
    //Set the details for the loading view
    [loadingView setLoadingDetails:details];
    
    //Add the loading view to the parent view
    [parentView addSubview:loadingView];
    
    //Create invoke data
    InvokeData *invokeData = [InvokeData alloc];
    invokeData.invocation = invocation;    
    invokeData.loadingView = loadingView;
    
    [loadingView performSelectorInBackground:@selector(execute:) withObject:invokeData];
    //[PMOperationQueue performHighPrioritySelector:loadingView :@selector(execute:), invokeData];
}

+(void)invokeFinished
{

}

-(void)execute:(InvokeData*)invokeData
{
    //Invoke the call
    [invokeData.invocation invoke];
    
    //Signal the main thread when done
    [invokeData.loadingView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
    
    [invokeData.invocation release];
    [invokeData release];
}


@end
