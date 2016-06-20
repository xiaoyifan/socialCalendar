//
//  addEventTableViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 5/25/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "addEventTableViewController.h"
#import "mapViewController.h"
#import "KLCPopup.h"
#import "friendsPickingTableViewController.h"
#import "RMDateSelectionViewController.h"


@interface addEventTableViewController () <UIPickerViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;


@property (nonatomic, strong) KLCPopup *reminderPopup;

@property (nonatomic, strong) NSArray *pickerData;


@property (weak, nonatomic) IBOutlet UITextField *titleField;

@property (weak, nonatomic) IBOutlet UITextView *noteField;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property NSMutableArray *selectedFriends;

@end

@implementation addEventTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pickerData = @[@"10 mins before", @"15 mins before", @"30 mins before", @"1 hour before", @"5 hours before", @"1 day before"];

    self.timeLabel.text = @"Pick your date";
}

- (IBAction)selectDate:(id)sender
{
    RMActionControllerStyle style = RMActionControllerStyleWhite;

    RMAction *selectAction = [RMAction actionWithTitle:@"Select" style:RMActionStyleDone andHandler: ^(RMActionController *controller) {
        NSLog(@"Successfully selected date: %@", ( (UIDatePicker *)controller.contentView ).date);
        self.eventDate = ( (UIDatePicker *)controller.contentView ).date;

        if ([self.eventDate compare:[NSDate date]] == NSOrderedAscending) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time invalid" message:@"Can not create event earlier than current time" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];

            self.eventDate = [NSDate date];
        }

        NSDateFormatter *dateFormater = [NSDateFormatter new];
        dateFormater.dateFormat = kDateFormatInselection;
        self.timeLabel.text = [dateFormater stringFromDate:self.eventDate];
        [self showTabBar:self.tabBarController];
    }];

    RMAction *cancelAction = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler: ^(RMActionController *controller) {
        NSLog(@"Date selection was canceled");
        [self showTabBar:self.tabBarController];
    }];

    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:style];
    dateSelectionController.title = @"Pick Date";
    dateSelectionController.message = @"Pick your event date";

    [dateSelectionController addAction:selectAction];
    [dateSelectionController addAction:cancelAction];

    RMAction *in15MinAction = [RMAction actionWithTitle:@"15 Min" style:RMActionStyleAdditional andHandler: ^(RMActionController *controller) {
        ( (UIDatePicker *)controller.contentView ).date = [NSDate dateWithTimeIntervalSinceNow:15 * 60];
        NSLog(@"15 Min button tapped");
    }];
    in15MinAction.dismissesActionController = NO;

    RMAction *in30MinAction = [RMAction actionWithTitle:@"30 Min" style:RMActionStyleAdditional andHandler: ^(RMActionController *controller) {
        ( (UIDatePicker *)controller.contentView ).date = [NSDate dateWithTimeIntervalSinceNow:30 * 60];
        NSLog(@"30 Min button tapped");
    }];
    in30MinAction.dismissesActionController = NO;

    RMAction *in45MinAction = [RMAction actionWithTitle:@"45 Min" style:RMActionStyleAdditional andHandler: ^(RMActionController *controller) {
        ( (UIDatePicker *)controller.contentView ).date = [NSDate dateWithTimeIntervalSinceNow:45 * 60];
        NSLog(@"45 Min button tapped");
    }];
    in45MinAction.dismissesActionController = NO;

    RMAction *in60MinAction = [RMAction actionWithTitle:@"60 Min" style:RMActionStyleAdditional andHandler: ^(RMActionController *controller) {
        ( (UIDatePicker *)controller.contentView ).date = [NSDate dateWithTimeIntervalSinceNow:60 * 60];
        NSLog(@"60 Min button tapped");
    }];
    in60MinAction.dismissesActionController = NO;

    RMGroupedAction *groupedAction = [RMGroupedAction actionWithStyle:RMActionStyleAdditional andActions:@[in15MinAction, in30MinAction, in45MinAction, in60MinAction]];

    [dateSelectionController addAction:groupedAction];

    RMAction *nowAction = [RMAction actionWithTitle:@"Now" style:RMActionStyleAdditional andHandler: ^(RMActionController *controller) {
        ( (UIDatePicker *)controller.contentView ).date = [NSDate date];
        NSLog(@"Now button tapped");
    }];
    nowAction.dismissesActionController = NO;

    [dateSelectionController addAction:nowAction];

    //You can enable or disable blur, bouncing and motion effects
    dateSelectionController.disableBouncingEffects = NO;
    dateSelectionController.disableMotionEffects = NO;
    dateSelectionController.disableBlurEffects = NO;

    //You can access the actual UIDatePicker via the datePicker property
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    dateSelectionController.datePicker.minuteInterval = 5;
    dateSelectionController.datePicker.date = [NSDate date];

    //On the iPad we want to show the date selection view controller within a popover. Fortunately, we can use iOS 8 API for this! :)
    //(Of course only if we are running on iOS 8 or later)
    if ([dateSelectionController respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //First we set the modal presentation style to the popover style
        dateSelectionController.modalPresentationStyle = UIModalPresentationPopover;

        //Then we tell the popover presentation controller, where the popover should appear
        dateSelectionController.popoverPresentationController.sourceView = self.tableView;
        dateSelectionController.popoverPresentationController.sourceRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }

    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
    [self hideTabBar:self.tabBarController];
}

