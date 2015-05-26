//
//  mapViewController.m
//  FinalSketch
//
//  Created by xiaoyifan on 3/2/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import "mapViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface mapViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) CLGeocoder *geoCoder;


@end

@implementation mapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    self.geoCoder = [[CLGeocoder alloc] init];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - location service implementation

- (IBAction)myLocation:(id)sender {
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = self.mapView.userLocation.coordinate.longitude;
    NSLog(@"My location %f, %f", region.center.latitude, region.center.longitude);
    
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse|| status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager setDistanceFilter:100];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager setHeadingFilter:kCLDistanceFilterNone];
        self.locationManager.activityType = CLActivityTypeFitness;
        
        [self.locationManager startUpdatingLocation];
    }
    else if(status == kCLAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loacation serice not authorized" message:@"This app needs you to authorize locations service to work" delegate:nil cancelButtonTitle:@"Gotcha" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else{
        NSLog(@"wrong location status");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray
                                                                         *)locations
{
    NSLog(@"%@", locations);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError
                                                                       *)error
{
    NSLog(@"Could not find location: %@", error);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if ( !self.initialLocation )
    {
        self.initialLocation = userLocation.location;
        
        MKCoordinateRegion region;
        region.center = mapView.userLocation.coordinate;
        region.span = MKCoordinateSpanMake(0.1, 0.1);
        
        region = [mapView regionThatFits:region];
        [mapView setRegion:region animated:YES];
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    static NSString *identifier = @"MyLocation";
    
    if ([annotation isKindOfClass:[MyLocation class]]) {
        
        MyLocation *location = (MyLocation *) annotation;
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [theMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:location reuseIdentifier:identifier];
        } else {
            annotationView.annotation = location;
        }
        
        // Set the pin properties
        annotationView.animatesDrop = YES;
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return annotationView;
    }
    
    return nil;
}


- (IBAction)mapViewLongTapToDropPin:(UILongPressGestureRecognizer *)sender {
    
    NSLog(@"The map view is tapped");
    CGPoint point = [sender locationInView:self.mapView];
    CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    // Then all you have to do is create the annotation and add it to the map
    
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = locCoord.latitude;
    coordinates.longitude =locCoord.longitude;
    
    for (MyLocation *annotation in self.mapView.annotations) {
        
        if ((annotation.coordinate.latitude == coordinates.latitude)&&(annotation.coordinate.longitude == coordinates.longitude) ) {
            return;
        }
        else{
            [self.mapView removeAnnotation:annotation];
            MyLocation *annotation = [[MyLocation alloc] initWithName:@"Address selected" address:@"" coordinate:coordinates];
            [self.mapView addAnnotation:annotation];
            
            if ( !self.selectedLocation )
            {
                self.selectedLocation = [[CLLocation alloc] initWithLatitude:coordinates.latitude longitude:coordinates.longitude];
                
                [self.geoCoder reverseGeocodeLocation:self.selectedLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                    NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
                    if (error == nil && [placemarks count] > 0) {
                        CLPlacemark *placemark = [placemarks lastObject];
                        self.selectedLocationAddress = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",
                                                (placemark.subThoroughfare)?placemark.subThoroughfare:@"",
                                                (placemark.thoroughfare)?placemark.thoroughfare:@"",
                                                (placemark.postalCode)?placemark.postalCode:@"",
                                                (placemark.locality)?placemark.locality:@"",
                                                (placemark.administrativeArea)?placemark.administrativeArea:@"",
                                                (placemark.country)?placemark.country:@""];
                    } else {
                        NSLog(@"%@", error.debugDescription);
                    }
                } ];

            
            }
            //Update the selected location
        }
        
    }
    //long tap to add the droppin in the mapView
    //the pin won't be added to the same point twice
    
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"%@ %@",view,control);
}


#pragma mark-geo fencing
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"Exit Regions:%@",region);
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Goodbye";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Enter region:%@",region);
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Hello";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
