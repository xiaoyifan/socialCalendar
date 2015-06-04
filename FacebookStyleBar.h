//
//  FacebookStyleBar.h
//  BLKFlexibleHeightBar Demo
//
//  Created by Bryan Keller on 3/7/15.
//  Copyright (c) 2015 Bryan Keller. All rights reserved.
//

#import "BLKFlexibleHeightBar.h"


@protocol flexibleHeightBarDelegate

- (void)friendButtonPressed;

- (void)requestButtonPressed;

@end



@interface FacebookStyleBar : BLKFlexibleHeightBar

@property UIButton *friendButton;

@property UIButton *requestButton;

@property (nonatomic, assign) id <flexibleHeightBarDelegate> delegate;


@end
