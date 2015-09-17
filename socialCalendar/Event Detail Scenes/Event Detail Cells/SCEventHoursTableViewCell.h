//
//  SCEventHoursTableViewCell.h
//  socialCalendar
//
//  Created by Yifan Xiao on 6/30/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kEventHoursTableViewCellIdentifier = @"SCEventHoursCellIdentifier";

@interface SCEventHoursTableViewCell : UITableViewCell

/**
 *  Setup the store hours module.
 *
 *  @param store The store to display.
 */
- (void)setupWithEvent:(eventObject *)event;

@end
