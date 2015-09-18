//
//  UITabBarController+TabBarVisibility.h
//  socialCalendar
//
//  Created by Yifan Xiao on 7/25/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (TabBarVisibility)

/**
 *  Method to hide the TabBar with or without animation.
 *
 *  @param animated YES for animation, No for without animation.
 */
- (void)hideTabbarAnimated:(BOOL)animated;

/**
 *  Show the TabBar with or without animation.
 *
 *  @param animated YES for animation, No for without animation.
 */
- (void)showTabbarAnimated:(BOOL)animated;

@end
