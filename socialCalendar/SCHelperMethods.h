//
//  SCHelperMethods.h
//  socialCalendar
//
//  Created by Yifan Xiao on 7/26/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCHelperMethods : NSObject

/**
 *  Open iOS native settings.
 */
+ (void)openSettings;

/**
 *  Indicates if the app is registered from remote notifications.
 *
 *  @return YES if the app is registered. NO if not.
 */
+ (BOOL)isRegisteredFromRemoteNotifications;

@end
