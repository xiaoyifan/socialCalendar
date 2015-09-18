//
//  SCSignUpViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/26/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "SCSignUpViewController.h"

@interface SCSignUpViewController ()

@end

@implementation SCSignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.signUpView.logo = logoView; // logo can be any UIView
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
