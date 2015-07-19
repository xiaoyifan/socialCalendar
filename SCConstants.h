//
//  SCConstants.h
//  socialCalendar
//
//  Created by Yifan Xiao on 7/11/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#ifndef socialCalendar_SCConstants_h

#pragma mark -- TableViewCells
static NSString *const kEventNameCellIdentifier = @"eventNameTableViewCell";
static NSString *const kEventAddressCellIdentifier = @"eventAddressTableViewCell";
static NSString *const kEventMapCellIdentifier = @"eventMapTableViewCell";
static NSString *const kProfileInfoCellIdentifier = @"profileInfoCell";
static NSString *const kProfileEditableCellIdentifier = @"profileEditableCell";

#pragma mark -- Nib Files
static NSString *const kEventNameCellNibName = @"SCEventNameTableViewCell";
static NSString *const kEventAddressCellNibName = @"SCEventAddressTableViewCell";
static NSString *const kEventMapCellNibName = @"SCEventMapTableViewCell";
static NSString *const kEventHoursTableViewCellNibName = @"SCEventHoursTableViewCell";
static NSString *const kEventHourCellNibName = @"SCEventHourCell";
static NSString *const kProfileInfoCellNibName= @"SCProfileInfoCell";
static NSString *const kProfileEditableCellNibName = @"SCProfileEditableCell";


#pragma mark -- Strings & Titles

static NSString *const kEventDetailTitle = @"Event Detail";
static NSString *const kEventNoAddressText = @"event address is not available";

#pragma mark -- keys

static NSString *const kDatePresentingFormat = @"dd-MMM-YYYY HH:mm";


#pragma mark -- AlertView default string

static NSString *const kSCAlertPlaceholderNewName = @"input your new name";
static NSString *const kSCAlertPlaceholderNewEmail = @"input your new e-mail";
static NSString *const kSCAlertPlaceholderNewEducation = @"input your education";
static NSString *const kSCAlertPlaceholderNewWork = @"input your work";
static NSString *const kSCAlertPlaceholderNewWebsite = @"input your personal site";

static NSString *const kSCAlertTitleNewName = @"new name";
static NSString *const kSCAlertTitleNewEmail = @"new E-mail";
static NSString *const kSCAlertTitleNewEducation = @"new education";
static NSString *const kSCAlertTitleNewWork = @"new work";
static NSString *const kSCAlertTitleNewWebsite = @"new website";

static NSString *const kSCAlertSubtitleNewName = @"To update your name, type in the text field and press button to confirm";
static NSString *const kSCAlertSubtitleNewEmail = @"To update your email, type in the text field and press button to confirm";
static NSString *const kSCAlertSubtitleNewEducation = @"To update your education, type in the text field and press button to confirm";
static NSString *const kSCAlertSubtitleNewWork = @"To update your work, type in the text field and press button to confirm";
static NSString *const kSCAlertSubtitleNewWebsite = @"To update your website, type in the text field and press button to confirm";

#define socialCalendar_SCConstants_h


#endif
