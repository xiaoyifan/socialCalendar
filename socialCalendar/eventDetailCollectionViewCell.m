//
//  eventDetailCollectionViewCell.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/5/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "eventDetailCollectionViewCell.h"

@implementation eventDetailCollectionViewCell


- (void)layoutSubviews
{
    [super layoutSubviews];
    for (NSLayoutConstraint *constraint in self.separatorLinesHeightConstraints) {
        constraint.constant = 1.0f / [UIScreen mainScreen].scale;
    }
}


-(void)setupCellWithEvent:(eventObject *)eventObj{
    
    self.object = eventObj;
    
    self.titleLabel.text = eventObj.title;
    self.headerView.backgroundColor = self.backgroundColor;
    self.addressLabel.text = eventObj.locationDescription;
    
    [self.timeTable registerNib:[UINib nibWithNibName:@"StoreHourCell" bundle:nil] forCellReuseIdentifier:@"StoreHourCell"];
    
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self.store.hours count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    LPStoreHourCell *cell = [tableView dequeueReusableCellWithIdentifier:kStoreHourCellReuseIdentifier forIndexPath:indexPath];
//    [cell setupCellWithStoreHours:self.store.hours[indexPath.row]];
//    return cell;
}


@end
