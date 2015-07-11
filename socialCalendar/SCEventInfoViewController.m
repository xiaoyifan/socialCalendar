//
//  SCEventInfoViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/6/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "SCEventInfoViewController.h"
#import "eventDetailDataController.h"

@interface SCEventInfoViewController ()<eventDetailDataControllerDelegate>

@property (strong, nonatomic) eventObject *event;

@property (weak, nonatomic) IBOutlet UITableView *storeInfoTableView;

@property (strong, nonatomic) eventDetailDataController *eventDetailDataController;

@end

@implementation SCEventInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupDataController];
    self.navigationItem.title = kEventDetailTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupWithEvent:(eventObject *)eventObj{
    
    self.event = eventObj;
}

#pragma mark - Private Methods

- (void)setupDataController
{
    [self.eventDetailDataController setupWithDelegate:self event:self.event tableView:self.storeInfoTableView];
}

#pragma mark - Accessors

- (eventDetailDataController *)eventDetailDataController
{
    if (!_eventDetailDataController) {
        _eventDetailDataController = [eventDetailDataController new];
    }
    return _eventDetailDataController;
}

-(void)eventDetailDataController:(eventDetailDataController *)dataController didSelectAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == LPStoreInfoModuleTypeAddress) {
//        [LPLocationManager openMapsWithStore:self.store];
//    }
}

@end
