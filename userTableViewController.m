//
//  userTableViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 6/4/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "userTableViewController.h"
#import "listTableViewCell.h"

@interface userTableViewController ()

@end

@implementation userTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[ParsingHandle sharedParsing] getMyFriendsToCompletion:^(NSArray *array){
        
        self.userArray = [array mutableCopy];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.userArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    listTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    
    PFUser *user = [self.userArray objectAtIndex:indexPath.row];
    
    cell.username.text = user.username;
    cell.email.text = user.email;
    cell.addButton.layer.cornerRadius = 5.0;
    cell.addButton.tag = indexPath.row;
    [cell.addButton setBackgroundColor:[UIColor colorWithHexString:@"#3b5998"]];
    
    //if the user is in the friend request already, if so, change the button color and title text.
    
    return cell;
}


- (IBAction)dismissButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addUserButton:(id)sender {
    
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"%ld", (long)senderButton.tag);
    if ([senderButton.titleLabel.text isEqualToString:@"add"]) {
        [senderButton setTitle:@"sent" forState:UIControlStateNormal];
        [senderButton setBackgroundColor:[UIColor darkGrayColor]];
    }
    else{
        [senderButton setTitle:@"add" forState:UIControlStateNormal];
        [senderButton setBackgroundColor:[UIColor colorWithHexString:@"#3b5998"]];
    }
    
    
    PFUser *addedUser = [self.userArray objectAtIndex:senderButton.tag];
    
    NSLog(@"%@", addedUser.username);
    
    
//    listTableViewCell *cell = (listTableViewCell *)[self.tableView cellForRowAtIndexPath:pathToCell];
//    [cell.addButton setTitle:@"sent" forState:UIControlStateNormal];
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
