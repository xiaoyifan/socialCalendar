//
//  regionSelectionTableViewController.h
//  socialCalendar
//
//  Created by Yifan Xiao on 7/19/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface regionSelectionTableViewController : UIViewController

@property (nonatomic, retain) CLLocation* initialLocation;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) CLLocation* selectedLocation;
@property (strong, nonatomic) NSString* selectedLocationAddress;

@end
