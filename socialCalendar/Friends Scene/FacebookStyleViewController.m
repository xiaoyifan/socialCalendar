//
//  FacebookStyleViewController.m
//  BLKFlexibleHeightBar Demo
//
//  Created by Bryan Keller on 3/7/15.
//  Copyright (c) 2015 Bryan Keller. All rights reserved.
//

#import "FacebookStyleViewController.h"
#import "userTableViewController.h"
#import "FacebookStyleBar.h"
#import "FacebookStyleBarBehaviorDefiner.h"
#import "userTableViewCell.h"

@interface FacebookStyleViewController () <UITableViewDataSource, flexibleHeightBarDelegate, UITextFieldDelegate>

@property (nonatomic) FacebookStyleBar *myCustomBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property BOOL showFriend;

@end

@implementation FacebookStyleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNeedsStatusBarAppearanceUpdate];

    // Setup the bar
    self.myCustomBar = [[FacebookStyleBar alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), 100.0)];
    self.myCustomBar.delegate = self;
    self.myCustomBar.searchField.delegate = self;

    FacebookStyleBarBehaviorDefiner *behaviorDefiner = [[FacebookStyleBarBehaviorDefiner alloc] init];
    [behaviorDefiner addSnappingPositionProgress:0.0 forProgressRangeStart:0.0 end:40.0 / (105.0 - 20.0)];
    [behaviorDefiner addSnappingPositionProgress:1.0 forProgressRangeStart:40.0 / (105.0 - 20.0) end:1.0];
    behaviorDefiner.snappingEnabled = YES;
    behaviorDefiner.thresholdNegativeDirection = 140.0;
    ( (UIScrollView *)self.tableView ).delegate = behaviorDefiner;
    self.myCustomBar.behaviorDefiner = behaviorDefiner;

    [self.view addSubview:self.myCustomBar];

    // Setup the table view
    // [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.contentInset = UIEdgeInsetsMake(self.myCustomBar.maximumBarHeight, 0.0, 0.0, 0.0);
    self.tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];

    // Add a close button to the bar
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.userInteractionEnabled = YES;
    closeButton.tintColor = [UIColor whiteColor];
    [closeButton setImage:[UIImage imageNamed:@"Plus.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(addUser:) forControlEvents:UIControlEventTouchUpInside];

    BLKFlexibleHeightBarSubviewLayoutAttributes *initialCloseButtonLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] init];
    initialCloseButtonLayoutAttributes.frame = CGRectMake(self.myCustomBar.frame.size.width - 35.0, 26.5, 30.0, 30.0);
    initialCloseButtonLayoutAttributes.zIndex = 1024;

    [closeButton addLayoutAttributes:initialCloseButtonLayoutAttributes forProgress:0.0];
    [closeButton addLayoutAttributes:initialCloseButtonLayoutAttributes forProgress:40.0 / (105.0 - 20.0)];

    BLKFlexibleHeightBarSubviewLayoutAttributes *finalCloseButtonLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialCloseButtonLayoutAttributes];
    finalCloseButtonLayoutAttributes.transform = CGAffineTransformMakeTranslation( 0.0, -0.3 * (105 - 20) );
    finalCloseButtonLayoutAttributes.alpha = 0.0;

    [closeButton addLayoutAttributes:finalCloseButtonLayoutAttributes forProgress:0.8];
    [closeButton addLayoutAttributes:finalCloseButtonLayoutAttributes forProgress:1.0];

    [self.myCustomBar addSubview:closeButton];

    self.showFriend = true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.text.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(username CONTAINS[cd] %@) OR (email CONTAINS[cd] %@)", textField.text, textField.text];

        NSArray *tempArr = [self.dataArray filteredArrayUsingPredicate:predicate];

        self.dataArray = [tempArr mutableCopy];

        [self.tableView reloadData];
    }

    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.showFriend = true;

    [SVProgressHUD show];
    [[ParsingHandle sharedParsing] getMyFriendsToCompletion: ^(NSArray *array) {
        self.friendsArray = [array mutableCopy];
        self.dataArray = self.friendsArray;

        [[ParsingHandle sharedParsing] getApprovedUsersToCompletion: ^(NSArray *array) {
            [self.dataArray addObjectsFromArray:array];
        }];

        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];

    [self.myCustomBar.friendIndicatorView setBackgroundColor:[UIColor colorWithHexString:@"#3b5998"]];
    [self.myCustomBar.requestIndicatorView setBackgroundColor:[UIColor whiteColor]];
    [self.myCustomBar.friendButton setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    [self.myCustomBar.requestButton setBackgroundColor:[UIColor whiteColor]];
}

- (void)friendButtonPressed
{
    NSLog(@"friend is selected");

    self.showFriend = true;

    [self.myCustomBar.friendButton setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    [self.myCustomBar.requestButton setBackgroundColor:[UIColor whiteColor]];

    [self.myCustomBar.friendIndicatorView setBackgroundColor:[UIColor colorWithHexString:@"#3b5998"]];

    [self.myCustomBar.requestIndicatorView setBackgroundColor:[UIColor whiteColor]];

    [SVProgressHUD show];
    [[ParsingHandle sharedParsing] getMyFriendsToCompletion: ^(NSArray *array) {
        self.friendsArray = [array mutableCopy];

        self.dataArray = self.friendsArray;

        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];
}

- (void)requestButtonPressed
{
    NSLog(@"request is selected");

    self.showFriend = false;

    [self.myCustomBar.friendButton setBackgroundColor:[UIColor whiteColor]];
    [self.myCustomBar.requestButton setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];

    [self.myCustomBar.friendIndicatorView setBackgroundColor:[UIColor whiteColor]];
    [self.myCustomBar.requestIndicatorView setBackgroundColor:[UIColor colorWithHexString:@"#3b5998"]];

    [SVProgressHUD show];
    [[ParsingHandle sharedParsing] getMyPendingReceivedRequestToCompletion: ^(NSArray *array) {
        self.requestObjectArray = [array mutableCopy];
        //use this array to store the request, not the request users

        NSMutableArray *userArray = [[NSMutableArray alloc] init];

        for (PFObject *request in array) {
            PFUser *from = request[@"from"];

            [userArray addObject:from];
        }
        //get all the users who sent the request to current user

        self.requestArray = userArray;
        self.dataArray = self.requestArray;

        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)actionButtonTapped:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"%ld", (long)senderButton.tag);
    PFUser *user = [self.dataArray objectAtIndex:senderButton.tag];
    //get the user from

    //load data in friends table
    if (self.showFriend) {
        [senderButton setTitle:@"unfriended" forState:UIControlStateNormal];
        [senderButton setBackgroundColor:[UIColor darkGrayColor]];
    } else {
        //load data in request table
        //in request function, when the button is tapped, we gonna add the user into my user PFRelation
        //and select the request as approved

        //for the button, we gonna set the layout as accepted, then no more processing, in the next view loading, the cell would disappear.
        [senderButton setTitle:@"accepted" forState:UIControlStateNormal];
        [senderButton setBackgroundColor:[UIColor darkGrayColor]];

        PFObject *approvedQuery = [self.requestObjectArray objectAtIndex:senderButton.tag];

        [approvedQuery setObject:@"approved" forKey:@"status"];
        [approvedQuery saveInBackgroundWithBlock:nil];

        [[ParsingHandle sharedParsing] approvedFriendRequestFrom:user];
        //add two users to the relation

        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"user" equalTo:user];

        // Send push notification to query
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:pushQuery]; // Set our Installation query
        [push setMessage:@"Your friend request is approved"];

        [push sendPushInBackground];
    }
}

- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"%ld", (long)senderButton.tag);
    PFUser *user = [self.dataArray objectAtIndex:senderButton.tag];
    //get the user from

    [senderButton setTitle:@"denied" forState:UIControlStateNormal];
    [senderButton setBackgroundColor:[UIColor darkGrayColor]];

    PFObject *approvedQuery = [self.requestObjectArray objectAtIndex:senderButton.tag];

    [approvedQuery setObject:@"denied" forKey:@"status"];
    [approvedQuery saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            // The object has been saved.
            NSLog(@"%@", error);
        }
    }];
    //In this method we just need to set the status to denied, no need to delete the object
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)addUser:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    UINavigationController *controller = [storyboard instantiateViewControllerWithIdentifier:@"userNav"];

    userTableViewController *userController = (userTableViewController *)[controller.viewControllers objectAtIndex:0];

    userController.friendsArray = [self.friendsArray copy];

    [self presentViewController:controller animated:YES completion:nil];
}

# pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    userTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];

    [cell.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cell.cancelActionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    if (self.showFriend) {
        [cell.actionButton setTitle:@"unfriend" forState:UIControlStateNormal];
        [cell.actionButton setBackgroundColor:[UIColor colorWithHexString:@"#3b5998"]];

        cell.secondButtonWidth.constant = 0.0f;
    } else {
        //request table

        [cell.actionButton setTitle:@"add" forState:UIControlStateNormal];
        [cell.actionButton setBackgroundColor:[UIColor colorWithHexString:@"#3b5998"]];

        cell.secondButtonWidth.constant = 70.0f;

        [cell.cancelActionButton setTitle:@"deny" forState:UIControlStateNormal];
        [cell.cancelActionButton setBackgroundColor:[UIColor redColor]];
    }

    cell.actionButton.layer.cornerRadius = 5.0;
    cell.cancelActionButton.layer.cornerRadius = 5.0;

    PFUser *user = [self.dataArray objectAtIndex:indexPath.row];
    cell.username.text = user.username;
    cell.mailaddress.text = user.email;

    return cell;
}

@end
