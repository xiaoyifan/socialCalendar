//
//  SCLoginViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/26/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "SCLoginViewController.h"

@interface SCLoginViewController ()

@end

@implementation SCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.logInView.logo = logoView; // logo can be any UIView
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
