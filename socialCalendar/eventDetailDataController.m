//
//  eventDetailDataController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/11/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "eventDetailDataController.h"
#import "SCEventNameTableViewCell.h"
#import "SCEventAddressTableViewCell.h"

//static CGFloat kStoreHourDefaultHeight = 20.0f;
//static CGFloat kStoreHourDefaultSpacing = 33.0f;
static CGFloat kStoreInfoAddressDefaultHeight = 90.0f;

@implementation eventDetailDataController

-(void)setupWithDelegate:(id<eventDetailDataControllerDelegate>)delegate event:(eventObject *)event tableView:(UITableView *)tableView{
    
    self.delegate = delegate;
    self.event = event;
    self.tableView = tableView;
    
    [self registerNibs];
    
    //self.tableView.tableHeaderView = self.mapController.mapView;
    self.tableView.tableHeaderView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.frame), 500.0f);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}

#pragma mark - Accessors

//- (LPStoreMapController *)mapController
//{
//    if (!_mapController) {
//        _mapController = [[LPStoreMapController alloc] initWithStores:@[self.store]];
//    }
//    return _mapController;
//}

#pragma mark - Private Methods

- (void)registerNibs
{
    [self.tableView registerNib:[UINib nibWithNibName:kEventNameCellNibName bundle:nil] forCellReuseIdentifier:kEventNameCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:kEventAddressCellNibName bundle:nil] forCellReuseIdentifier:kEventAddressCellIdentifier];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return SCEventDetailModuleTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    switch (indexPath.row) {
        case SCEventDetailModuleTypeName:
            cell = [tableView dequeueReusableCellWithIdentifier:eventNameTableViewCellIdentifier forIndexPath:indexPath];
            [( (SCEventNameTableViewCell *)cell ) setupWithEvent:self.event];
            break;
            
        case SCEventDetailModuleTypeAddress:
            cell = [tableView dequeueReusableCellWithIdentifier:eventAddressTableViewCellIdentifier forIndexPath:indexPath];
            [( (SCEventAddressTableViewCell *)cell ) setupWithEvent:self.event];
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == SCEventDetailModuleTypeAddress) {
        return kStoreInfoAddressDefaultHeight;
    }
    
    return UITableViewAutomaticDimension;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == SCEventDetailModuleTypeAddress);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:index];
    
    if ([self.delegate respondsToSelector:@selector(eventDetailDataController:didSelectAtIndexPath:)]) {
        [self.delegate eventDetailDataController:self didSelectAtIndexPath:indexPath];
    }
}

@end
