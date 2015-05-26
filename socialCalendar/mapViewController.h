//
//  mapViewController.h
//  FinalSketch
//
//  Created by xiaoyifan on 3/2/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyLocation.h"

@interface mapViewController : UIViewController<UIGestureRecognizerDelegate, CLLocationManagerDelegate>

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) CLLocation* initialLocation;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) CLLocation* selectedLocation;
@property (strong, nonatomic) NSString* selectedLocationAddress;


@end
