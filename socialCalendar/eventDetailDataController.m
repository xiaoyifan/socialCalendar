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
#import "SCEventHoursTableViewCell.h"

static CGFloat kEventHourDefaultHeight = 25.0f;
static CGFloat kEventHourDefaultSpacing = 33.0f;

@implementation eventDetailDataController

- (void)setupWithDelegate:(id <eventDetailDataControllerDelegate>)delegate event:(eventObject *)event tableView:(UITableView *)tableView
{
    self.delegate = delegate;
    self.event = event;
    self.tableView = tableView;

    [self registerNibs];

    self.tableView.tableHeaderView = self.mapController.mapView;
    self.tableView.tableHeaderView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.frame), 260.0f);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}

- (SCEventMapController *)mapController
{
    if (!_mapController) {
        _mapController = [[SCEventMapController alloc] initWithStores:@[self.event]];
    }
    return _mapController;
}

#pragma mark - Private Methods

- (void)registerNibs
{
    [self.tableView registerNib:[UINib nibWithNibName:kEventNameCellNibName bundle:nil] forCellReuseIdentifier:kEventNameCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:kEventAddressCellNibName bundle:nil] forCellReuseIdentifier:kEventAddressCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:kEventHoursTableViewCellNibName bundle:nil] forCellReuseIdentifier:kEventHoursTableViewCellIdentifier];
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
            
        case SCEventDetailModuleTypeTime:
            cell = [tableView dequeueReusableCellWithIdentifier:kEventHoursTableViewCellIdentifier forIndexPath:indexPath];
            [( (SCEventHoursTableViewCell *)cell ) setupWithEvent:self.event];
            break;

        case SCEventDetailModuleTypeNote:
        case SCEventDetailModuleTypeAddress:
            cell = [tableView dequeueReusableCellWithIdentifier:eventAddressTableViewCellIdentifier forIndexPath:indexPath];
            [( (SCEventAddressTableViewCell *)cell ) setupWithEvent:self.event withRowType:indexPath.row];
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
    if (indexPath.row == SCEventDetailModuleTypeName) {
        return 120.0;
    }
    else if(indexPath.row == SCEventDetailModuleTypeTime){
        if (self.event.isInternalEvent) {
            return kEventHourDefaultHeight + kEventHourDefaultSpacing;
        }
        else{
            return kEventHourDefaultHeight*3 + kEventHourDefaultSpacing;
        }
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

    if ([self.delegate respondsToSelector:@selector(eventDetailDataController:didSelectAtIndexPath:)]) {
        [self.delegate eventDetailDataController:self didSelectAtIndexPath:indexPath];
    }
}

@end
