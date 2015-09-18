//
//  CSStickyParallaxHeaderViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/17/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "profileViewController.h"
#import "SCProfileInfoCell.h"
#import "CSSectionHeader.h"
#import "CSStickyHeaderFlowLayout.h"
#import "ZFModalTransitionAnimator.h"
#import "profileHeader.h"
#import "TOCropViewController.h"

@interface profileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate>

@property (nonatomic, strong) UINib *headerNib;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property (nonatomic, strong) profileHeader *profileHeader;


@property (weak, nonatomic) SCTextSwitchCollectionViewCell *notificationSwitchCell;

@end

@implementation profileViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

        self.headerNib = [UINib nibWithNibName:@"profileHeader" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNibs];

    [self reloadLayout];

    // Also insets the scroll indicator so it appears below the search bar
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);

    [self.collectionView registerNib:self.headerNib
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:@"header"];

}

-(void)viewDidAppear:(BOOL)animated{
    
    [self.collectionView reloadData];
}

-(void)registerNibs{
    
    [self.collectionView registerNib:[UINib nibWithNibName:kProfileInfoCellNibName bundle:nil] forCellWithReuseIdentifier:kProfileInfoCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:kTextSwitchCellNibName bundle:nil] forCellWithReuseIdentifier:kTextSwitchCellIdentifier];

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self reloadLayout];
}

- (void)reloadLayout {

    CSStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;

    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 426);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, 110);
        layout.itemSize = CGSizeMake(self.view.frame.size.width, layout.itemSize.height+10);
        layout.parallaxHeaderAlwaysOnTop = YES;

        // If we want to disable the sticky header effect
        layout.disableStickyHeaders = YES;
    }

}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return SCUserAccountTypeCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == SCUserAccountTypeDetail) {
        return SCUserDetailModuleTypeCount;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell = nil;
    
    if (indexPath.section == SCUserAccountTypeDetail) {
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProfileInfoCellIdentifier forIndexPath:indexPath];
    [(SCProfileInfoCell *)cell setupWithUser:[PFUser currentUser] withRowType:indexPath.row];
    }
    else if (indexPath.section == SCUserAccountTypeNotifications){
    
        cell = (SCTextSwitchCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kTextSwitchCellIdentifier forIndexPath:indexPath];
        self.notificationSwitchCell = (SCTextSwitchCollectionViewCell *)cell;
        [( (SCTextSwitchCollectionViewCell *)cell ) setupWithDelegate:self title:@"Notifications" switchOn:[SCHelperMethods isRegisteredFromRemoteNotifications]];
        
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == SCUserAccountTypeDetail)
    {
        switch (indexPath.row)
        {
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
}


#pragma mark -- Collection View header settings method
//Default header configuration method, no need to modify it for now.
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        CSSectionHeader *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:@"sectionHeader"
                                                                 forIndexPath:indexPath];
        if (indexPath.section == 1) {
            cell.textLabel.text = @"NOTIFICATION";
        }

        return cell;

    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        profileHeader *cell = (profileHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"header"
                                                                                   forIndexPath:indexPath];

        cell.delegate = self;
        self.profileHeader = cell;
        
        return cell;
    }
    return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
                [self.collectionView reloadData];
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
                [self.collectionView reloadData];
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
                [self.collectionView reloadData];
            }
            else{
                [SVProgressHUD showErrorWithStatus:@"failed"];
            }
        }];
    }];
    
    [alert showEdit:self title:[alertData setTitleWithRowType:rowType] subTitle:[alertData setSubtitleWithRowType:rowType] closeButtonTitle:nil duration:0.0f];
}


#pragma mark -- UISwitchDelegate In Notification Cell

- (void)textSwitchTableViewCell:(SCTextSwitchCollectionViewCell *)cell switchStatusChanged:(BOOL)switchStatus
{
    
    if (switchStatus && ![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        [self showPushNotificationActivationAlert];
    } else {
        [self showPushNotificationDeactivationAlert];
    }
}

#pragma mark - UIAlertView Methods

- (void)showPushNotificationActivationAlert
{
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kPushNotificationActivationAlertTitle
                                                                             message:kPushNotificationOnAlertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kCancelButtonTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler: ^(UIAlertAction *action) {
                                                             [weakSelf.notificationSwitchCell.cellSwitch setOn:NO animated:YES];
                                                             [alertController dismissViewControllerAnimated:YES completion:nil];
                                                         }];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Settings"
                                                             style:UIAlertActionStyleDefault
                                                           handler: ^(UIAlertAction *action) {
                                                               [SCHelperMethods openSettings];
                                                           }];
    [alertController addAction:cancelAction];
    [alertController addAction:settingsAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showPushNotificationDeactivationAlert
{
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kPushNotificationDeactivationAlertTitle
                                                                             message:kPushNotificationOffAlertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Settings"
                                                           style:UIAlertActionStyleCancel
                                                         handler: ^(UIAlertAction *action) {
                                                             [SCHelperMethods openSettings];
                                                         }];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Not now"
                                                             style:UIAlertActionStyleDefault
                                                           handler: ^(UIAlertAction *action) {
                                                               [weakSelf.notificationSwitchCell.cellSwitch setOn:YES animated:YES];
                                                               
                                                           }];
    [alertController addAction:cancelAction];
    [alertController addAction:settingsAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void)tapToShowPhotoGallery{
    NSLog(@"camera tapped");
    UIImagePickerController *photoPickerController = [[UIImagePickerController alloc] init];
    photoPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPickerController.allowsEditing = NO;
    photoPickerController.delegate = self;
    [self presentViewController:photoPickerController animated:YES completion:nil];
}


#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    self.profileHeader.avatarImageView.image = image;
    self.profileHeader.avaratBackImageView.image = image;

    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    CGRect viewFrame = [self.view convertRect:self.profileHeader.avatarImageView.frame toView:self.navigationController.view];
    self.profileHeader.avatarImageView.hidden = YES;
    [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:viewFrame completion:^{
        self.profileHeader.avatarImageView.hidden = NO;
    }];
}

#pragma mark - Image Picker Delegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:^{
        //self.image = image;
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
        cropController.delegate = self;
        [self presentViewController:cropController animated:YES completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
