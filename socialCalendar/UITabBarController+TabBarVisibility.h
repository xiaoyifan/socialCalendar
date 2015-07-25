//
//  UITabBarController+TabBarVisibility.h
//  socialCalendar
//
//  Created by Yifan Xiao on 7/25/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (TabBarVisibility)

- (void)hideTabbarAnimated:(BOOL)animated;
- (void)showTabbarAnimated:(BOOL)animated;

@end
