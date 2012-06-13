//
//  PMOperationQueue.h
//  PlateMe
//
//  Created by Kevin Calcote on 4/8/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMOperation : NSInvocationOperation

@end

@interface PMOperationQueue : NSOperationQueue
{
    
}

+(NSOperationQueue*) operationQueue;
+(id)performInvokeWithPriority:(NSInvocation*)invocation :(NSOperationQueuePriority)priority;
+(id) performHighPrioritySelector:(id)target :(SEL)selector, ...;
+(id) performNormalPrioritySelector:(id)target :(SEL)selector, ...;
+(id) performLowPrioritySelector:(id)target :(SEL)selector, ...;
+(NSInvocation*) argListToInvocation:(id)target :(SEL)selector :(va_list) args;

@end
