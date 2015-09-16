//
//  SCLocationManager.m
//  socialCalendar
//
//  Created by Yifan Xiao on 6/22/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class eventObject;
@class SCLocationManager;

@protocol SCLocationManagerDelegate <NSObject>

@optional

/**
 *  Indicates the location manager did update the user location.
 *
 *  @param userLocation The user location.
 */
- (void)locationManagerDidUpdateWithUserLocation:(CLLocation *)userLocation;

/**
 *  Inidcates the location mananger did change his authorization status.
 *
 *  @param status The authorization status.
 */
- (void)locationManagerDidChangeAuthorizationStatus:(CLAuthorizationStatus)status;

@end

@interface SCLocationManager : NSObject

/**
 *  Optional. Last user location retrieve through location manager update.
 */
@property (strong, nonatomic) CLLocation *userLocation;

/**
 *  Required. The view controller that will receive delegation messages.
 */
@property (weak, nonatomic) id<SCLocationManagerDelegate> delegate;

/**
 *  Singleton shared instance method.
 *
 *  @return A new location manager instance at first call, existing instance otherwise.
 */
+ (instancetype)sharedManager;

#pragma mark - Location Authorization Methods

/**
 *  Request user location authorization.
 */
- (void)requestAlwaysAuthorization;

/**
 *  Location user status is authorized.
 *
 *  @return YES if the location authorization status is authorized always or authorized in use. NO if not.
 */
- (BOOL)isStatusAuthorized;

/**
 *  Location user status is not determined.
 *
 *  @return YES if the location authorization status is not determined. NO if not.
 */
- (BOOL)isStatusNotDetermined;

#pragma mark - Location Updates Methods

/**
 *  Start the location manager update.
 */
- (void)startUpdatingLocation;

/**
 *  Stop the location manager update.
 */
- (void)stopUpdatingLocation;

#pragma mark - Maps Methods

/**
 *  Opens Apple Maps and draw a direction from user's position and given store.
 *
 *  Default direction mode is Walking.
 *
 *  @param store The store to go on Apple Maps.
 */
+ (void)openMapsWithStore:(eventObject *)event;

@end
