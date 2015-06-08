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

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSDate *time;
@property (strong,nonatomic) NSDate *reminderDate;
@property (strong,nonatomic) CLLocation *location;
@property (strong,nonatomic) NSString *locationDescription;
@property (strong,nonatomic) NSString *eventNote;

@property (strong,nonatomic) NSArray *group;

@end
