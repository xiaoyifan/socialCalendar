//
//  FacebookStyleBar.m
//  socialCalendar
//
//  Created by Yifan Xiao on 6/4/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "FacebookStyleBar.h"

@implementation FacebookStyleBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configureBar];
    }

    return self;
}

- (void)configureBar
{
    // Configure bar appearence
    self.maximumBarHeight = 105.0;
    self.minimumBarHeight = 20.0;
    self.backgroundColor = [UIColor colorWithRed:0.31 green:0.42 blue:0.64 alpha:1];
    self.clipsToBounds = YES;


    // Add blue bar view
    UIView *blueBarView = [[UIView alloc] init];
    blueBarView.backgroundColor = self.backgroundColor;

    BLKFlexibleHeightBarSubviewLayoutAttributes *initialBlueBarLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] init];
    initialBlueBarLayoutAttributes.frame = CGRectMake(0.0, 25.0, self.frame.size.width, 40.0);
    initialBlueBarLayoutAttributes.zIndex = 1023;
    [blueBarView addLayoutAttributes:initialBlueBarLayoutAttributes forProgress:0.0];
    [blueBarView addLayoutAttributes:initialBlueBarLayoutAttributes forProgress:40.0 / (105.0 - 20.0)];

    BLKFlexibleHeightBarSubviewLayoutAttributes *finalBlueBarLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialBlueBarLayoutAttributes];
    finalBlueBarLayoutAttributes.transform = CGAffineTransformMakeTranslation(0.0, -40.0);
    [blueBarView addLayoutAttributes:finalBlueBarLayoutAttributes forProgress:1.0];

    [self addSubview:blueBarView];


    // Add search field and close button
    self.searchField = [[UITextField alloc] init];
    self.searchField.layer.cornerRadius = 5.0;
    self.searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search" attributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:0.55 green:0.6 blue:0.75 alpha:1] }];
    self.searchField.backgroundColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.46 alpha:1];
    self.searchField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);

    BLKFlexibleHeightBarSubviewLayoutAttributes *initialSearchFieldLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] init];
    initialSearchFieldLayoutAttributes.frame = CGRectMake(8.0, 25.0, initialBlueBarLayoutAttributes.size.width * 0.85, initialBlueBarLayoutAttributes.size.height - 8.0);
    initialSearchFieldLayoutAttributes.zIndex = 1024;
    [self.searchField addLayoutAttributes:initialSearchFieldLayoutAttributes forProgress:0.0];
    [self.searchField addLayoutAttributes:initialSearchFieldLayoutAttributes forProgress:40.0 / (105.0 - 20.0)];

    BLKFlexibleHeightBarSubviewLayoutAttributes *finalSearchFieldLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialSearchFieldLayoutAttributes];
    finalSearchFieldLayoutAttributes.transform = CGAffineTransformMakeTranslation( 0.0, -0.3 * (105 - 20) );
    finalSearchFieldLayoutAttributes.alpha = 0.0;

    [self.searchField addLayoutAttributes:finalSearchFieldLayoutAttributes forProgress:0.8];
    [self.searchField addLayoutAttributes:finalSearchFieldLayoutAttributes forProgress:1.0];

    [self addSubview:self.searchField];


    // Add white bar view
    UIView *whiteBarView = [[UIView alloc] init];
    whiteBarView.backgroundColor = [UIColor whiteColor];

    BLKFlexibleHeightBarSubviewLayoutAttributes *initialWhiteBarLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] init];
    initialWhiteBarLayoutAttributes.frame = CGRectMake(0.0, 65.0, self.frame.size.width, 40.0);
    [whiteBarView addLayoutAttributes:initialWhiteBarLayoutAttributes forProgress:0.0];

    BLKFlexibleHeightBarSubviewLayoutAttributes *finalWhiteBarLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialWhiteBarLayoutAttributes];
    finalWhiteBarLayoutAttributes.transform = CGAffineTransformMakeTranslation(0.0, -40.0);
    [whiteBarView addLayoutAttributes:finalWhiteBarLayoutAttributes forProgress:40.0 / (105.0 - 20.0)];

    [self addSubview:whiteBarView];

    // Configure white bar view subviews
    UIView *bottomBorderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, initialWhiteBarLayoutAttributes.size.height - 0.5, initialWhiteBarLayoutAttributes.size.width, 0.5)];
    bottomBorderView.backgroundColor = [UIColor colorWithRed:0.75 green:0.76 blue:0.78 alpha:1];
    [whiteBarView addSubview:bottomBorderView];


    UIView *middleIntervalDividerView = [[UIView alloc] initWithFrame:CGRectMake(initialWhiteBarLayoutAttributes.size.width * 0.5, initialWhiteBarLayoutAttributes.size.height * 0.1, 0.5, initialWhiteBarLayoutAttributes.size.height * 0.8)];
    middleIntervalDividerView.backgroundColor = [UIColor colorWithRed:0.85 green:0.86 blue:0.88 alpha:1];
    [whiteBarView addSubview:middleIntervalDividerView];

    self.friendButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, whiteBarView.frame.origin.y, initialWhiteBarLayoutAttributes.size.width * 0.5, initialWhiteBarLayoutAttributes.size.height * 0.9)];

    self.friendButton.tintColor = [UIColor darkGrayColor];

    [self.friendButton setTitle:@"friends" forState:UIControlStateNormal];
    [self.friendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.friendButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.friendButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.friendButton addTarget:self action:@selector(friendButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    [whiteBarView addSubview:self.friendButton];


    self.friendIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.friendButton.frame.origin.y + self.friendButton.frame.size.height, self.friendButton.frame.size.width, initialWhiteBarLayoutAttributes.size.height * 0.1)];

    [whiteBarView addSubview:self.friendIndicatorView];

    self.requestButton = [[UIButton alloc] initWithFrame:CGRectMake(initialWhiteBarLayoutAttributes.size.width * 0.5, whiteBarView.frame.origin.y, initialWhiteBarLayoutAttributes.size.width * 0.5, initialWhiteBarLayoutAttributes.size.height * 0.9)];
    self.requestButton.tintColor = [UIColor darkGrayColor];

    [self.requestButton setTitle:@"requests" forState:UIControlStateNormal];
    [self.requestButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.requestButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.requestButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.requestButton addTarget:self action:@selector(requestButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    [whiteBarView addSubview:self.requestButton];


    self.requestIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(self.requestButton.frame.origin.x, self.requestButton.frame.origin.y + self.requestButton.frame.size.height, self.requestButton.frame.size.width, initialWhiteBarLayoutAttributes.size.height * 0.1)];

    [whiteBarView addSubview:self.requestIndicatorView];
}

- (void)friendButtonTapped:(id)sender
{
    [self.delegate friendButtonPressed];
}

- (void)requestButtonTapped:(id)sender
{
    [self.delegate requestButtonPressed];
}

@end
