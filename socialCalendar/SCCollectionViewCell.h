//
//  LPCollectionViewCell.h
//  LillyPulitzer
//
//  Created by Pavel Novik on 5/13/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCCollectionViewCell : UICollectionViewCell

/**
 *  Optional: Show top full width border.
 */
@property (assign, nonatomic) BOOL showTopFullWidthBorder;

/**
 *  Optional: Show bottom full width border.
 */
@property (assign, nonatomic) BOOL showBottomFullWidthBorder;

/**
 *  Optional: Show bottom row seperator border.
 */
@property (assign, nonatomic) BOOL showBottomRowSeperatorBorder;

/**
 *  Show bottom row seperator border with custom x position.
 *
 *  @param xOrigin The x origin.
 */
- (void)showBottomRowSeperatorBorderWithXOrigin:(CGFloat)xOrigin;

@end
