//
//  LPTextSwitchTableViewCell.m
//  LillyPulitzer
//
//  Created by Pavel Novik on 4/2/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "SCTextSwitchTableViewCell.h"

@interface SCTextSwitchTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleCellLabel;
@property (weak, nonatomic) id <SCTextSwitchTableViewCellDelegate> delegate;

@end

@implementation SCTextSwitchTableViewCell

#pragma mark - Public Method

- (void)setupWithDelegate:(id <SCTextSwitchTableViewCellDelegate>)delegate title:(NSString *)title switchOn:(BOOL)switchOn
{
    self.delegate = delegate;
    self.titleCellLabel.text = title;
    self.cellSwitch.on = switchOn;
}

- (void)setupWithDelegate:(id <SCTextSwitchTableViewCellDelegate>)delegate title:(NSString *)title fontSize:(CGFloat)fontSize switchOn:(BOOL)switchOn
{
    self.titleCellLabel.font = [UIFont systemFontOfSize:fontSize];
    [self setupWithDelegate:delegate title:title switchOn:switchOn];
}

- (IBAction)switchStatusChanged:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(textSwitchTableViewCell:switchStatusChanged:)]) {
        [self.delegate textSwitchTableViewCell:self switchStatusChanged:self.cellSwitch.isOn];
    }
}

@end
