//
//  FacebookStyleViewController.m
//  BLKFlexibleHeightBar Demo
//
//  Created by Bryan Keller on 3/7/15.
//  Copyright (c) 2015 Bryan Keller. All rights reserved.
//

#import "FacebookStyleViewController.h"

#import "FacebookStyleBar.h"
#import "FacebookStyleBarBehaviorDefiner.h"
#import "userTableViewCell.h"

@interface FacebookStyleViewController () <UITableViewDataSource, flexibleHeightBarDelegate>

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
    
    FacebookStyleBarBehaviorDefiner *behaviorDefiner = [[FacebookStyleBarBehaviorDefiner alloc] init];
    [behaviorDefiner addSnappingPositionProgress:0.0 forProgressRangeStart:0.0 end:40.0/(105.0-20.0)];
    [behaviorDefiner addSnappingPositionProgress:1.0 forProgressRangeStart:40.0/(105.0-20.0) end:1.0];
    behaviorDefiner.snappingEnabled = YES;
        behaviorDefiner.thresholdNegativeDirection = 140.0;
    ((UIScrollView *)self.tableView).delegate = behaviorDefiner;
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
    [closeButton addLayoutAttributes:initialCloseButtonLayoutAttributes forProgress:40.0/(105.0-20.0)];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalCloseButtonLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialCloseButtonLayoutAttributes];
    finalCloseButtonLayoutAttributes.transform = CGAffineTransformMakeTranslation(0.0, -0.3*(105-20));
    finalCloseButtonLayoutAttributes.alpha = 0.0;
    
    [closeButton addLayoutAttributes:finalCloseButtonLayoutAttributes forProgress:0.8];
    [closeButton addLayoutAttributes:finalCloseButtonLayoutAttributes forProgress:1.0];
    
    [self.myCustomBar addSubview:closeButton];
    
    self.showFriend = true;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.showFriend = true;
    
    [[ParsingHandle sharedParsing] getMyFriendsToCompletion:^(NSArray *array){
       
        self.friendsArray = [array mutableCopy];
        self.dataArray = self.friendsArray;
        
        [[ParsingHandle sharedParsing] getApprovedUsersToCompletion:^(NSArray *array){
            
            [self.dataArray addObjectsFromArray:array];
        }];
        
        [self.tableView reloadData];
    }];
    
    
}

-(void)friendButtonPressed{
    NSLog(@"friend is selected");
    
    self.showFriend = true;
    
    [[ParsingHandle sharedParsing] getMyFriendsToCompletion:^(NSArray *array){
        
        self.friendsArray = [array mutableCopy];
        
        self.dataArray = self.friendsArray;
        
        [self.tableView reloadData];
    }];
    
}



-(void)requestButtonPressed{
    NSLog(@"request is selected");
    
    self.showFriend = false;
    
    [[ParsingHandle sharedParsing] getMyPendingReceivedRequestToCompletion:^(NSArray *array){
        
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
    }];
    
}


- (IBAction)actionButtonTapped:(id)sender {
    
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"%ld", (long)senderButton.tag);
    PFUser *user = [self.dataArray objectAtIndex:senderButton.tag];
    //get the user from
    
    //load data in friends table
    if (self.showFriend) {
        
        [senderButton setTitle:@"unfriended" forState:UIControlStateNormal];
        [senderButton setBackgroundColor:[UIColor darkGrayColor]];
        
        
    }
    else{
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
        
    }
    
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
    
    if (self.showFriend) {
        
        [cell.actionButton setTitle:@"unfriend" forState:UIControlStateNormal];
        [cell.actionButton setBackgroundColor:[UIColor colorWithHexString:@"#3b5998"]];
        
    }
    else{//request table
        
        [cell.actionButton setTitle:@"add" forState:UIControlStateNormal];
        [cell.actionButton setBackgroundColor:[UIColor colorWithHexString:@"#3b5998"]];
        
    }
    
    cell.actionButton.layer.cornerRadius = 5.0;
    
    
    PFUser *user = [self.dataArray objectAtIndex:indexPath.row];
    cell.username.text = user.username;
    cell.mailaddress.text = user.email;
    
    return cell;
}

@end
