//
//  SCLocationManager.m
//  socialCalendar
//
//  Created by Yifan Xiao on 6/22/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "SCLocationManager.h"
#import "eventObject.h"

@interface SCLocationManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation SCLocationManager

+ (instancetype)sharedManager
{
    static SCLocationManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [SCLocationManager new];
    });

    return _sharedManager;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

#pragma mark - Location Authorization Methods

- (BOOL)isStatusAuthorized
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse);
}

- (BOOL)isStatusNotDetermined
{
    return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined);
}

- (void)requestAlwaysAuthorization
{
    if (self.locationManager) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

#pragma mark - Location Updates Methods

- (void)startUpdatingLocation
{
    if (self.locationManager && [CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)stopUpdatingLocation
{
    if (self.locationManager) {
        [self.locationManager stopUpdatingLocation];
    }
}

#pragma mark - Maps Methods

+ (void)openMapsWithStore:(eventObject *)event
{
    if (event.location) {

    CLLocationCoordinate2D coordinate;
    coordinate.latitude = event.location.coordinate.latitude;
    coordinate.longitude = event.location.coordinate.longitude;

    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placemark];
    destination.name = event.title;
    NSArray *items = @[destination];
    NSDictionary *launchOptions = @{
        MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
    };
    [MKMapItem openMapsWithItems:items launchOptions:launchOptions];
    }
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // Stop the update location, we only need the user location one time.
    self.userLocation = [locations lastObject];
    [self stopUpdatingLocation];

    if ([self.delegate respondsToSelector:@selector(locationManagerDidUpdateWithUserLocation:)]) {
        [self.delegate locationManagerDidUpdateWithUserLocation:self.userLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if ([self.delegate respondsToSelector:@selector(locationManagerDidChangeAuthorizationStatus:)]) {
        [self.delegate locationManagerDidChangeAuthorizationStatus:status];
    }
}

@end
