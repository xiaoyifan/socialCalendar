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
    
    
//    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
//    PFQuery *query = [self.friendsRelation query];
//    [query orderByAscending:@"username"];
//    [query findObjectsInBackgroundWithBlock:<#(nullable PFArrayResultBlock(nullable )block#>]
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[ParsingHandle sharedParsing] getMyFriendsToCompletion:^(NSArray *array){
       
        self.friendsArray = [array mutableCopy];
        self.dataArray = self.friendsArray;
        
        [self.tableView reloadData];
    }];
    
    
}

-(void)friendButtonPressed{
    NSLog(@"friend is selected");
    
    [[ParsingHandle sharedParsing] getMyFriendsToCompletion:^(NSArray *array){
        
        self.friendsArray = [array mutableCopy];
    }];
    
    self.dataArray = self.friendsArray;
    
    [self.tableView reloadData];
}

-(void)requestButtonPressed{
    NSLog(@"request is selected");
    
    [[ParsingHandle sharedParsing] getMyPendingReceivedRequestToCompletion:^(NSArray *array){
        
        self.requestArray = [array mutableCopy];
    }];
    
    self.dataArray = self.requestArray;
    
    [self.tableView reloadData];
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
    [cell.actionButton setTitle:@"add" forState:UIControlStateNormal];
    [cell.actionButton setBackgroundColor:[UIColor colorWithHexString:@"#0099FF"]];
    cell.actionButton.layer.cornerRadius = 5.0;
    
    
    PFUser *user = [self.dataArray objectAtIndex:indexPath.row];
    cell.username.text = user.username;
    cell.mailaddress.text = user.email;
    
    return cell;
}

@end
