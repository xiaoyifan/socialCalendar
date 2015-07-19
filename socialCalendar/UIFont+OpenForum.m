//
//  UIFont+OpenForum.m
//  AMEX OPEN Forum
//
//  Created by Jonathan on 5/11/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "UIFont+OpenForum.h"

@implementation UIFont (OpenForum)

#pragma mark - UIFont

+ (UIFont *)bentonSansExtraLightWithSize:(CGFloat)textSize
{
    return [UIFont fontWithName:@"BentonSans-ExtraLight" size:textSize];
}

+ (UIFont *)bentonSansLightWithSize:(CGFloat)textSize
{
    return [UIFont fontWithName:@"BentonSans-Light" size:textSize];
}

+ (UIFont *)bentonSansMediumWithSize:(CGFloat)textSize
{
    return [UIFont fontWithName:@"BentonSans-Medium" size:textSize];
}

+ (UIFont *)bentonSansRegularWithSize:(CGFloat)textSize
{
    return [UIFont fontWithName:@"BentonSans-Regular" size:textSize];
}

+ (UIFont *)tisaOTBoldWithSize:(CGFloat)textSize
{
    return [UIFont fontWithName:@"TisaOT-Bold" size:textSize];
}

+ (UIFont *)tisaOTBoldltaWithSize:(CGFloat)textSize
{
    return [UIFont fontWithName:@"TisaOT-Boldlta" size:textSize];
}

+ (UIFont *)tisaOTMediWithSize:(CGFloat)textSize
{
    return [UIFont fontWithName:@"TisaOT-Medi" size:textSize];
}

@end
