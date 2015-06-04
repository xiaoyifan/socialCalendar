//
//  calendarController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 5/24/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "calendarController.h"
#import "calendarTableViewCell.h"
#import "detailViewController.h"

@interface calendarController ()<UITableViewDataSource, UITableViewDelegate>


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
    
    self.eventTableView.delegate = self;
    self.eventTableView.dataSource = self;
    
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handleDouleTap)];
    recognizer.numberOfTapsRequired = 2;
    recognizer.cancelsTouchesInView = YES;
    recognizer.delaysTouchesBegan =YES;
    [self.eventTableView addGestureRecognizer:recognizer];
}


-(void)viewWillAppear:(BOOL)animated{
    [[ParsingHandle sharedParsing] findObjectsofDate:[NSDate date] ToCompletion:^(NSArray *array){
        
        self.eventsToday = [[NSMutableArray alloc] init];
        NSLog(@"today contains %lu events", (unsigned long)array.count);
        
        for (PFObject *obj in array) {
            eventObject *newObj = [[ParsingHandle sharedParsing] parseObjectToEventObject:obj];
            [self.eventsToday addObject:newObj];
        }
        [self.eventsToday addObjectsFromArray:[[ParsingHandle sharedParsing] findObjectsFromNativeCalendarOnDate:[NSDate date]]];

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.eventTableView reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TodaytableViewdidLoad" object:self];
        });
        
    }];
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
        
        [self.eventsToday addObjectsFromArray:[[ParsingHandle sharedParsing] findObjectsFromNativeCalendarOnDate:date]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.eventTableView reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TodaytableViewdidLoad" object:self];
        });
        
    }];
}


#pragma mark - table view delegate and data source implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.eventsToday.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    calendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"calendarCell" forIndexPath:indexPath];
    
    cell.separator.backgroundColor = [self randomColor];
    
    eventObject *singleEvent = [self.eventsToday objectAtIndex:indexPath.row];
    
    cell.eventTitle.text = singleEvent.title;
    
    NSDate *eventDate = singleEvent.time;
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    
    dateFormater.dateFormat = @"HH:mm";
    cell.eventTime.text =[dateFormater stringFromDate:eventDate];

    return cell;
}

-(UIColor *)randomColor{
    NSArray *sliceColors =[NSArray arrayWithObjects:
                           
                           [UIColor colorWithRed:121/255.0 green:134/255.0 blue:203/255.0 alpha:1], //5. indigo
                           [UIColor colorWithRed:174/255.0 green:213/255.0 blue:129/255.0 alpha:1], //14. light green
                           [UIColor colorWithRed:100/255.0 green:181/255.0 blue:246/255.0 alpha:1], //2. blue
                           [UIColor colorWithRed:220/255.0 green:231/255.0 blue:117/255.0 alpha:1], //8. lime
                           [UIColor colorWithRed:79/255.0 green:195/255.0 blue:247/255.0 alpha:1], //7. light blue
                           [UIColor colorWithRed:77/255.0 green:208/255.0 blue:225/255.0 alpha:1], //3. cyan
                           [UIColor colorWithRed:77/255.0 green:182/255.0 blue:172/255.0 alpha:1], //13. teal
                           [UIColor colorWithRed:129/255.0 green:199/255.0 blue:132/255.0 alpha:1], //9. green
                           [UIColor colorWithRed:255/255.0 green:241/255.0 blue:118/255.0 alpha:1], //16. yellow
                           [UIColor colorWithRed:255/255.0 green:213/255.0 blue:79/255.0 alpha:1], //12. amber
                           [UIColor colorWithRed:255/255.0 green:183/255.0 blue:77/255.0 alpha:1], //4. orange
                           [UIColor colorWithRed:255/255.0 green:138/255.0 blue:101/255.0 alpha:1], //10. deep orange
                           [UIColor colorWithRed:144/255.0 green:164/255.0 blue:174/255.0 alpha:1], //15. blue grey
                           [UIColor colorWithRed:229/255.0 green:155/255.0 blue:155/255.0 alpha:1], //6. red
                           [UIColor colorWithRed:240/255.0 green:98/255.0 blue:146/255.0 alpha:1], //1. pink
                           [UIColor colorWithRed:186/255.0 green:104/255.0 blue:200/255.0 alpha:1], //11. purple
                           nil];
    
    int rad = arc4random() % 16;
    return sliceColors[rad];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([segue.identifier  isEqual: @"detailSegue"]) {
        
        detailViewController *controller = (detailViewController *)[segue destinationViewController];
        
        NSIndexPath *indexPath = [self.eventTableView indexPathForSelectedRow];
        
        calendarTableViewCell *cell = (calendarTableViewCell *)[self.eventTableView cellForRowAtIndexPath:indexPath];
        
        eventObject * selectedObject = [self.eventsToday objectAtIndex:indexPath.row];
        //get the item tapped in the tableView
        controller.detailObject = selectedObject;
        controller.cardBackgroundColor = cell.separator.backgroundColor;
        
    }

}



@end
