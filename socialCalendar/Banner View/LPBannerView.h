//
//  LPBannerView.h
//  LillyPulitzer
//
//  Created by Thibault Klein on 4/16/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LPBannerViewDelegate <NSObject>

/**
 *  Indicates when user is tapping on close button.
 */
- (void)bannerViewDidClose;

@end

@interface LPBannerView : UIView

/**
 *  Optional. Delegate who will implement banner view delegate methods.
 */
@property (weak, nonatomic) id <LPBannerViewDelegate> delegate;

/**
 *  Boolean to know if the banner view is visible or not.
 */
@property(nonatomic, readonly, getter=isVisible) BOOL visible;

/**
 *  Singleton shared instance method.
 *
 *  @return A new Banner View instance at the first call, the existing instance otherwise.
 */
+ (instancetype)sharedInstance;

/**
 *  Show Banner message.
 *
 *  @param message          Message to show.
 *  @param viewController   View Controller to show on.
 */
+ (void)showMessage:(NSString *)message inViewController:(UIViewController *)viewController;

/**
 *  Show Banner message in Window. (Above all UI)
 *
 *  @param message        Message to show.
 */
+ (void)showMessage:(NSString *)message;

/**
 *  Hides the banner with animation.
 *
 */
+ (void)hideBanner;

/**
 *  Hide the banner with optional animation.
 *
 *  @param animated     The animation option, YES will animate the banner.
 */
+ (void)hideBannerWithAnimation:(BOOL)animated;

@end