- (void)hideTabBar:(UITabBarController *)tabbarcontroller
{
    [UIView animateWithDuration:0.5f animations: ^{
        for (UIView *view in tabbarcontroller.view.subviews) {
            if ([view isKindOfClass:[UITabBar class]]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y + 49.f, view.frame.size.width, view.frame.size.height)];
            }
        }
    } completion: ^(BOOL finished) {
        //do smth after animation finishes
        tabbarcontroller.tabBar.hidden = YES;
    }];
}

- (void)showTabBar:(UITabBarController *)tabbarcontroller
{
    tabbarcontroller.tabBar.hidden = NO;
    [UIView animateWithDuration:0.5f animations: ^{
        for (UIView *view in tabbarcontroller.view.subviews) {
            if ([view isKindOfClass:[UITabBar class]]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y - 49.f, view.frame.size.width, view.frame.size.height)];
            }
        }
    } completion: ^(BOOL finished) {
        //do smth after animation finishes
    }];
}

- (IBAction)addReminder:(UIButton *)sender
{
    UIPickerView *myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    myPickerView.delegate = self;
    myPickerView.layer.cornerRadius = 15.0;
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.backgroundColor = [UIColor colorWithRed:(184.0 / 255.0) green:(233.0 / 255.0) blue:(122.0 / 255.0) alpha:1.0];

    self.reminderPopup = [KLCPopup popupWithContentView:myPickerView
                                               showType:KLCPopupShowTypeSlideInFromLeft
                                            dismissType:KLCPopupDismissTypeSlideOutToRight
                                               maskType:KLCPopupMaskTypeDimmed
                               dismissOnBackgroundTouch:YES
                                  dismissOnContentTouch:NO];


    [self.reminderPopup show];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.reminderLabel.text = self.pickerData[row];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerData.count;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerData[row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    int sectionWidth = 300;

    return sectionWidth;
}

//unwind segue
- (IBAction)unwindToTable:(UIStoryboardSegue *)segue
{
    mapViewController *source = [segue sourceViewController];
    CLLocation *itemLocation = source.selectedLocation;
    NSString *address = source.selectedLocationAddress;
    self.itemLocation = [[CLLocation alloc] initWithLatitude:itemLocation.coordinate.latitude longitude:itemLocation.coordinate.longitude];
    //assign the location to the add view controller, this is the location data from the map view controller

    NSLog(@"the selected location is: %f, %f", self.itemLocation.coordinate.latitude, self.itemLocation.coordinate.longitude);

    if (itemLocation != nil) {
        self.locationLabel.text = [NSString stringWithFormat:@"%@", address];
    }

    if ([self.locationLabel.text isEqualToString:@"@(null)"]) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showInfo:self title:@"Location Info not available" subTitle:@"The current location has no available information. Try to pick the location again near the streets or some public area." closeButtonTitle:@"Got it" duration:0.0f];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDate *)getDateFromText:(NSString *)string
{
    //@[@"10 mins head", @"15 mins head", @"30 mins head", @"1 hour head", @"5 hours head", @"1 day head"];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];


    if ([string isEqualToString:@"10 mins before"]) {
        [offsetComponents setMinute:-10]; // note that I'm setting it to -1
    } else if ([string isEqualToString:@"15 mins before"]) {
        [offsetComponents setMinute:-15]; // note that I'm setting it to -1
    } else if ([string isEqualToString:@"30 mins before"]) {
        [offsetComponents setMinute:-30]; // note that I'm setting it to -1
    } else if ([string isEqualToString:@"1 hour before"]) {
        [offsetComponents setHour:-1]; // note that I'm setting it to -1
    } else if ([string isEqualToString:@"5 hours before"]) {
        [offsetComponents setHour:-5]; // note that I'm setting it to -1
    } else if ([string isEqualToString:@"1 day before"]) {
        [offsetComponents setDay:-1]; // note that I'm setting it to -1
    }

    NSDate *remindDate = [gregorian dateByAddingComponents:offsetComponents toDate:self.eventDate options:0];

    return remindDate;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.saveButton) {
        return;
    } else {
        [self resignFirstResponder];
        [SVProgressHUD show];
        self.object = [[eventObject alloc] init];
        self.object.title = self.titleField.text;
        self.object.time = self.eventDate;

        self.object.reminderDate = [self getDateFromText:self.reminderLabel.text];
        if (self.itemLocation.coordinate.latitude != 0 || self.itemLocation.coordinate.longitude != 0) {
            self.object.location = self.itemLocation;
        }

        if (![self.locationLabel.text isEqualToString:@"add the location"]) {
            self.object.locationDescription = self.locationLabel.text;
        } else {
            self.object.locationDescription = @"";
        }
        self.object.eventNote = self.noteField.text;
        self.object.group = self.selectedFriends;

        //sent notifications to all selected users
        if (self.selectedFriends.count != 0) {
            PFQuery *pushQuery = [PFInstallation query];
            [pushQuery whereKey:@"owner" containedIn:self.selectedFriends];

            PFPush *push = [[PFPush alloc] init];
            [push setQuery:pushQuery];
            [push setMessage:[NSString stringWithFormat:@"%@ wants to add you to the event: %@", [PFUser currentUser].username, self.object.title]];
            [push sendPushInBackground];
        }

        [[FirebaseManager sharedInstance] insertNewObjectToDatabase:self.object ToCompletion: ^(NSError *error){
            
            if (error == NULL) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"New Events Added!"];
            }
            
        }];

        [self registerLocalNotificationForEvent:self.object];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([self.titleField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"the title can't be empty" message:@"please complete all the necessary information" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    } else if (!self.eventDate)    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showError:self title:@"No Date Selected" subTitle:@"please pick the time of this event" closeButtonTitle:@"Got it" duration:1.0f];
        return NO;
    }

    return YES;
}

