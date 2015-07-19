//
//  SCProfileInfoCell.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/18/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "SCProfileInfoCell.h"
#import "UIFont+OpenForum.h"

@implementation SCProfileInfoCell

-(void)setupWithUser:(PFUser *)user withRowType:(SCUserDetailModuleType)rowtype{
    
    [self.contentLabel setFont:[UIFont bentonSansExtraLightWithSize:20]];
    
    switch (rowtype) {
        case SCUserDetailModuleTypeNickName:
            self.titleLabel.text = @"NAME";
            self.contentLabel.text = user.username;
            break;
        case SCUserDetailModuleTypeEmail:
            self.titleLabel.text = @"EMAIL";
            self.contentLabel.text = user.email;
            
            break;
        case SCUserDetailModuleTypeRegion:
            self.titleLabel.text = @"REGION";
//            if (user[@"region"]) {
//               self.contentLabel.text = user[@"region"];
//            }
//            else{
                self.contentLabel.text = @"not available";
            //}
            break;
        case SCUserDetailModuleTypeGender:
            self.titleLabel.text = @"GENDER";
            if (user[@"gender"]) {
                self.contentLabel.text = user[@"gender"];
            }
            else{
            self.contentLabel.text = @"not provided";
            }
            break;
        case SCUserDetailModuleTypeWhatsUp:
            self.titleLabel.text = @"WHAT'S UP";
            if (user[@"whatsUp"]) {
                self.contentLabel.text = user[@"whatsUp"];
            }
            else{
                self.contentLabel.text = @"Only the strong survive";
            }
            break;
            
        case SCUserDetailModuleTypeEducation:
            self.titleLabel.text = @"EDUCATION";
            if (user[@"education"]) {
                self.contentLabel.text = user[@"education"];
            }
            else{
                self.contentLabel.text = @"not provided";
            }
            break;
            
        case SCUserDetailModuleTypeWork:
            self.titleLabel.text = @"WORK";
            if (user[@"work"]) {
                self.contentLabel.text = user[@"work"];
            }
            else{
                self.contentLabel.text = @"not provided";
            }
            break;
            
        case SCUserDetailModuleTypeWebsite:
            self.titleLabel.text = @"WEBSITE";
            if (user[@"website"]) {
                self.contentLabel.text = user[@"website"];
            }
            else{
                self.contentLabel.text = @"type in your link";
            }
            break;
        default:
            break;
    }
    
}

@end
