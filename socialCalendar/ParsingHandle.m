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
    [eventQuery whereKey:@"group" equalTo:user];
    
    
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

-(void)findObjectsofDate:(NSDate *)date ToCompletion:(void (^)(NSArray *array))completion{
    
    NSLog(@"date to find: %@", date);
    NSCalendar *calendarCurrent = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendarCurrent components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:1];
    NSDate *morningStart = [calendarCurrent dateFromComponents:components];
    
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    NSDate *tonightEnd = [calendarCurrent dateFromComponents:components];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Events"];
    [query whereKey:@"createdBy" equalTo:[PFUser currentUser]];
    [query whereKey:@"time" greaterThan:morningStart];
    [query whereKey:@"time" lessThan:tonightEnd];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //Etc...
            completion(objects);
        }
    }];
}

-(NSArray *)findObjectsFromNativeCalendarOnDate:(NSDate *)date{
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    NSCalendar *calendarCurrent = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendarCurrent components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:1];
    NSDate *morningStart = [calendarCurrent dateFromComponents:components];
    
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    NSDate *tonightEnd = [calendarCurrent dateFromComponents:components];
    
    
//    NSArray *calendars = [eventStore calendarsForEntityType:EKEntityTypeReminder];
    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:morningStart
                                                                 endDate:tonightEnd
                                                               calendars:nil];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent
                                    completion:^(BOOL granted, NSError *error) {
                                        
                                        NSLog(@"Granted %d", granted);
                                    }];
    
    NSArray *matchingEvents = [eventStore eventsMatchingPredicate:predicate];

    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (EKEvent * event in matchingEvents) {
        [array addObject:[self parseNativeEventToEventObject:event]];
    }
    
    return [array copy];
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
    
    
    PFRelation *groupRelation = [event relationForKey:@"group"];
    
    for (PFUser *user in newObj.group) {
        [groupRelation addObject:user];
    }
    [groupRelation addObject:[PFUser currentUser]];
    
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
    
    retrivedObj.objectId = object.objectId;
    
    return retrivedObj;
}

-(eventObject *)parseNativeEventToEventObject:(EKEvent *)object{

    eventObject *newObj = [[eventObject alloc] init];
    newObj.title = object.title;
    newObj.time = object.startDate;
    newObj.reminderDate = object.endDate;
    newObj.locationDescription = object.location;
    newObj.eventNote = object.notes;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:object.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if([placemarks count]) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            
            newObj.location = location;
            
            CLLocationCoordinate2D coordinate = location.coordinate;
            NSLog(@"coordinate = (%f, %f)", coordinate.latitude, coordinate.longitude);
            
        }
    }];
    
    return newObj;
}


-(void)getAllUsersToCompletion:(void (^)(NSArray *array))completion{
    
    PFQuery *query = [PFUser query];
    
    [query orderByAscending:@"username"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
       
        if (error) {
            NSLog(@"the error is %@", error);
        }
        else{
            completion(array);
        }
    }];
    
}

-(void)getMyFriendsToCompletion:(void (^)(NSArray *array))completion{
    
    if(![PFUser currentUser])
    {
        return;
    }
    
    PFRelation *friendsRelation = [[PFUser currentUser] objectForKey:@"friendRelation"];
    PFQuery *query = [friendsRelation query];
    [query orderByAscending:@"username"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //Etc...
            completion(objects);
        }
        else{
            NSLog(@"the error is %@", error);
        }
    }];
    
}

-(void)getMyPendingReceivedRequestToCompletion:(void (^)(NSArray *array))completion{
    
    if(![PFUser currentUser])
    {
        return;
    }
    
    PFQuery * query = [PFQuery queryWithClassName:@"friendRequest"];
    [query includeKey:@"from"];
    [query whereKey:@"to" equalTo:[PFUser currentUser]];
    [query whereKey:@"status" equalTo:@"pending"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"error info %@", error);
        }
        else {
            completion(objects);
        }
    

    }];
}


-(void)getMyPendingSentRequestToCompletion:(void (^)(NSArray *array))completion{
    
    if(![PFUser currentUser])
    {
        return;
    }
    
    PFQuery * query = [PFQuery queryWithClassName:@"friendRequest"];
    [query whereKey:@"from" equalTo:[PFUser currentUser]];
    [query whereKey:@"status" equalTo:@"pending"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"error info %@", error);
        }
        else {
            
            NSLog(@"%lu requests sent", (unsigned long)objects.count);
            completion(objects);
        }
        
        
    }];
}


-(void)sendUserFriendRequest:(PFUser *)user{
    
    PFObject *request = [PFObject objectWithClassName:@"friendRequest"];
    request[@"from"]  =[PFUser currentUser];
    request[@"to"] = user;
    request[@"status"] = @"pending";
    
    [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (!succeeded) {
            NSLog(@"the error is %@", error);
        }
    }];
}


-(void)approvedFriendRequestFrom:(PFUser *)user{
    
    PFRelation *friendRelation = [[PFUser currentUser] relationForKey:@"friendRelation"];
    
    [friendRelation addObject:user];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (!succeeded) {
            NSLog(@"the error is %@", error);
        }
    }];

}

-(void)getApprovedUsersToCompletion:(void (^)(NSArray *array))completion{
    
    if(![PFUser currentUser])
    {
        return;
    }
    PFQuery * query = [PFQuery queryWithClassName:@"friendRequest"];
    [query whereKey:@"from" equalTo:[PFUser currentUser]];
    [query whereKey:@"status" equalTo:@"approved"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"error info %@", error);
        }
        else {
            NSLog(@"%lu requests sent", (unsigned long)objects.count);
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (PFObject *request in objects) {
                PFUser *user = request[@"to"];
                [array addObject:user];
                PFRelation *friendRelation = [[PFUser currentUser] relationForKey:@"friendRelation"];
                [friendRelation addObject:user];
                [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                    if (!succeeded) {
                        NSLog(@"the error is %@", error);
                    }
                }];
                [request deleteEventually];
            }
            completion(array);
        }
    }];
}

-(void)deleteEventFromCloudByID:(NSString *)objectId ToCompletion:(void (^)())completion{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Events"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:objectId
                                 block:^(PFObject *eventObj, NSError *error) {
                                     [eventObj deleteInBackground];
                                     completion();
                                 }];
}

@end

