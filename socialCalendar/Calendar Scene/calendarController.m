//
//  calendarController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 5/24/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "calendarController.h"
#import "calendarTableViewCell.h"
#import "SCEventInfoViewController.h"

#import "UIColor+CustomColors.h"

@interface calendarController () <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;
@property (strong, nonatomic) JTCalendar *calendar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;

@property (weak, nonatomic) IBOutlet UITableView *eventTableView;
@property (weak, nonatomic) IBOutlet UISwitch *switchToggle;
@property NSMutableArray *eventsToday;

@end

@implementation calendarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.calendar = [JTCalendar new];

    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];

    [self.calendar reloadData];

    self.eventTableView.delegate = self;
    self.eventTableView.dataSource = self;
    self.calendar.calendarAppearance.dayCircleColorSelected = [UIColor hx_colorWithHexRGBAString:@"#008A2E"];
    self.calendar.calendarAppearance.dayTextColorSelected = [UIColor whiteColor];


    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleDouleTap)];
    recognizer.numberOfTapsRequired = 2;
    recognizer.cancelsTouchesInView = YES;
    recognizer.delaysTouchesBegan = YES;
    [self.eventTableView addGestureRecognizer:recognizer];

    self.eventsToday = [[NSMutableArray alloc] init];
    
    [self.eventsToday addObjectsFromArray:[[FirebaseManager sharedInstance] findObjectsFromNativeCalendarOnDate:[NSDate date]]];
    [self.eventTableView reloadData];
    
    [[FirebaseManager sharedInstance] findObjectsofDate:[NSDate date] ToCompletion: ^(eventObject *obj) {

        [self.eventsToday addObject:obj];
        [self.eventTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.eventsToday count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
        [SVProgressHUD dismiss];

    }];
}

- (IBAction)changeSwitch:(UISwitch *)sender
{
    if ([sender isOn]) {
        self.calendar.calendarAppearance.isWeekMode = YES;
    } else {
        self.calendar.calendarAppearance.isWeekMode = NO;
    }
    [self transitionExample];
}

- (IBAction)changeToToday:(id)sender
{
    [self.calendar setCurrentDate:[NSDate date]];
    [self calendarDidDateSelected:self.calendar date:[NSDate date]];
}

- (void)handleDouleTap
{
    NSLog(@"table view double tapped");

    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;

    if (self.switchToggle.isOn) {
        [self.switchToggle setOn:NO animated:YES];
    } else {
        [self.switchToggle setOn:YES animated:YES];
    }

    [self transitionExample];
}

- (void)transitionExample
{
    CGFloat newHeight = 300;
    if (self.calendar.calendarAppearance.isWeekMode) {
        newHeight = 75.;
    }

    [UIView animateWithDuration:.5
                     animations: ^{
        self.calendarContentViewHeight.constant = newHeight;
        [self.view layoutIfNeeded];
    }];

    [UIView animateWithDuration:.25
                     animations: ^{
        self.calendarContentView.layer.opacity = 0;
    }
                     completion: ^(BOOL finished) {
        [self.calendar reloadAppearance];

        [UIView animateWithDuration:.25
                         animations: ^{
            self.calendarContentView.layer.opacity = 1;
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.calendar reloadAppearance];
    [self.calendar repositionViews];
}

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSLog(@"%@", date);
    [SVProgressHUD show];
    self.eventsToday = [[NSMutableArray alloc] init];
    [self.eventsToday addObjectsFromArray:[[FirebaseManager sharedInstance] findObjectsFromNativeCalendarOnDate:date]];
    [self.eventTableView reloadData];
    
    [[FirebaseManager sharedInstance] findObjectsofDate:date ToCompletion: ^(eventObject * obj) {

        [self.eventsToday addObject:obj];
        [self.eventTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.eventsToday count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [SVProgressHUD dismiss];
       
    }];
}

#pragma mark - table view delegate and data source implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.eventsToday.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    calendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"calendarCell" forIndexPath:indexPath];

    cell.separator.backgroundColor = [UIColor randomColor];

    eventObject *singleEvent = [self.eventsToday objectAtIndex:indexPath.row];

    cell.eventTitle.text = singleEvent.title;

    NSDate *eventDate = singleEvent.time;
    NSDateFormatter *dateFormater = [NSDateFormatter new];

    dateFormater.dateFormat = @"HH:mm";
    cell.eventTime.text = [dateFormater stringFromDate:eventDate];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showEventInfoViewWithEvent:self.eventsToday[indexPath.row]];
}

- (void)showEventInfoViewWithEvent:(eventObject *)eventObj
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"eventDetail" bundle:nil];
    SCEventInfoViewController *eventDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"eventDetailViewController"];
    [eventDetailVC setupWithEvent:eventObj];
    [self.navigationController pushViewController:eventDetailVC animated:YES];
}

@end
