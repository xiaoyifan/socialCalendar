//
//  profileViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/17/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "profileViewController.h"
#import "SCEventHourCell.h"

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

@interface profileViewController ()

@property (nonatomic,strong) MBTwitterScroll* myTableView;

@end

@implementation profileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTableView = [[MBTwitterScroll alloc]
                                    initTableViewWithBackgound:[UIImage imageNamed:@"background"]
                                    avatarImage:[UIImage imageNamed:@"avatar.png"]
                                    titleString:@"Yifan Xiao"
                                    subtitleString:@"xiaoyifan@uchicago.edu"
                                    buttonTitle:nil];  // Set nil for no button
    
    self.myTableView.tableView.delegate = self;
    self.myTableView.tableView.dataSource = self;
    self.myTableView.delegate = self;
    
    [self registerNibs];
    
    [self.view addSubview:self.myTableView];
    
}

-(void)registerNibs{
    [self.myTableView.tableView registerNib:[UINib nibWithNibName:kEventHourCellNibName bundle:nil] forCellReuseIdentifier:kEventHourCellReuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return SCUserDetailModuleTypeCount;
}

-(void) recievedMBTwitterScrollEvent {

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SCEventHourCell *cell = [tableView dequeueReusableCellWithIdentifier:kEventHourCellReuseIdentifier forIndexPath:indexPath];
     //[cell setupCellWithTime:self.event.time withTitle:@"EVENT TIME"];
    
    return cell;
}

@end
