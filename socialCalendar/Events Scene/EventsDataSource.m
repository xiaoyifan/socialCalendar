//
//  EventsDataSource.m
//  socialCalendar
//
//  Created by Yifan Xiao on 6/19/16.
//  Copyright © 2016 Yifan Xiao. All rights reserved.
//

#import "EventsDataSource.h"

@implementation EventsDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if ([self count] != 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.backgroundView   =  nil;
    }
    return [self count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

@end
