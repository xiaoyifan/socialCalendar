//
//  addEventTableViewController.h
//  socialCalendar
//
//  Created by Yifan Xiao on 5/25/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addEventTableViewController : UITableViewController

@property (strong, nonatomic) CLLocation *itemLocation;

@property (strong, nonatomic) NSDate *eventDate;

@property (strong, nonatomic) NSDate *remindDate;

@property eventObject *object;

@end
