//
//  friendsPickingTableViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 6/8/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "friendsPickingTableViewController.h"

@interface friendsPickingTableViewController ()

@end

@implementation friendsPickingTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD show];
    [[FirebaseManager sharedInstance] getMyFriendsToCompletion: ^(NSArray *array) {
        self.friendsArray = [array mutableCopy];
        [self.tableView reloadData];

        self.selectMarkArray = [[NSMutableArray alloc] initWithCapacity:self.friendsArray.count];

        for (int i = 0; i < self.friendsArray.count; i++) {
            [self.selectMarkArray addObject:@0];
        }
        [SVProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.friendsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pickingCell" forIndexPath:indexPath];

    PFUser *user = [self.friendsArray objectAtIndex:indexPath.row];

    cell.textLabel.text = user.username;
    cell.detailTextLabel.text = user.email;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectMarkArray[indexPath.row] = @1;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.selectMarkArray[indexPath.row] = @0;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.selectedArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.selectMarkArray.count; i++) {
        if ([self.selectMarkArray[i] isEqual:@1]) {
            [self.selectedArray addObject:self.friendsArray[i]];
        }
    }
}

@end
