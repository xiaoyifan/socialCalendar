//
//  LPCollectionViewCell.m
//  LillyPulitzer
//
//  Created by Pavel Novik on 5/13/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "SCCollectionViewCell.h"
#import "UIColor+CustomColors.h"

static CGFloat const kDefaultBottomRowSeperatorBorderOriginX = 54.0f;

@interface SCCollectionViewCell ()

@property (strong, nonatomic) UIView *topFullWidthBorderView;
@property (strong, nonatomic) UIView *bottomFullWidthBorderView;
@property (strong, nonatomic) UIView *bottomRowSeperatorBorderView;

@property (assign, nonatomic) CGFloat bottomRowSeperatorOriginX;
@end

@implementation SCCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.bottomRowSeperatorOriginX = kDefaultBottomRowSeperatorBorderOriginX;
    self.clipsToBounds = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self initialize];
}

- (void)prepareForReuse
{
    self.showBottomRowSeperatorBorder = NO;
    self.showTopFullWidthBorder = NO;
    self.showBottomFullWidthBorder = NO;
    [super prepareForReuse];
}

#pragma mark - Public Methods

- (void)showBottomRowSeperatorBorderWithXOrigin:(CGFloat)xOrigin
{
    self.bottomRowSeperatorOriginX = xOrigin;
    self.showBottomRowSeperatorBorder = YES;
}

#pragma mark - Private Methods

- (void)initialize
{
    if (self.showTopFullWidthBorder) {
        self.topFullWidthBorderView.hidden = !self.showTopFullWidthBorder;
    }

    if (self.showBottomFullWidthBorder) {
        self.bottomFullWidthBorderView.hidden = !self.showBottomFullWidthBorder;
    }

    if (self.showBottomRowSeperatorBorder) {
        self.bottomRowSeperatorBorderView.hidden = !self.showBottomRowSeperatorBorder;
    }
}

#pragma mark - Setters Methods

- (void)setShowBottomRowSeperatorBorderr:(BOOL)showBottomRowSeperatorBorder
{
    _showBottomRowSeperatorBorder = showBottomRowSeperatorBorder;
    self.bottomRowSeperatorBorderView.hidden = !showBottomRowSeperatorBorder;
}

- (void)setShowBottomFullWidthBorder:(BOOL)showBottomFullWidthBorder
{
    _showBottomFullWidthBorder = showBottomFullWidthBorder;
    self.bottomFullWidthBorderView.hidden = !showBottomFullWidthBorder;
}

- (void)setShowTopFullWidthBorder:(BOOL)showTopFullWidthBorder
{
    _showTopFullWidthBorder = showTopFullWidthBorder;
    self.topFullWidthBorderView.hidden = !showTopFullWidthBorder;
}

#pragma mark - Getters Methods

- (UIView *)topFullWidthBorderView
{
    if (!_topFullWidthBorderView) {
        _topFullWidthBorderView = [UIView new];
        _topFullWidthBorderView.backgroundColor = [UIColor customBlueColor];
        [self addSubview:_topFullWidthBorderView];
        [self bringSubviewToFront:_topFullWidthBorderView];
    }
    _topFullWidthBorderView.frame = CGRectMake(0,
                                               0.5f,
                                               CGRectGetWidth(self.frame),
                                               1.0 / [UIScreen mainScreen].scale);
    return _topFullWidthBorderView;
}

- (UIView *)bottomRowSeperatorBorderView
{
    if (!_bottomRowSeperatorBorderView) {
        _bottomRowSeperatorBorderView = [UIView new];
        _bottomRowSeperatorBorderView.backgroundColor = [UIColor customGrayColor];
        [self addSubview:_bottomRowSeperatorBorderView];
        [self bringSubviewToFront:_bottomRowSeperatorBorderView];
    }
    _bottomRowSeperatorBorderView.frame = CGRectMake(self.bottomRowSeperatorOriginX,
                                                     CGRectGetHeight(self.frame) - 1.0 / [UIScreen mainScreen].scale,
                                                     CGRectGetWidth(self.frame),
                                                     1.0 / [UIScreen mainScreen].scale);
    return _bottomRowSeperatorBorderView;
}

- (UIView *)bottomFullWidthBorderView
{
    if (!_bottomFullWidthBorderView) {
        _bottomFullWidthBorderView = [UIView new];
        _bottomFullWidthBorderView.backgroundColor = [UIColor customBlueColor];
        [self addSubview:_bottomFullWidthBorderView];
        [self bringSubviewToFront:_bottomFullWidthBorderView];
    }
    _bottomFullWidthBorderView.frame = CGRectMake(0,CGRectGetHeight(self.frame) - 1.0 / [UIScreen mainScreen].scale ,CGRectGetWidth(self.frame),1.0 / [UIScreen mainScreen].scale);
    return _bottomFullWidthBorderView;
}

@end
