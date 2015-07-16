//
//  SCEventHoursTableViewCell.m
//  socialCalendar
//
//  Created by Yifan Xiao on 6/30/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "SCEventHoursTableViewCell.h"
#import "SCEventHourCell.h"
#import "eventObject.h"

@interface SCEventHoursTableViewCell () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) eventObject *event;

@end

@implementation SCEventHoursTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self.tableView registerNib:[UINib nibWithNibName:kEventHourCellNibName bundle:nil] forCellReuseIdentifier:kEventHourCellReuseIdentifier];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)setupWithEvent:(eventObject *)event
{
    self.event = event;

    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.event.isInternalEvent) {
        return 1;
    }
    else{
        return 2;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCEventHourCell *cell = [tableView dequeueReusableCellWithIdentifier:kEventHourCellReuseIdentifier forIndexPath:indexPath];

    if (indexPath.row == 0) {
        [cell setupCellWithTime:self.event.time withTitle:@"EVENT TIME"];
    }
    else{
        [cell setupCellWithTime:self.event.reminderDate withTitle:@"REMIND ME"];
    }
    return cell;
}

@end
