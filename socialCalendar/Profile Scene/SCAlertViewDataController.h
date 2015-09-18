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

/**
 *  Set the title of the alert view by row type.
 *
 *  @param rowType The row type.
 *
 *  @return return the title text.
 */
- (NSString *)setTitleWithRowType:(SCUserDetailModuleType)rowType;

/**
 *  Set the subtitle of the alert view by row type.
 *
 *  @param rowType The row type.
 *
 *  @return return the subtitle text.
 */
- (NSString *)setSubtitleWithRowType:(SCUserDetailModuleType)rowType;

/**
 *  Set the place holder text of the alert view by row type.
 *
 *  @param rowType The row type.
 *
 *  @return return the placeholder text.
 */
- (NSString *)setPlaceholderWithRowType:(SCUserDetailModuleType)rowType;

/**
 *  Generic method for updating the related info.
 *
 *  @param rowType    The row type.
 *  @param text       The text to be updated.
 *  @param completion The completion block after the content is updated. 
 */
- (void)updateUserInfoInRow:(SCUserDetailModuleType)rowType withText:(NSString*)text ToCompletion:(void (^)(BOOL finished))completion;

@end
