//
//  LPNetworkingManager.h
//  LillyPulitzer
//
//  Created by Thomas on 4/30/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPNetworkingManager : NSObject

/**
 *  Singleton shared instance method.
 *
 *  @return A new networking manager instance at first call, existing instance otherwise.
 */
+ (instancetype)sharedManager;

/**
 *  Method to know if the network is reachable or not
 *
 *  @return boolean value, if yes the network is reachable
 */
- (BOOL)isReachable;


@property (assign, nonatomic) BOOL didStartMonitoring;

@end
