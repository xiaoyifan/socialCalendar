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
static NSString *const kTextSwitchCellIdentifier = @"textSwitchCell";


#pragma mark -- Nib Files
static NSString *const kEventNameCellNibName = @"SCEventNameTableViewCell";
static NSString *const kEventAddressCellNibName = @"SCEventAddressTableViewCell";
static NSString *const kEventMapCellNibName = @"SCEventMapTableViewCell";
static NSString *const kEventHoursTableViewCellNibName = @"SCEventHoursTableViewCell";
static NSString *const kEventHourCellNibName = @"SCEventHourCell";
static NSString *const kProfileInfoCellNibName= @"SCProfileInfoCell";
static NSString *const kProfileEditableCellNibName = @"SCProfileEditableCell";
static NSString *const kTextSwitchCellNibName = @"SCTextSwitchCollectionViewCell";

#pragma mark -- Strings & Titles

static NSString *const kEventDetailTitle = @"Event Detail";
static NSString *const kEventNoAddressText = @"event address is not available";

#pragma mark -- keys

static NSString *const kDatePresentingFormat = @"dd-MMM-YYYY HH:mm";
static NSString *const kDateFormatInselection = @"yyyy-MMMM-dd HH:mm";

static NSString *const kEventTitleKey = @"title";
static NSString *const kEventTimeKey = @"time";
static NSString *const kEventRemindTimeKey = @"reminderDate";
static NSString *const kEventLocationKey = @"location";
static NSString *const kEventLocationDescriptionKey = @"locationDescription";
static NSString *const kEventNoteKey = @"eventNote";
static NSString *const kEventGroupKey = @"group";
static NSString *const kEventObjectIDKey = @"objectId";
static NSString *const kEventInternalKey = @"isInternal";

#pragma mark -- AlertView default string

static NSString *const kSCAlertPlaceholderNewName = @"input your new name";
static NSString *const kSCAlertPlaceholderNewEmail = @"input your new e-mail";
static NSString *const kSCAlertPlaceholderNewEducation = @"input your education";
static NSString *const kSCAlertPlaceholderNewWork = @"input your work";
static NSString *const kSCAlertPlaceholderNewWebsite = @"input your personal site";
static NSString *const kSCAlertPlaceholderNewWhatsUp = @"input your mind";

static NSString *const kSCAlertTitleNewName = @"new name";
static NSString *const kSCAlertTitleNewEmail = @"new E-mail";
static NSString *const kSCAlertTitleNewEducation = @"new education";
static NSString *const kSCAlertTitleNewWork = @"new work";
static NSString *const kSCAlertTitleNewWebsite = @"new website";
static NSString *const kSCAlertTitleNewWhatsUp = @"What's up";

static NSString *const kPushNotificationActivationAlertTitle = @"ALLOW NOTIFICATIONS";
static NSString *const kPushNotificationDeactivationAlertTitle = @"DISABLE NOTIFICATIONS";
static NSString *const kPushNotificationOnAlertMessage = @"To receive alerts about promotions and your latest orders go to “Settings” > Notifications > turn on “Allow Notifications.”";
static NSString *const kPushNotificationOffAlertMessage = @"To disable alerts about promotions and your latest orders go to “Settings” > Notifications > turn off “Allow Notifications.”";

static NSString *const kCancelButtonTitle = @"Cancel";

static NSString *const kSCAlertSubtitleNewName = @"To update your name, type in the text field and press button to confirm";
static NSString *const kSCAlertSubtitleNewEmail = @"To update your email, type in the text field and press button to confirm";
static NSString *const kSCAlertSubtitleNewEducation = @"To update your education, type in the text field and press button to confirm";
static NSString *const kSCAlertSubtitleNewWork = @"To update your work, type in the text field and press button to confirm";
static NSString *const kSCAlertSubtitleNewWebsite = @"To update your website, type in the text field and press button to confirm";
static NSString *const kSCAlertSubtitleNewWhatsUp = @"Say what you wanna say";


#define socialCalendar_SCConstants_h


#endif
