//
//  SCEventNameTableViewCell.m
//  socialCalendar
//
//  Created by Yifan Xiao on 6/30/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "SCEventNameTableViewCell.h"
#import "eventObject.h"

@interface SCEventNameTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation SCEventNameTableViewCell

- (void)setupWithEvent:(eventObject *)event
{
    self.nameLabel.text = event.title;
}

@end
