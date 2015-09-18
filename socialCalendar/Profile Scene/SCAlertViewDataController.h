//
//  SCAlertViewDataController.h
//  socialCalendar
//
//  Created by Yifan Xiao on 7/19/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "profileViewController.h"

@interface SCAlertViewDataController : NSObject

- (NSString *)setTitleWithRowType:(SCUserDetailModuleType)rowType;
- (NSString *)setSubtitleWithRowType:(SCUserDetailModuleType)rowType;
- (NSString *)setPlaceholderWithRowType:(SCUserDetailModuleType)rowType;
- (void)updateUserInfoInRow:(SCUserDetailModuleType)rowType withText:(NSString*)text ToCompletion:(void (^)(BOOL finished))completion;

@end
