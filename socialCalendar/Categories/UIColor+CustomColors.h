//
//  UIColor+CustomColors.h
//  Popping
//
//  Created by André Schneider on 25.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CustomColors)

/**
 *  Get the custom gray color.
 *
 *  @return The custom gray color
 */
+ (UIColor *)customGrayColor;

/**
 *  Get the custom red color.
 *
 *  @return The custom red color.
 */
+ (UIColor *)customRedColor;

/**
 *  Get the custom yellow color.
 *
 *  @return The custom yellow color.
 */
+ (UIColor *)customYellowColor;

/**
 *  Get the custom green color.
 *
 *  @return The custom green color.
 */
+ (UIColor *)customGreenColor;

/**
 *  Get the custom blue color.
 *
 *  @return The custom blue color.
 */
+ (UIColor *)customBlueColor;

/**
 *  Get the random color.
 *
 *  @return Random selected color.
 */
+ (UIColor *)randomColor;


+ (UIColor *)disabledTextColor;

@end
