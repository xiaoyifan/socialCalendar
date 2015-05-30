//
//  ParsingHandle.m
//  socialCalendar
//
//  Created by Yifan Xiao on 5/29/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "ParsingHandle.h"

@implementation ParsingHandle

+(id)sharedParsing{
    
    static dispatch_once_t pred;
    static ParsingHandle *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

-(void)findObjectsOfCurrentUserToCompletion:(void (^)(NSArray *))completion{
    
    [self findObjectsOfUser:[PFUser currentUser] ToCompletion:completion];
}

-(void)findObjectsOfUser:(PFUser *)user ToCompletion:(void(^)(NSArray *array))completion{
    
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Events"];
    [eventQuery whereKey:@"createdBy" equalTo:user];
    
    
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu events.", (unsigned long)objects.count);
          
            completion(objects);
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}


-(void)insertNewObjectToDatabase:(eventObject *)newObj createdBy:(PFUser *)user{
    
    PFObject *event= [PFObject objectWithClassName:@"Events"];
    
    event[@"title"] = newObj.title;
    event[@"time"] = newObj.time;
    event[@"reminderDate"]  =newObj.reminderDate;
    
    PFGeoPoint *point = [PFGeoPoint geoPointWithLocation:newObj.location];
    
    event[@"location"] = point;
    event[@"locationDescription"] = newObj.locationDescription;
    event[@"eventNote"] = newObj.eventNote;
    
    [event setObject:user forKey:@"createdBy"];
    
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            // The object has been saved.
            NSLog(@"%@", error);
        }
    }];

}

-(void)insertNewObjectToDatabase:(eventObject *)newObj{
    
    [self insertNewObjectToDatabase:newObj createdBy:[PFUser currentUser]];
}


-(eventObject *)parseObjectToEventObject:(PFObject *)object{
    
    eventObject *retrivedObj = [[eventObject alloc] init];
    retrivedObj.title = [object objectForKey:@"title"];
    retrivedObj.time = [object objectForKey:@"time"];
    retrivedObj.reminderDate = [object objectForKey:@"reminderDate"];
    
    PFGeoPoint *point = [object objectForKey:@"location"];
    retrivedObj.location = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
    
    retrivedObj.locationDescription = [object objectForKey:@"locationDescription"];
    retrivedObj.eventNote = [object objectForKey:@"eventNote"];
    
    
    return retrivedObj;
}


@end
