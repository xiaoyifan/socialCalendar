//
//  CSStickyParallaxHeaderViewController.h
//  socialCalendar
//
//  Created by Yifan Xiao on 7/17/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTextSwitchCollectionViewCell.h"
#import "profileHeader.h"

// Enum for the table view rows.
typedef NS_ENUM(NSInteger, SCUserDetailModuleType)
{
    SCUserDetailModuleTypeNickName = 0,
    SCUserDetailModuleTypeEmail,
    SCUserDetailModuleTypeWhatsUp,
    SCUserDetailModuleTypeGender,
    SCUserDetailModuleTypeRegion,
    SCUserDetailModuleTypeCount
};

typedef NS_ENUM(NSInteger, SCUserAccountType)
{
    SCUserAccountTypeDetail = 0,
    SCUserAccountTypeNotifications,
    SCUserAccountTypeCount
};

@interface profileViewController : UICollectionViewController<SCTextSwitchCollectionViewCellDelegate, cameraHeaderDelegate>

@end
