//
//  calendarTableViewCell.h
//  socialCalendar
//
//  Created by Yifan Xiao on 5/31/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface calendarTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *eventTime;

@property (weak, nonatomic) IBOutlet UILabel *separator;

@property (weak, nonatomic) IBOutlet UILabel *eventTitle;

@end
