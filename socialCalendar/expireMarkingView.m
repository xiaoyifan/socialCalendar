//
//  expireMarkingView.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/4/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "expireMarkingView.h"

@implementation expireMarkingView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]; // NEW
    CGRect paperRect = self.bounds;
    CGRect strokeRect = CGRectInset(paperRect, 5.0, 5.0);
    CGContextSetStrokeColorWithColor(context, redColor.CGColor);
    CGContextSetLineWidth(context, 5.0);
    CGContextStrokeRect(context, strokeRect);
    
}

@end
