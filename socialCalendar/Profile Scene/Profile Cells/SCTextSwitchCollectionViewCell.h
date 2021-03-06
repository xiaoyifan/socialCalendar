//
//  LPTextSwitchTableViewCell.h
//  LillyPulitzer
//
//  Created by Pavel Novik on 4/2/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

static NSString *const kTextSwitchCollectionViewCellIdentifier = @"TextSwitchCollectionViewCell";

@class SCTextSwitchCollectionViewCell;

@protocol SCTextSwitchCollectionViewCellDelegate <NSObject>

/**
 *  Indicates when the switch on the cell changes its status.
 *
 *  @param cell         The text switch cell.
 *  @param switchStatus YES if the switch is ON. NO if not.
 */
- (void)textSwitchTableViewCell:(SCTextSwitchCollectionViewCell *)cell switchStatusChanged:(BOOL)switchStatus;

@end

@interface SCTextSwitchCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UISwitch *cellSwitch;

/**
 *  Setup the cell with a title and an switch.
 *
 *  @param delegate The view controller that will receive delegation messages.
 *  @param title    The title to display.
 *  @param switchOn Switch.
 */
- (void)setupWithDelegate:(id<SCTextSwitchCollectionViewCellDelegate>)delegate title:(NSString *)title switchOn:(BOOL)switchOn;

/**
 *  Setup the cell with a title, font size and switch.
 *
 *  @param delegate The view controller that will receive delegation messages.
 *  @param title    The title to display.
 *  @param fontSize The font size to use.
 *  @param switchOn Switch.
 */
- (void)setupWithDelegate:(id <SCTextSwitchCollectionViewCellDelegate>)delegate title:(NSString *)title fontSize:(CGFloat)fontSize switchOn:(BOOL)switchOn;

@end
