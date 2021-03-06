//
//  SCProfileInfoCell.h
//  socialCalendar
//
//  Created by Yifan Xiao on 7/18/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eventObject;

@interface SCProfileInfoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


/**
 *  Setup the related row with specific event.
 *
 *  @param user The specific user.
 *  @param row   The row type.
 */
-(void)setupWithUser:(User *)user withRowType:(SCUserDetailModuleType)rowtype;

@end