#pragma mark -localNotification registration

- (void)registerLocalNotificationForEvent:(eventObject *)event
{
    UILocalNotification *localNotification1 = [[UILocalNotification alloc] init];
    localNotification1.fireDate = event.reminderDate;
    localNotification1.alertBody = self.object.title;
    localNotification1.timeZone = [NSTimeZone defaultTimeZone];
    localNotification1.soundName = UILocalNotificationDefaultSoundName;
    NSString *key1 = [NSString stringWithFormat:@"%@-date", self.title];
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              key1, @"key", nil];
    localNotification1.userInfo = infoDict;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification1];

    UILocalNotification *localNotification2 = [[UILocalNotification alloc] init];
    localNotification2.fireDate = event.reminderDate;
    localNotification2.alertBody = self.object.title;
    localNotification2.timeZone = [NSTimeZone defaultTimeZone];
    localNotification2.soundName = UILocalNotificationDefaultSoundName;
    NSString *key2 = [NSString stringWithFormat:@"%@-remind", self.title];
    NSDictionary *infoDict2 = [NSDictionary dictionaryWithObjectsAndKeys:
                               key2, @"key", nil];
    localNotification2.userInfo = infoDict2;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification2];
}

#pragma mark - unwind segue

- (IBAction)unwindToAddController:(UIStoryboardSegue *)segue
{
    friendsPickingTableViewController *source = [segue sourceViewController];

    self.selectedFriends = source.selectedArray;
}

@end
