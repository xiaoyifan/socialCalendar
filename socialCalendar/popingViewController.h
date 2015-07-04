//
//  ModalViewController.h
//  Popping
//
//  Created by André Schneider on 16.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol senddataProtocol <NSObject>

-(void)sendDataToSource; //I am thinking my data is NSArray, you can use another object for store your information.

@end

@interface popingViewController : UIViewController

@property(nonatomic,assign) id delegate;

@end
