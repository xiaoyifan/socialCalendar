//
//  SCEventInfoViewController.h
//  socialCalendar
//
//  Created by Yifan Xiao on 7/6/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCEventInfoViewController : UIViewController

/**
 *  Set the detail View Controller with specified event
 *
 *  @param eventObj The event object.
 */
- (void)setupWithEvent:(eventObject *)eventObj;


@end
