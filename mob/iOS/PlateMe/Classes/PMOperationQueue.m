//
//  PMOperationQueue.m
//  PlateMe
//
//  Created by Kevin Calcote on 4/8/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PMOperationQueue.h"

@implementation PMOperation

- (BOOL)isConcurrent
{
    return YES;
}

@end

@implementation PMOperationQueue

+(NSOperationQueue*) operationQueue
{
    static NSOperationQueue *operationQueue = nil;
    
    if (nil == operationQueue)
    {
        operationQueue = [[NSOperationQueue alloc] init];
    }
    
    return operationQueue;
}

+(id)performInvokeWithPriority:(NSInvocation*)invocation :(NSOperationQueuePriority)priority
{
    PMOperation *operation = [[PMOperation alloc] initWithInvocation:invocation];
    
    //Set the priority
    operation.queuePriority = priority;
    
    switch (priority) 
    {
        case NSOperationQueuePriorityLow:
            operation.threadPriority = 0.33;
            break;
        case NSOperationQueuePriorityNormal:
            operation.threadPriority = 0.66;
            break;
        case NSOperationQueuePriorityHigh:
            operation.threadPriority = 1.0;
            break;
        default:
            break;
    }
    
    [[PMOperationQueue operationQueue] addOperation:operation];
    
    [operation release];
    
    return nil;    
}

+(NSInvocation*) argListToInvocation:(id)target :(SEL)selector :(va_list) args
{
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:target];
    [invocation setSelector:selector];
    
    NSInteger argCount = [signature numberOfArguments] - 2;
    
    for(int argIndex = 0; argIndex < argCount; argIndex++)
    {
        id value = va_arg(args, id);
        [invocation setArgument:&value atIndex:argIndex+2];
    }
    
    return invocation;
}

+(id) performHighPrioritySelector:(id)target :(SEL)selector, ...
{
    va_list args;
    va_start(args, selector);
    
    NSInvocation *invocation = [PMOperationQueue argListToInvocation:target :selector :args];
    
    [PMOperationQueue performInvokeWithPriority:invocation :NSOperationQueuePriorityHigh];
    
    va_end(args);
    
    return nil;
}

+(id) performNormalPrioritySelector:(id)target :(SEL)selector, ...
{
    va_list args;
    va_start(args, selector);
    
    NSInvocation *invocation = [PMOperationQueue argListToInvocation:target :selector :args];
    
    [PMOperationQueue performInvokeWithPriority:invocation :NSOperationQueuePriorityNormal];  
    
    va_end(args);
    
    return nil;
}

+(id) performLowPrioritySelector:(id)target :(SEL)selector, ...
{
    va_list args;
    va_start(args, selector);
    
    NSInvocation *invocation = [PMOperationQueue argListToInvocation:target :selector :args];
    
    [PMOperationQueue performInvokeWithPriority:invocation :NSOperationQueuePriorityLow]; 
    
    va_end(args);
    
    return nil;
}

@end


