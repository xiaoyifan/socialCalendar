//
//  LPStoreMapController.h
//  LillyPulitzer
//
//  Created by Thomas on 6/26/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class eventObject;

@interface SCEventMapController : NSObject

/**
 *  The map view.
 */
@property (strong, nonatomic) MKMapView *mapView;

/**
 *  Init the Store Map Controller with a specific frame.
 *
 *  @param frame  The frame of the map controller map view.
 *
 *  @return An instance of Store Map Controller.
 */
- (instancetype)initWithStores:(NSArray *)events;

@end
