//
//  SCProfileInfoCell.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/18/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "SCProfileInfoCell.h"

@implementation SCProfileInfoCell

- (void)setupWithUser:(User *)user withRowType:(SCUserDetailModuleType)rowtype
{
    
    switch (rowtype) {
        case SCUserDetailModuleTypeNickName:
        {
            self.titleLabel.text = @"NAME";
            self.contentLabel.text = user.username;
            break;
        }

        case SCUserDetailModuleTypeEmail:
        {
            self.titleLabel.text = @"EMAIL";
            self.contentLabel.text = user.email;
            break;
        }

        case SCUserDetailModuleTypeRegion:
        {
            self.titleLabel.text = @"REGION";
            if (user.location) {
                self.contentLabel.text = user.location;
            } else {
                self.contentLabel.text = @"not available";
            }
            break;
        }

        case SCUserDetailModuleTypeGender:
        {
            self.titleLabel.text = @"GENDER";
            if (user.gender) {
                self.contentLabel.text = user.gender;
            } else {
                self.contentLabel.text = @"not provided";
            }
            break;
        }

        case SCUserDetailModuleTypeWhatsUp:
        {
            self.titleLabel.text = @"WHAT'S UP";
            if (user.whatsup) {
                self.contentLabel.text = user.whatsup;
            } else {
                self.contentLabel.text = @"not provided";
            }
            break;
        }

        default:
            break;
    }
}

@end
