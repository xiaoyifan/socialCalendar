//
//  profileViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/17/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "profileViewController.h"


@interface profileViewController ()

@end

@implementation profileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MBTwitterScroll *myTableView = [[MBTwitterScroll alloc]
                                    initTableViewWithBackgound:[UIImage imageNamed:@"background"]
                                    avatarImage:[UIImage imageNamed:@"avatar.png"]
                                    titleString:@"Yifan Xiao"
                                    subtitleString:@"xiaoyifan@uchicago.edu"
                                    buttonTitle:nil];  // Set nil for no button
    
    myTableView.tableView.delegate = self;
    myTableView.tableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

-(void) recievedMBTwitterScrollEvent {

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text =  @"Cell";
    
    return cell;
}

@end
