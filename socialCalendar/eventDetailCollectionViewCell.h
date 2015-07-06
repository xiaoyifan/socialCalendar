//
//  eventDetailCollectionViewCell.h
//  socialCalendar
//
//  Created by Yifan Xiao on 7/5/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCollectionViewCell.h"
#import "eventObject.h"

static NSString *const kEventInfoCellReuseIdentifier = @"eventDetail";

@interface eventDetailCollectionViewCell : SCCollectionViewCell<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UITableView *timeTable;
@property (strong, nonatomic)IBOutletCollection(NSLayoutConstraint) NSArray * separatorLinesHeightConstraints;
@property (strong, nonatomic)IBOutletCollection(NSLayoutConstraint) NSArray * storeHoursHeightsConstraints;

@property (weak, nonatomic) eventObject *object;

@property (weak, nonatomic) UIColor *backgroundColor;

/**
 *  Set up event detail cell.
 *
 *  @param eventObj The event object.
 */
-(void)setupCellWithEvent:(eventObject *)eventObj;

@end
