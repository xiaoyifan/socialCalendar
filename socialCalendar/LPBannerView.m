//
//  LPBannerView.m
//  LillyPulitzer
//
//  Created by Thibault Klein on 4/16/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "LPBannerView.h"
#import "UIView+LoadNib.h"

@interface LPBannerView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (assign, nonatomic) BOOL visible;

@end

@implementation LPBannerView

#pragma mark - Init Methods

+ (instancetype)sharedInstance
{
    static LPBannerView *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        self = [UIView loadNibNamed:@"LPBannerView" ofClass:[LPBannerView class] owner:self];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissButtonTapped:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (CGRect)originalFrame
{
    return CGRectMake( 0, 0, CGRectGetWidth(self.frame), -CGRectGetHeight(self.frame) );
}

#pragma mark - Public Methods

+ (void)showMessage:(NSString *)message inViewController:(UIViewController *)viewController
{
    [[[self class] sharedInstance] showMessage:message inView:viewController.view andBannerView:[self sharedInstance]];
}

+ (void)showMessage:(NSString *)message
{
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    [[[self class] sharedInstance] showMessage:message inView:currentWindow andBannerView:[LPBannerView sharedInstance]];
}

+ (void)hideBannerWithAnimation:(BOOL)animated
{
    [[[self class] sharedInstance] hideWithDuration:animated ? 0.5 : 0.0f];
}

+ (void)hideBanner
{
    [self hideBannerWithAnimation:YES];
}

#pragma mark - Private Methods

- (void)showMessage:(NSString *)message inView:(UIView *)view andBannerView:(LPBannerView *)bannerView
{
    self.visible = YES;
    bannerView.titleLabel.text = message;
    [bannerView setNeedsLayout];
    [bannerView layoutIfNeeded];

    // Using auto layout to have the dynamic height of the banner label
    CGFloat bannerHeight = [bannerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    bannerView.frame = CGRectMake(0.0f, -bannerHeight, CGRectGetWidth(view.frame), bannerHeight);
    [view addSubview:bannerView];

    [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations: ^{
        bannerView.frame = CGRectMake( 0.0f, 0.0f, CGRectGetWidth(view.frame), CGRectGetHeight(bannerView.frame) );
    } completion:nil];
}

- (void)hideWithDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations: ^{
        self.frame = [self originalFrame];
    } completion: ^(BOOL finished) {
        self.visible = NO;
        [self removeFromSuperview];
    }];
}

#pragma mark - Action Methods

- (IBAction)dismissButtonTapped:(id)sender
{
    [self hideWithDuration:0.5];
    [self bannerViewDidClose];
}

#pragma mark - Delegate Methods

- (void)bannerViewDidClose
{
    if ([self.delegate respondsToSelector:@selector(bannerViewDidClose)]) {
        [self.delegate bannerViewDidClose];
    }
}

@end
