//
//  eventObject.h
//  socialCalendar
//
//  Created by Yifan Xiao on 5/26/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface eventObject : NSObject<NSCoding>

/**
 *  Event title.
 */
@property (strong,nonatomic) NSString *title;

/**
 *  Event time.
 */
@property (strong,nonatomic) NSDate *time;

/**
 *  The date to be reminded.
 */
@property (strong,nonatomic) NSDate *reminderDate;

/**
 *  The location of the event.
 */
@property (strong,nonatomic) CLLocation *location;

/**
 *  The location description text.
 */
@property (strong,nonatomic) NSString *locationDescription;

/**
 *  The note text.
 */
@property (strong,nonatomic) NSString *eventNote;

/**
 *  The friend group.
 */
@property (strong,nonatomic) NSArray *group;

/**
 *  The event Object ID.
 */
@property (strong,nonatomic) NSString *objectId;

/**
 *  The mark to distinguish the event from public to private.
 */
@property (assign,nonatomic) BOOL isInternalEvent;

@end
