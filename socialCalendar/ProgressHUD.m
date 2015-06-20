//
//  LPProgressHUD.m
//  LillyPulitzer
//
//  Created by Thomas on 4/22/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "ProgressHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>


@implementation ProgressHUD

+ (void)showHUDAddedTo:(UIView *)view animated:(BOOL)animated
{
    [MBProgressHUD showHUDAddedTo:view animated:animated];

    MBProgressHUD *HUD = [MBProgressHUD HUDForView:view];
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    HUD.color = [UIColor whiteColor];
}

+ (void)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:view animated:animated];
}

+ (void)hideHUDForView:(UIView *)view animated:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:view animated:animated];
}

+ (void)shouldShowNetworkActivityIndicator:(BOOL)shouldShow
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:shouldShow];
}

@end
