//
//  SCEventNameTableViewCell.h
//  socialCalendar
//
//  Created by Yifan Xiao on 6/30/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"

static NSString *const eventNameTableViewCellIdentifier = @"eventNameTableViewCell";

@class eventObject;

@interface SCEventNameTableViewCell : UITableViewCell

/**
 *  Setup the store name cell.
 *
 *  @param store The store informations.
 */
- (void)setupWithEvent:(eventObject *)event;

@end
