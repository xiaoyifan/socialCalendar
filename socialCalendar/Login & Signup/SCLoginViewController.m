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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.logInView.logo = logoView; // logo can be any UIView
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
