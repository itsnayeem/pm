//
//  PMNotificationData.h
//  PlateMe
//
//  Created by Kevin Calcote on 4/5/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMNotificationData : NSObject
{
    NSString *notificationId;
    NSString *accountId;
    NSString *message;
    NSString *type;
    NSString *targetId;
    NSString *unread;
    NSString *show;
    NSString *timestamp;
}

@property (retain) NSString *notificationId;
@property (retain) NSString *accountId;
@property (retain) NSString *message;
@property (retain) NSString *type;
@property (retain) NSString *targetId;
@property (retain) NSString *unread;
@property (retain) NSString *show;
@property (retain) NSString *timestamp;

@end
