//
//  SCHelperMethods.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/26/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "SCHelperMethods.h"

@implementation SCHelperMethods


+ (void)openSettings
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

+ (BOOL)isRegisteredFromRemoteNotifications
{
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    return settings.types != UIUserNotificationTypeNone;
}

@end
