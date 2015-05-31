//
//  calendarController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 5/24/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "calendarController.h"

@interface calendarController ()


@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;

@property (strong, nonatomic) JTCalendar *calendar;


@property (weak, nonatomic) IBOutlet UITableView *eventTableView;


@property NSMutableArray *eventsToday;

@end

@implementation calendarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.calendar = [JTCalendar new];
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    
    [self.calendar reloadData];
    
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handleDouleTap)];
    recognizer.numberOfTapsRequired = 2;
    [self.eventTableView addGestureRecognizer:recognizer];
}

-(void)handleDouleTap{
    NSLog(@"table view double tapped");
    
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    
    [self transitionExample];
    
}

- (void)transitionExample
{
    CGFloat newHeight = 300;
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 75.;
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.calendarContentViewHeight.constant = newHeight;
                         [self.view layoutIfNeeded];
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 1;
                                          }];
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
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
    
    [[ParsingHandle sharedParsing] findObjectsofDate:date ToCompletion:^(NSArray *array){
        
        self.eventsToday = [[NSMutableArray alloc] init];
        NSLog(@"today contains %lu events", (unsigned long)array.count);
        
        for (PFObject *obj in array) {
            eventObject *newObj = [[ParsingHandle sharedParsing] parseObjectToEventObject:obj];
            [self.eventsToday addObject:newObj];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //[self.eventTableView reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TodaytableViewdidLoad" object:self];
        });
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
