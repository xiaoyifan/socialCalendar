//
//  UIView+LoadNib.h
//  LillyPulitzer
//
//  Created by Thibault Klein on 4/16/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LoadNib)

/**
 *  Load a nib file with given name and class.
 *
 *  @param nibName  The nib name.
 *  @param objClass The class assiociated with the nib.
 *  @param owner    The owner.
 *
 *  @return         The nib file.
 */
+ (id)loadNibNamed:(NSString *)nibName ofClass:(Class)objClass owner:(id)owner;

@end
