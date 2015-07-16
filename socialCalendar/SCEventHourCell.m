//
//  SCEventHourCell.m
//  socialCalendar
//
//  Created by Yifan Xiao on 6/28/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "SCEventHourCell.h"

@interface SCEventHourCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;

@end

@implementation SCEventHourCell

#pragma mark - Public Methods

- (void)setupCellWithTime:(NSDate *)time withTitle:(NSString *)title;
{
    self.titleLabel.text = title;
    self.hourLabel.text = [self formattedDate:time];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (NSString *)formattedDate:(NSDate *)date
{
    NSDateFormatter *dateformat = [[NSDateFormatter alloc]init];
    [dateformat setDateFormat:kDatePresentingFormat];

    dateformat.timeZone = [NSTimeZone localTimeZone];

    return [dateformat stringFromDate:date];
}

@end
