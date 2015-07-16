//
//  detailViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 5/28/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "detailViewController.h"

@interface detailViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *cardView;

@property (weak, nonatomic) IBOutlet UILabel *eventLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;

@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *initialLocation;
//constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;


@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end

@implementation detailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cardView.backgroundColor = self.cardBackgroundColor;
    // Do any additional setup after loading the view.


    self.eventLabel.text = self.detailObject.title;

    NSDateFormatter *dateformat = [[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"dd-MMM-YYYY HH:mm"];

    dateformat.timeZone = [NSTimeZone localTimeZone];

    NSString *eventTime = [dateformat stringFromDate:self.detailObject.time];

    self.timeLabel.text = [NSString stringWithFormat:@"%@ EVENT TIME", eventTime];

    NSString *remindTime = [dateformat stringFromDate:self.detailObject.reminderDate];
    self.reminderLabel.text = [NSString stringWithFormat:@"%@ REMIND TIME", remindTime];

    self.noteLabel.text = self.detailObject.eventNote;

    if (self.detailObject.locationDescription != nil) {
        self.locationLabel.text = self.detailObject.locationDescription;
    } else {
        self.locationLabel.text = @"the location is not provided";
    }

    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    NSLog(@"log out the location %@", self.detailObject.location);
}

- (void)viewWillLayoutSubviews
{
    CGFloat scrollViewHeight = 0.0f;
    for (UIView *view in self.mainScrollView.subviews) {
        scrollViewHeight += view.frame.size.height;
    }

    scrollViewHeight += 50;

    NSLog(@"the HEIGHT %f", scrollViewHeight);

    [self.scrollViewHeight setConstant:scrollViewHeight];
    [self.mainScrollView setContentSize:CGSizeMake(self.view.frame.size.width, scrollViewHeight)];

    [self.mainScrollView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

/*
   #pragma mark - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }
 */


#pragma mark - location service implementation

- (IBAction)myLocation:(id)sender
{
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
    NSLog(@"self location: %@", self.detailObject.location);
    if (!self.initialLocation) {
        MKCoordinateRegion region;
        if (!self.detailObject.location) {
            self.initialLocation = self.mapView.userLocation.location;
            region.center = self.mapView.userLocation.location.coordinate;
        } else {
            self.initialLocation = self.detailObject.location;
            region.center = self.detailObject.location.coordinate;
        }

        region.span = MKCoordinateSpanMake(0.1, 0.1);

        region = [mapView regionThatFits:region];
        [mapView setRegion:region animated:YES];

        MyLocation *annotation = [[MyLocation alloc] initWithName:[NSString stringWithFormat:@"%@", self.detailObject.title]
                                                          address:self.detailObject.locationDescription
                                                       coordinate:self.detailObject.location.coordinate];



        [self.mapView addAnnotation:annotation];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"MyLocation";

    if ([annotation isKindOfClass:[MyLocation class]]) {
        MyLocation *location = (MyLocation *)annotation;
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"%@ %@", view, control);
}

#pragma mark-geo fencing
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"Exit Regions:%@", region);
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Goodbye";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Enter region:%@", region);
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Hello";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

@end
