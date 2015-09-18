//
//  FacebookStyleBar.h
//  socialCalendar
//
//  Created by Yifan Xiao on 6/4/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "BLKFlexibleHeightBar.h"


@protocol flexibleHeightBarDelegate

/**
 *  The method to be triggered when the friend button is pressed.
 */
- (void)friendButtonPressed;

/**
 *  The method to be triggered when the requesr button is pressed. 
 */
- (void)requestButtonPressed;

@end



@interface FacebookStyleBar : BLKFlexibleHeightBar

@property UIButton *friendButton;

@property UIButton *requestButton;

@property UIView *friendIndicatorView;

@property UIView *requestIndicatorView;

@property UITextField *searchField;

@property (nonatomic, assign) id <flexibleHeightBarDelegate> delegate;


@end
