//
//  userTableViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 6/4/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "userTableViewController.h"
#import "listTableViewCell.h"
#import "CSStickyHeaderFlowLayout.h"

@interface userTableViewController ()<UISearchBarDelegate, UISearchDisplayDelegate>

@property IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) NSMutableArray *filteredArray;

@end

@implementation userTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.searchBar setTintColor:[UIColor grayColor]];
    
    [[ParsingHandle sharedParsing] getMyPendingSentRequestToCompletion:^(NSArray *array){
       
        self.sentRequestUserArray = [array mutableCopy];
        //get all the users that I've sent request

    }];
    
    [[ParsingHandle sharedParsing] removeDeniedFriendRequestFrom:[PFUser currentUser]];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.userArray = [[NSMutableArray alloc] init];
    
    [[ParsingHandle sharedParsing] getAllUsersToCompletion:^(NSArray *array){
        
       NSMutableArray *strangerArray = [array mutableCopy];
        
        for (PFUser *singleUser in strangerArray) {
            if (![self isFriendOrHost:singleUser]) {
                [self.userArray addObject:singleUser];
            }
        }
        //delete the users who are my friends alreay, or myself
        
        NSLog(@"how many strangers I have: %lu", (unsigned long)self.userArray.count);
        self.filteredArray = [NSMutableArray arrayWithCapacity:[self.userArray count]];
        
        [self.tableView reloadData];
    }];
}

-(BOOL)isFriendOrHost:(PFUser *)user{
    
    if ([user.objectId isEqualToString:[PFUser currentUser].objectId]) {
        return true;
    }
    
    for (PFUser *friend in self.friendsArray) {
        if ([friend.objectId isEqualToString:user.objectId]) {
            return true;
        }
    }
    
    return false;
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredArray count];
    } else {
        return [self.userArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    listTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"listCell"];
    
    PFUser *user;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        user = [self.filteredArray objectAtIndex:indexPath.row];
    } else {
        user = [self.userArray objectAtIndex:indexPath.row];
    }
    
    cell.username.text = user.username;
    cell.email.text = user.email;
    cell.addButton.layer.cornerRadius = 5.0;
    cell.addButton.tag = indexPath.row;
    
    if ([self requestSentTo:user]) {
        [cell.addButton setBackgroundColor:[UIColor darkGrayColor]];
        [cell.addButton setTitle:@"sent" forState:UIControlStateNormal];
    }
    else{
        [cell.addButton setBackgroundColor:[UIColor colorWithHexString:@"#3b5998"]];
        [cell.addButton setTitle:@"add" forState:UIControlStateNormal];
        
    }
    
    
    //if the user is in the friend request already, if so, change the button color and title text.
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFUser *user;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        user = [self.filteredArray objectAtIndex:indexPath.row];
    } else {
        user = [self.userArray objectAtIndex:indexPath.row];
    }
    
    
    
}

-(BOOL)requestSentTo:(PFUser *)user{
    for (PFObject *request in self.sentRequestUserArray) {
        
        PFUser *sentUser = [request objectForKey:@"to"];
//        NSLog(@"the sent request user name is %@", sentUser.username);
        
        if ([sentUser.objectId isEqualToString:user.objectId]) {
            return true;
        }
    }
    return false;
}


- (IBAction)dismissButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addUserButton:(id)sender {
    
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"%ld", (long)senderButton.tag);
    PFUser *addedUser = [self.userArray objectAtIndex:senderButton.tag];
    
    if ([senderButton.titleLabel.text isEqualToString:@"add"]) {
        [senderButton setTitle:@"sent" forState:UIControlStateNormal];
        [senderButton setBackgroundColor:[UIColor darkGrayColor]];
        
        [[ParsingHandle sharedParsing] sendUserFriendRequest:addedUser];
        //add new request
    }
    else{
        [senderButton setTitle:@"add" forState:UIControlStateNormal];
        [senderButton setBackgroundColor:[UIColor colorWithHexString:@"#3b5998"]];
        
        //delete existed request
    }
    NSLog(@"%@", addedUser.username);
}


#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(username CONTAINS[cd] %@) OR (email CONTAINS[cd] %@)",searchText, searchText];
    self.filteredArray = [NSMutableArray arrayWithArray:[self.userArray filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    tableView.rowHeight = 68.0f; // or some other height
}



@end
