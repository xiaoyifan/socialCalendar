//
//  LPProgressHUD.h
//  LillyPulitzer
//
//  Created by Thomas on 4/22/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Custom in-view loader using MBProgressHUD implementation and adding custom design.
 */
@interface ProgressHUD : NSObject

/**
 *  Show a in-page loader to a specific view, with or without animation.
 *
 *  @param view     The view to show the loader.
 *  @param animated If set to YES the HUD will appear using the current animationType. If set to NO the HUD will not use animations while appearing.
 */
+ (void)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;

/**
 *  Hide all the loaders inside a specific view, with or without animations.
 *
 *  @param view     The view to hide all loaders.
 *  @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use animations while disappearing.
 */
+ (void)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated;

/**
 *  Hide the first top loader inside a specific view and hide it, with or without animations.
 *
 *  @param view     The view to hide the first top loader.
 *  @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use animations while disappearing.
 */
+ (void)hideHUDForView:(UIView *)view animated:(BOOL)animated;

/**
 *  Show or hide the network activity indicator visible in the status bar next to the cellular data/ WiFi icon.
 *
 *  @param shouldShow If set to YES it will show the network activity. If set to NO it will hide the network activity.
 */
+ (void)shouldShowNetworkActivityIndicator:(BOOL)shouldShow;

@end
