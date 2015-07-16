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

- (void)setupWithEvent:(eventObject *)event  withRowType:(SCEventDetailModuleType)rowType
{
    if (rowType == SCEventDetailModuleTypeNote) {
        self.titleLabel.text = @"NOTE";
        self.descriptionLabel.text = event.eventNote;
    } else if (rowType == SCEventDetailModuleTypeAddress)    {
        self.titleLabel.text = @"ADDRESS";
        if (event.locationDescription) {
            self.descriptionLabel.text = event.locationDescription;
        }
        else{
            self.descriptionLabel.text = kEventNoAddressText;
        }
    }
    self.titleLabel.textColor = [UIColor customBlueColor];
}

@end
