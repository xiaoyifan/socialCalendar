//
//  SCEventAddressTableViewCell.h
//  socialCalendar
//
//  Created by Yifan Xiao on 6/30/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventDetailDataController.h"

static NSString *const eventAddressTableViewCellIdentifier = @"eventAddressTableViewCell";

@class eventObject;

@interface SCEventAddressTableViewCell : UITableViewCell

/**
 *  Setup the store info module.
 *
 *  @param store The store to display.
 *  @param type  The row type.
 */
- (void)setupWithEvent:(eventObject *)event withRowType:(SCEventDetailModuleType)rowType;

@end
