//
//  LPStoreMapController.m
//  LillyPulitzer
//
//  Created by Thomas on 6/26/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "SCEventMapController.h"
#import "eventObject.h"

static CGFloat const kMapAltitude = 1000.0f;

@interface SCEventMapController () <MKMapViewDelegate>

@property (assign, nonatomic) UIEdgeInsets mapEdgePadding;
@property (strong, nonatomic) NSArray *events;

@end

@implementation SCEventMapController

#pragma mark - Public Methods

- (instancetype)initWithStores:(NSArray *)events
{
    self = [super init];
    if (self) {
        _mapView = [MKMapView new];
        _events = events;
        [self setupMap];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupMap
{
    self.mapView.delegate = self;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = NO;
    self.mapView.showsUserLocation = YES;

    [self removeAllMapAnnotations];

    eventObject *obj = [self.events objectAtIndex:0];

    if (obj.location) {
        [self addStoreAnnotations];
        [self zoomMapToFitAnnotations];
    } else {
        [self addUserAnnotation];
    }
}

#pragma mark - MKMapKit Methods

- (void)removeAllMapAnnotations
{
    MKUserLocation *userAnnotation = self.mapView.userLocation;
    NSMutableArray *annotations = [NSMutableArray arrayWithArray:self.mapView.annotations];
    [annotations removeObject:userAnnotation];
    [self.mapView removeAnnotations:annotations];
}

- (void)addUserAnnotation
{
    MyLocation *annotation = [[MyLocation alloc] initWithName:[NSString stringWithFormat:@"%@", @"My Location"]
                                                      address:nil
                                                   coordinate:self.mapView.userLocation.coordinate];

    [self.mapView addAnnotation:annotation];
}

- (void)addStoreAnnotations
{
    for (eventObject *event in self.events) {
        MyLocation *annotation = [[MyLocation alloc] initWithName:[NSString stringWithFormat:@"%@", event.title]
                                                          address:event.locationDescription
                                                       coordinate:event.location.coordinate];

        [self.mapView addAnnotation:annotation];
    }
}

- (void)zoomMapToFitAnnotations
{
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    self.mapView.camera.altitude = kMapAltitude;
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation> )annotation
{
    if ([annotation isEqual:mapView.userLocation]) {
        return nil;
    }

    static NSString *const annotationViewIdentifier = @"MyLocation";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewIdentifier];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:annotationViewIdentifier];
    }

    annotationView.pinColor = MKPinAnnotationColorPurple;
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;

    return annotationView;
}

@end
