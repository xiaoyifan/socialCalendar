//
//  profileViewController.h
//  socialCalendar
//
//  Created by Yifan Xiao on 7/17/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBTwitterScroll.h"


typedef NS_ENUM(NSInteger, SCUserDetailModuleType)
{
    SCUserDetailModuleTypeNickName = 0,
    SCUserDetailModuleTypeEmail,
    SCUserDetailModuleTypeWhatsUp,
    SCUserDetailModuleTypeGender,
    SCUserDetailModuleTypeRegion,
    SCUserDetailModuleTypeEducation,
    SCUserDetailModuleTypeWork,
    SCUserDetailModuleTypeWebsite,
    SCUserDetailModuleTypeCount
};

@interface profileViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MBTwitterScrollDelegate>

@end
