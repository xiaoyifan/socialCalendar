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
            [[ParsingHandle sharedParsing] updateUser:[PFUser currentUser] Username:text ToCompletion: ^(BOOL finished) {
                completion(finished);
            }];
        }
        break;

        case SCUserDetailModuleTypeEmail:
        {
            [[ParsingHandle sharedParsing] updateUser:[PFUser currentUser] Email:text ToCompletion: ^(BOOL finished) {
                completion(finished);
            }];
        }
        break;

        case SCUserDetailModuleTypeEducation:
        {
            [[ParsingHandle sharedParsing] updateUser:[PFUser currentUser] Education:text ToCompletion: ^(BOOL finished) {
                completion(finished);
            }];
        }
        break;

        case SCUserDetailModuleTypeWork:
        {
            [[ParsingHandle sharedParsing] updateUser:[PFUser currentUser] Work:text ToCompletion: ^(BOOL finished) {
                completion(finished);
            }];
        }
        break;

        case SCUserDetailModuleTypeWebsite:
        {
            [[ParsingHandle sharedParsing] updateUser:[PFUser currentUser] Website:text ToCompletion: ^(BOOL finished) {
                completion(finished);
            }];
        }
        break;

        case SCUserDetailModuleTypeWhatsUp:
        {
            [[ParsingHandle sharedParsing] updateUser:[PFUser currentUser] Whatsup:text ToCompletion: ^(BOOL finished) {
                completion(finished);
            }];
        }
        break;

        case SCUserDetailModuleTypeGender:
        {
            [[ParsingHandle sharedParsing] updateUser:[PFUser currentUser] Gender:text ToCompletion: ^(BOOL finished) {
                completion(finished);
            }];
        }
        break;

        default:
            completion(FALSE);
            break;
    }
}

@end
