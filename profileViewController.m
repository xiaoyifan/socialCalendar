//
//  profileViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/17/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "profileViewController.h"
#import "SCAlertViewDataController.h"
#import "SCProfileInfoCell.h"
#import "SCLAlertView.h"

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
            cell = (SCProfileInfoCell*)[tableView dequeueReusableCellWithIdentifier:kProfileInfoCellIdentifier forIndexPath:indexPath];
            [(SCProfileInfoCell *)cell setupWithUser:[PFUser currentUser] withRowType:indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case SCUserDetailModuleTypeNickName:
        case SCUserDetailModuleTypeEmail:
        case SCUserDetailModuleTypeEducation:
        case SCUserDetailModuleTypeWork:
        case SCUserDetailModuleTypeWebsite:
            //show the pop up to set the value
            [self showPopupWithRowtype:indexPath.row];
            break;
        
        case SCUserDetailModuleTypeWhatsUp:
            //push to view controller with text field
            break;
            
        case SCUserDetailModuleTypeGender:
            //push to view controller with gender selection
            break;
            
        case SCUserDetailModuleTypeRegion:
            //push to view controlleer with map and location
            
            break;
            
        default:
            break;
    }
    //[self showEventInfoViewWithEvent:self.events[indexPath.row]];
}

- (void)showPopupWithRowtype:(SCUserDetailModuleType)rowType
{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
//    SCEventInfoViewController *eventDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"eventDetailViewController"];
//    [eventDetailVC setupWithEvent:eventObj];
//    [self.navigationController pushViewController:eventDetailVC animated:YES];
    
    SCAlertViewDataController *alertData = [SCAlertViewDataController new];
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.backgroundType = Blur;
    alert.shouldDismissOnTapOutside = YES;
    UITextField *textField = [alert addTextField:[alertData setPlaceholderWithRowType:rowType]];
    
    [alert addButton:@"Done" actionBlock:^(void) {
        NSLog(@"Text value: %@", textField.text);
        [alertData updateUserInfoInRow:rowType withText:textField.text ToCompletion:^(BOOL finished){
            if (finished) {
                [SVProgressHUD showSuccessWithStatus:@"succeeded"];
                [self.myTableView.tableView reloadData];
            }
            else{
                [SVProgressHUD showErrorWithStatus:@"failed"];
            }
        }];
    }];
    
    [alert alertIsDismissed:^{
        NSLog(@"SCLAlertView dismissed!");
    }];
    
    [alert showEdit:self title:[alertData setTitleWithRowType:rowType] subTitle:[alertData setSubtitleWithRowType:rowType] closeButtonTitle:nil duration:0.0f];
}


@end
