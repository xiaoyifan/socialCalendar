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
#import "ZFModalTransitionAnimator.h"

@interface profileViewController ()

@property (nonatomic,strong) MBTwitterScroll* myTableView;

@property (nonatomic, strong) ZFModalTransitionAnimator *animator;

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

-(void)viewDidAppear:(BOOL)animated{
    [self.myTableView.tableView reloadData];
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
        case SCUserDetailModuleTypeWhatsUp:
            //show the pop up to set the value
            [self showPopupWithTextInRowtype:indexPath.row];
            break;
            
        case SCUserDetailModuleTypeGender:
            //push to view controller with gender selection
            [self setPopupToUpdateGender];
            break;
            
        case SCUserDetailModuleTypeRegion:
            [self pushToSetNewRegion];
            //push to view controlleer with map and location
            
            break;
            
        default:
            break;
    }
}


- (void)pushToSetNewRegion{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Region" bundle:nil];
        UINavigationController *regionVC = [storyboard instantiateViewControllerWithIdentifier:@"regionViewController"];
    
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:regionVC];
    self.animator.dragable = NO;
    self.animator.bounces = NO;
    self.animator.behindViewAlpha = 0.5f;
    self.animator.behindViewScale = 0.5f;
    self.animator.transitionDuration = 0.7f;
    self.animator.direction = ZFModalTransitonDirectionBottom;
    
    regionVC.transitioningDelegate = self.animator;
    [self presentViewController:regionVC animated:YES completion:nil];
}


- (void)setPopupToUpdateGender{
    
    SCAlertViewDataController *alertData = [SCAlertViewDataController new];
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.backgroundType = Blur;
    
    [alert addButton:@"Male" actionBlock:^(void) {
        [alertData updateUserInfoInRow:SCUserDetailModuleTypeGender withText:@"male" ToCompletion:^(BOOL finished){
            if (finished) {
                [SVProgressHUD showSuccessWithStatus:@"succeeded"];
                [self.myTableView.tableView reloadData];
            }
            else{
                [SVProgressHUD showErrorWithStatus:@"failed"];
            }
        }];
    }];
    [alert addButton:@"Female" actionBlock:^(void) {
        [alertData updateUserInfoInRow:SCUserDetailModuleTypeGender withText:@"female" ToCompletion:^(BOOL finished){
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
    
    [alert showEdit:self title:@"Gender" subTitle:@"Select your gender" closeButtonTitle:nil duration:0.0f];
}

- (void)showPopupWithTextInRowtype:(SCUserDetailModuleType)rowType
{
    
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
    
    [alert showEdit:self title:[alertData setTitleWithRowType:rowType] subTitle:[alertData setSubtitleWithRowType:rowType] closeButtonTitle:nil duration:0.0f];
}


@end
