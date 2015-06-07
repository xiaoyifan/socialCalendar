//
//  FacebookStyleBar.h
//  socialCalendar
//
//  Created by Yifan Xiao on 6/4/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "BLKFlexibleHeightBar.h"


@protocol flexibleHeightBarDelegate

- (void)friendButtonPressed;

- (void)requestButtonPressed;

@end



@interface FacebookStyleBar : BLKFlexibleHeightBar

@property UIButton *friendButton;

@property UIButton *requestButton;

@property UIView *friendIndicatorView;

@property UIView *requestIndicatorView;

@property (nonatomic, assign) id <flexibleHeightBarDelegate> delegate;


@end
