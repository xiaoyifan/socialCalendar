//
//  UIColor+CustomColors.m
//  Popping
//
//  Created by André Schneider on 25.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

+ (UIColor *)customGrayColor
{
    return [self colorWithRed:84 green:84 blue:84];
}

+ (UIColor *)customRedColor
{
    return [self colorWithRed:231 green:76 blue:60];
}

+ (UIColor *)customYellowColor
{
    return [self colorWithRed:241 green:196 blue:15];
}

+ (UIColor *)customGreenColor
{
    return [self colorWithRed:46 green:204 blue:113];
}

+ (UIColor *)customBlueColor
{
    return [self colorWithRed:52 green:152 blue:219];
}

+ (UIColor *)disabledTextColor
{
    return [self colorWithRed:208 green:213 blue:214];
}

#pragma mark - Private class methods

+ (UIColor *)colorWithRed:(NSUInteger)red
                    green:(NSUInteger)green
                     blue:(NSUInteger)blue
{
    return [UIColor colorWithRed:(float)(red / 255.f)
                           green:(float)(green / 255.f)
                            blue:(float)(blue / 255.f)
                           alpha:1.f];
}

+ (UIColor *)randomColor
{
    NSArray *sliceColors = [NSArray arrayWithObjects:

                            [UIColor colorWithRed:121 / 255.0 green:134 / 255.0 blue:203 / 255.0 alpha:1], //5. indigo
                            [UIColor colorWithRed:174 / 255.0 green:213 / 255.0 blue:129 / 255.0 alpha:1], //14. light green
                            [UIColor colorWithRed:100 / 255.0 green:181 / 255.0 blue:246 / 255.0 alpha:1], //2. blue
                            [UIColor colorWithRed:220 / 255.0 green:231 / 255.0 blue:117 / 255.0 alpha:1], //8. lime
                            [UIColor colorWithRed:79 / 255.0 green:195 / 255.0 blue:247 / 255.0 alpha:1], //7. light blue
                            [UIColor colorWithRed:77 / 255.0 green:208 / 255.0 blue:225 / 255.0 alpha:1], //3. cyan
                            [UIColor colorWithRed:77 / 255.0 green:182 / 255.0 blue:172 / 255.0 alpha:1], //13. teal
                            [UIColor colorWithRed:129 / 255.0 green:199 / 255.0 blue:132 / 255.0 alpha:1], //9. green
                            [UIColor colorWithRed:255 / 255.0 green:241 / 255.0 blue:118 / 255.0 alpha:1], //16. yellow
                            [UIColor colorWithRed:255 / 255.0 green:213 / 255.0 blue:79 / 255.0 alpha:1], //12. amber
                            [UIColor colorWithRed:255 / 255.0 green:183 / 255.0 blue:77 / 255.0 alpha:1], //4. orange
                            [UIColor colorWithRed:255 / 255.0 green:138 / 255.0 blue:101 / 255.0 alpha:1], //10. deep orange
                            [UIColor colorWithRed:144 / 255.0 green:164 / 255.0 blue:174 / 255.0 alpha:1], //15. blue grey
                            [UIColor colorWithRed:229 / 255.0 green:155 / 255.0 blue:155 / 255.0 alpha:1], //6. red
                            [UIColor colorWithRed:240 / 255.0 green:98 / 255.0 blue:146 / 255.0 alpha:1], //1. pink
                            [UIColor colorWithRed:186 / 255.0 green:104 / 255.0 blue:200 / 255.0 alpha:1], //11. purple
                            nil];

    int rad = arc4random() % 16;
    return sliceColors[rad];
}

@end
