//
//  UIView+LoadNib.m
//  LillyPulitzer
//
//  Created by Thibault Klein on 4/16/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "UIView+LoadNib.h"

@implementation UIView (LoadNib)

+ (id)loadNibNamed:(NSString *)nibName ofClass:(Class)objClass owner:(id)owner
{
    if (nibName && objClass) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];

        for (id currentObject in objects) {
            if ([currentObject isKindOfClass:objClass]) {
                return currentObject;
            }
        }
    }
    return nil;
}

@end
