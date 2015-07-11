//
//  SCEventAddressTableViewCell.m
//  socialCalendar
//
//  Created by Yifan Xiao on 6/30/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "SCEventAddressTableViewCell.h"
#import "UIColor+CustomColors.h"

@interface SCEventAddressTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation SCEventAddressTableViewCell

- (void)setupWithEvent:(eventObject *)event
{
        self.titleLabel.text = @"ADDRESS";
        self.titleLabel.textColor = [UIColor customBlueColor];
        self.descriptionLabel.text = event.locationDescription;
}

@end
