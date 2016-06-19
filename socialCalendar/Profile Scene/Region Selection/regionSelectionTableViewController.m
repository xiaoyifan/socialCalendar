//
//  regionSelectionTableViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/19/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "regionSelectionTableViewController.h"

@interface regionSelectionTableViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *regionLabel;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLGeocoder *geoCoder;

@end

@implementation regionSelectionTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;

    self.geoCoder = [[CLGeocoder alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];

    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        float spanX = 0.00725;
        float spanY = 0.00725;
        MKCoordinateRegion region;
        region.center.latitude = self.mapView.userLocation.coordinate.latitude;
        region.center.longitude = self.mapView.userLocation.coordinate.longitude;
        NSLog(@"My location %f, %f", region.center.latitude, region.center.longitude);

        region.span.latitudeDelta = spanX;
        region.span.longitudeDelta = spanY;
        [self.mapView setRegion:region animated:YES];
        [self getLocationDescription];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loacation serice not authorized" message:@"This app needs you to authorize locations service to work" delegate:nil cancelButtonTitle:@"Gotcha" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveCurrentLocation:(id)sender
{
    [[FirebaseManager sharedInstance] updateUser:[PFUser currentUser] Location:self.regionLabel.text ToCompletion: ^(BOOL finished) {
        if (finished) {
            [SVProgressHUD showSuccessWithStatus:@"saved"];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"could not updated"];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager setDistanceFilter:100];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager setHeadingFilter:kCLDistanceFilterNone];
        self.locationManager.activityType = CLActivityTypeFitness;

        [self.locationManager startUpdatingLocation];
    } else if (status == kCLAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loacation serice not authorized" message:@"This app needs you to authorize locations service to work" delegate:nil cancelButtonTitle:@"Gotcha" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        NSLog(@"wrong location status");
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!self.initialLocation) {
        self.initialLocation = userLocation.location;
        [self getLocationDescription];
        MKCoordinateRegion region;
        region.center = mapView.userLocation.coordinate;
        region.span = MKCoordinateSpanMake(0.1, 0.1);

        region = [mapView regionThatFits:region];
        [mapView setRegion:region animated:YES];
    }
}

- (void)getLocationDescription
{
    [self.geoCoder reverseGeocodeLocation:self.initialLocation completionHandler: ^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks lastObject];
            self.selectedLocationAddress = [NSString stringWithFormat:@"%@, %@, %@",
                                            (placemark.locality) ? placemark.locality : @"",
                                            (placemark.administrativeArea) ? placemark.administrativeArea : @"",
                                            (placemark.country) ? placemark.country : @""];

            self.regionLabel.text = self.selectedLocationAddress;
            [SVProgressHUD showSuccessWithStatus:@"location updated"];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    }];
}

@end
