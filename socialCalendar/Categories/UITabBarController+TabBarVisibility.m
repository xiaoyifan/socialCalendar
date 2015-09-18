//
//  UITabBarController+TabBarVisibility.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/25/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "UITabBarController+TabBarVisibility.h"

@implementation UITabBarController (TabBarVisibility)

- (void)hideTabbarAnimated:(BOOL)animated
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    float fHeight = screenRect.size.height;

    void (^block)(void) = ^() {
        for (UIView *view in self.view.subviews) {
            if (view == self.tabBar) {
                [view setFrame:CGRectMake(view.frame.origin.x, fHeight, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, fHeight)];
                view.backgroundColor = [UIColor blackColor];
            }
        }
    };

    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        block();
        [UIView commitAnimations];
    } else {
        block();
    }
}

- (void)showTabbarAnimated:(BOOL)animated
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float fHeight = screenRect.size.height - 49.0;

    void (^block)(void) = ^() {
        for (UIView *view in self.view.subviews) {
            if (view == self.tabBar) {
                [view setFrame:CGRectMake(view.frame.origin.x, fHeight, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, fHeight)];
            }
        }
    };

    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        block();
        [UIView commitAnimations];
    } else {
        block();
    }
}

@end
