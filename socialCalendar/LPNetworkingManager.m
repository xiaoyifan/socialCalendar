//
//  LPNetworkingManager.m
//  LillyPulitzer
//
//  Created by Thomas on 4/30/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "LPBannerView.h"
#import "LPNetworkingManager.h"

#import <AFNetworking/AFNetworking.h>


@implementation LPNetworkingManager

+ (instancetype)sharedManager
{
    static LPNetworkingManager *networkingManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkingManager = [LPNetworkingManager new];
    });
    return networkingManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock: ^(AFNetworkReachabilityStatus status) {
            self.didStartMonitoring = YES;
            //DLog( @"Reachability: %@", AFStringFromNetworkReachabilityStatus(status) );

            if (status == AFNetworkReachabilityStatusNotReachable) {
                [LPBannerView showMessage:@"The network is lost"];
            } else {
                [LPBannerView hideBanner];
            }
        }];

        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

- (BOOL)isReachable
{
    return ([AFNetworkReachabilityManager sharedManager] && self.didStartMonitoring) ?  [AFNetworkReachabilityManager sharedManager].reachable : YES;
}

@end
