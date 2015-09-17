//
//  SCEventHourCell.h
//  socialCalendar
//
//  Created by Yifan Xiao on 6/28/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//


static NSString *const kEventHourCellReuseIdentifier = @"SCEventHourCell";

@interface SCEventHourCell : UITableViewCell

/**
 *  Setup the Store Hours cell.
 *
 *  @param storeHours   The Store Hours to display.
 */
- (void)setupCellWithTime:(NSDate *)time withTitle:(NSString*)title;

@end
