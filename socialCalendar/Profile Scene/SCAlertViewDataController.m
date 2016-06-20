//
//  SCAlertViewDataController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/19/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "SCAlertViewDataController.h"

@implementation SCAlertViewDataController

- (NSString *)setTitleWithRowType:(SCUserDetailModuleType)rowType
{
    switch (rowType) {
        case SCUserDetailModuleTypeNickName:
            return kSCAlertTitleNewName;
            break;

        case SCUserDetailModuleTypeEmail:
            return kSCAlertTitleNewEmail;
            break;

        case SCUserDetailModuleTypeEducation:
            return kSCAlertTitleNewEducation;
            break;

        case SCUserDetailModuleTypeWork:
            return kSCAlertTitleNewWork;
            break;

        case SCUserDetailModuleTypeWebsite:
            return kSCAlertTitleNewWebsite;
            break;

        case SCUserDetailModuleTypeWhatsUp:
            return kSCAlertTitleNewWhatsUp;
            break;

        default:
            return nil;
            break;
    }
}

- (NSString *)setSubtitleWithRowType:(SCUserDetailModuleType)rowType
{
    switch (rowType) {
        case SCUserDetailModuleTypeNickName:
            return kSCAlertSubtitleNewName;
            break;

        case SCUserDetailModuleTypeEmail:
            return kSCAlertSubtitleNewEmail;
            break;

        case SCUserDetailModuleTypeEducation:
            return kSCAlertSubtitleNewEducation;
            break;

        case SCUserDetailModuleTypeWork:
            return kSCAlertSubtitleNewWork;
            break;

        case SCUserDetailModuleTypeWebsite:
            return kSCAlertSubtitleNewWebsite;
            break;

        case SCUserDetailModuleTypeWhatsUp:
            return kSCAlertSubtitleNewWhatsUp;
            break;

        default:
            return nil;
            break;
    }
}

- (NSString *)setPlaceholderWithRowType:(SCUserDetailModuleType)rowType
{
    switch (rowType) {
        case SCUserDetailModuleTypeNickName:
            return kSCAlertPlaceholderNewName;
            break;

        case SCUserDetailModuleTypeEmail:
            return kSCAlertPlaceholderNewEmail;
            break;

        case SCUserDetailModuleTypeEducation:
            return kSCAlertPlaceholderNewEducation;
            break;

        case SCUserDetailModuleTypeWork:
            return kSCAlertPlaceholderNewWork;
            break;

        case SCUserDetailModuleTypeWebsite:
            return kSCAlertPlaceholderNewWebsite;
            break;

        case SCUserDetailModuleTypeWhatsUp:
            return kSCAlertPlaceholderNewWhatsUp;
            break;

        default:
            return nil;
            break;
    }
}

- (void)updateUserInfoInRow:(SCUserDetailModuleType)rowType withText:(NSString *)text ToCompletion:( void (^)(BOOL finished) )completion
{
    switch (rowType) {
        case SCUserDetailModuleTypeNickName:
        {
            [[FirebaseManager sharedInstance] updateUser:[FIRAuth auth].currentUser Username:text ToCompletion: ^(NSError *error) {
                completion(error);
            }];
        }
        break;

        case SCUserDetailModuleTypeEmail:
        {
            [[FirebaseManager sharedInstance] updateUser:[FIRAuth auth].currentUser Email:text ToCompletion: ^(NSError *error) {
                completion(error);
            }];
        }
        break;
        case SCUserDetailModuleTypeWhatsUp:
        {
            [[FirebaseManager sharedInstance] updateUser:[FIRAuth auth].currentUser Whatsup:text ToCompletion: ^(NSError *error) {
                completion(error);
            }];
        }
        break;

        case SCUserDetailModuleTypeGender:
        {
            [[FirebaseManager sharedInstance] updateUser:[FIRAuth auth].currentUser Gender:text ToCompletion: ^(NSError *error) {
                completion(error);
            }];
        }
        break;

        default:
            completion(FALSE);
            break;
    }
}

@end
