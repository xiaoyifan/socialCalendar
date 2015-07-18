//
//  SCProfileInfoCell.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/18/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "SCProfileInfoCell.h"

@implementation SCProfileInfoCell

-(void)setupWithUser:(PFUser *)user withRowType:(SCUserDetailModuleType)rowtype{
    
    switch (rowtype) {
        case SCUserDetailModuleTypeNickName:
            self.titleLabel.text = @"NAME";
            self.contentLabel.text = user.username;
            break;
        case SCUserDetailModuleTypeEmail:
            self.titleLabel.text = @"EMAIL";
            self.contentLabel.text = user.email;
            break;
            
//        case SCUserDetailModuleTypeGender:
//            
//            break;
//            
//        case SCUserDetailModuleTypeWhatsUp:
//            
//            break;
//            
//        case SCUserDetailModuleTypeEducation:
//            
//            break;
//            
//        case SCUserDetailModuleTypeWork:
//            
//            break;
//            
//        case SCUserDetailModuleTypeRegion:
//            
//            break;
//            
//        case SCUserDetailModuleTypeWebsite:
//            
//            break;
            
        default:
            break;
    }
    
}

@end
