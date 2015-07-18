//
//  SCProfileEditableCell.h
//  socialCalendar
//
//  Created by Yifan Xiao on 7/18/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "profileViewController.h"

@interface SCProfileEditableCell : UITableViewCell


-(void)setupWithUser:(PFUser *)user withRowType:(SCUserDetailModuleType)rowtype;


@end
