//
//  profileViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/17/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "profileViewController.h"
#import "SCProfileInfoCell.h"
#import "SCProfileEditableCell.h"

@interface profileViewController ()

@property (nonatomic,strong) MBTwitterScroll* myTableView;

@end

@implementation profileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTableView = [[MBTwitterScroll alloc]
                                    initTableViewWithBackgound:[UIImage imageNamed:@"background"]
                                    avatarImage:[UIImage imageNamed:@"avatar.png"]
                                    titleString:@"Yifan Xiao"
                                    subtitleString:@"xiaoyifan@uchicago.edu"
                                    buttonTitle:nil];  // Set nil for no button
    
    self.myTableView.tableView.delegate = self;
    self.myTableView.tableView.dataSource = self;
    self.myTableView.delegate = self;

    
    [self registerNibs];
    
    [self.view addSubview:self.myTableView];
    
}

-(void)registerNibs{
    [self.myTableView.tableView registerNib:[UINib nibWithNibName:kProfileInfoCellNibName bundle:nil] forCellReuseIdentifier:kProfileInfoCellIdentifier];
    [self.myTableView.tableView registerNib:[UINib nibWithNibName:kProfileEditableCellNibName bundle:nil] forCellReuseIdentifier:kProfileEditableCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return SCUserDetailModuleTypeCount;
}

-(void) recievedMBTwitterScrollEvent {

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.row) {
        case SCUserDetailModuleTypeWhatsUp:
        case SCUserDetailModuleTypeEducation:
        case SCUserDetailModuleTypeWork:
        case SCUserDetailModuleTypeWebsite:
        case SCUserDetailModuleTypeRegion:
        case SCUserDetailModuleTypeGender:
            cell = (SCProfileEditableCell*)[tableView dequeueReusableCellWithIdentifier:kProfileEditableCellIdentifier forIndexPath:indexPath];
            [(SCProfileEditableCell *)cell setupWithUser:[PFUser currentUser] withRowType:indexPath.row];
            break;
        case SCUserDetailModuleTypeEmail:
        case SCUserDetailModuleTypeNickName:
            cell = (SCProfileInfoCell*)[tableView dequeueReusableCellWithIdentifier:kProfileInfoCellIdentifier forIndexPath:indexPath];
            [(SCProfileInfoCell *)cell setupWithUser:[PFUser currentUser] withRowType:indexPath.row];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

@end
