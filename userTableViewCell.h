//
//  userTableViewCell.h
//  socialCalendar
//
//  Created by Yifan Xiao on 6/4/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *username;

@property (weak, nonatomic) IBOutlet UILabel *mailaddress;


@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end
