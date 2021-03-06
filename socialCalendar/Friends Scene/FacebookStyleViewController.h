//
//  FacebookStyleViewController.h
//  BLKFlexibleHeightBar Demo
//
//  Created by Bryan Keller on 3/7/15.
//  Copyright (c) 2015 Bryan Keller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HexColors.h"

@interface FacebookStyleViewController : UIViewController

@property NSMutableArray *friendsArray;

@property NSMutableArray *requestArray;

@property NSMutableArray *requestObjectArray;

@property NSMutableArray *dataArray;


@property (nonatomic, strong) PFRelation *friendsRelation;

@end
