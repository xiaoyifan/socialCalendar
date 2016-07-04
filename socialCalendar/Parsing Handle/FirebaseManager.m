//
//  ParsingHandle.m
//  socialCalendar
//
//  Created by Yifan Xiao on 5/29/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "FirebaseManager.h"

@interface FirebaseManager ()

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation FirebaseManager

+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static FirebaseManager *shared = nil;

    dispatch_once(&pred, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _ref = [[FIRDatabase database] reference];
    }
    return self;
}


- (void)findObjectsOfCurrentUserToCompletion:( void (^)(eventObject * obj) )completion
{
    [self findObjectsOfUser:[FIRAuth auth].currentUser ToCompletion:completion];
}

- (void)findObjectsOfUser:(FIRUser *)user ToCompletion:( void (^)(eventObject *) )completion
{
    [[[[self.ref child:@"user-event"]  child:user.uid] queryOrderedByChild:@"time"]
        observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            completion([self parseObjectToEventObject:snapshot.value]);
            
        }];
    
    
    
}

//get the events online
- (void)findObjectsofDate:(NSDate *)date ToCompletion:( void (^)(eventObject * obj) )completion
{
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

    
    FIRDatabaseQuery * userEventQuery = [[[self.ref child:@"user-event"]  child:[FIRAuth auth].currentUser.uid] queryOrderedByChild:@"time"];
    
    FIRDatabaseQuery * todayQuery =[[userEventQuery queryStartingAtValue:[NSNumber numberWithInt:[morningStart timeIntervalSince1970]] childKey:@"time"] queryEndingAtValue:[NSNumber numberWithInt:[tonightEnd timeIntervalSince1970]] childKey:@"time"];
    
    [todayQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        completion([self parseObjectToEventObject:snapshot.value]);
        
    }];
    
}

//query the local events from event kit
- (NSArray *)findObjectsFromNativeCalendarOnDate:(NSDate *)date
{
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
                               completion: ^(BOOL granted, NSError *error) {
        NSLog(@"Granted %d", granted);
    }];

    NSArray *matchingEvents = [eventStore eventsMatchingPredicate:predicate];


    NSMutableArray *array = [[NSMutableArray alloc] init];

    for (EKEvent *event in matchingEvents) {
        [array addObject:[self parseNativeEventToEventObject:event]];
    }

    return [array copy];
}


- (void)insertNewObjectToDatabase:(eventObject *)newObj createdBy:(FIRUser *)user ToCompletion:( void (^)(NSError *error) )completion
{
    PFGeoPoint *point = [PFGeoPoint geoPointWithLocation:newObj.location];
    
    NSDictionary *locationDict = @{
                                   @"lati": [NSNumber numberWithDouble:point.latitude],
                                   @"long": [NSNumber numberWithDouble:point.longitude]
                                   };

    
    FIRDatabaseReference *messageRef = [self.ref child:@"events"];
    NSString *newKey = [messageRef childByAutoId].key;
    
    NSDictionary *eventDict = @{
                                @"title": newObj.title,
                                @"time": [NSNumber numberWithInt:[newObj.time timeIntervalSince1970]],
                                @"reminderDate": [NSNumber numberWithInt:[newObj.reminderDate timeIntervalSince1970]],
                                @"location": locationDict,
                                @"locationDescription": newObj.locationDescription,
                                @"eventNote": newObj.eventNote,
                                @"created_by": user.uid
                                
                                };
    
    NSDictionary *insertNewEvent = @{
                                     [@"/events/" stringByAppendingString:newKey]: eventDict,
                                     [NSString stringWithFormat:@"/user-event/%@/%@/", user.uid, newKey]: eventDict
                                     };
    
    [self.ref updateChildValues:insertNewEvent withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        completion(error);
    }];
}

- (void)insertNewObjectToDatabase:(eventObject *)newObj ToCompletion:( void (^)(NSError *error) )completion
{
    [self insertNewObjectToDatabase:newObj createdBy:[FIRAuth auth].currentUser ToCompletion:completion];
}

- (eventObject *)parseObjectToEventObject:(NSDictionary *)object
{
    eventObject *retrivedObj = [eventObject new];
    
    retrivedObj.title = object[@"title"];
    retrivedObj.locationDescription = object[@"locationDescription"];
    retrivedObj.time = [NSDate dateWithTimeIntervalSince1970: [object[@"time"] intValue]];
    retrivedObj.reminderDate = [NSDate dateWithTimeIntervalSince1970: [object[@"reminderDate"] intValue]];
    retrivedObj.eventNote = object[@"eventNote"];
    
    NSDictionary *locationDict = object[@"location"];
    
    retrivedObj.location = [[CLLocation alloc] initWithLatitude:[locationDict[@"lati"] doubleValue] longitude:[locationDict[@"long"] doubleValue]];
    
    return retrivedObj;
}


- (eventObject *)parseNativeEventToEventObject:(EKEvent *)object
{
    eventObject *newObj = [[eventObject alloc] init];
    newObj.title = object.title;
    newObj.time = object.startDate;
    newObj.reminderDate = object.endDate;
    newObj.locationDescription = object.location;
    newObj.eventNote = object.notes;
    newObj.isInternalEvent = TRUE;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:object.location completionHandler: ^(NSArray *placemarks, NSError *error) {
        if ([placemarks count]) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;

            newObj.location = location;

            CLLocationCoordinate2D coordinate = location.coordinate;
            NSLog(@"coordinate = (%f, %f)", coordinate.latitude, coordinate.longitude);
        }
    }];

    return newObj;
}











- (void)getAllUsersToCompletion:( void (^)(User * user) )completion
{
    
    [[self.ref child:@"users"]
     observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
         
         completion([self parseUserDicToUserObject:snapshot.value]);
         
     }];
}

- (void)getMyFriendsToCompletion:( void (^)(User * user) )completion
{
    
    if ([FIRAuth auth].currentUser) {
        return;
    }
    
    
    [[[[self.ref child:@"friends"] child:[FIRAuth auth].currentUser.uid] queryOrderedByChild:@"email"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        completion([self parseUserDicToUserObject:snapshot.value]);
        
    }];
}


- (User *)parseUserDicToUserObject: (NSDictionary *)userDict{
    
    User *user = [User new];
    
    user.gender = userDict[@"gender"];
    user.whatsup = userDict[@"whatsup"];
    user.locationDescription = userDict[@"region"];
    user.email = userDict[@"email"];
    user.username = userDict[@"username"];
    
    NSDictionary *locationDict = userDict[@"location"];
    
    user.location = [[CLLocation alloc] initWithLatitude:[locationDict[@"lati"] doubleValue] longitude:[locationDict[@"long"] doubleValue]];
    
    return user;
    
}


//methods for handling friend requests

- (void)getMyPendingReceivedRequestToCompletion:( void (^)(NSArray *array) )completion
{
    if (![PFUser currentUser]) {
        return;
    }

    PFQuery *query = [PFQuery queryWithClassName:@"friendRequest"];
    [query includeKey:@"from"];
    [query whereKey:@"to" equalTo:[PFUser currentUser]];
    [query whereKey:@"status" equalTo:@"pending"];

    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error info %@", error);
        } else {
            completion(objects);
        }
    }];
}

- (void)getMyPendingSentRequestToCompletion:( void (^)(NSArray *array) )completion
{
    if (![PFUser currentUser]) {
        return;
    }

    PFQuery *query = [PFQuery queryWithClassName:@"friendRequest"];
    [query whereKey:@"from" equalTo:[PFUser currentUser]];
    [query whereKey:@"status" equalTo:@"pending"];

    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error info %@", error);
        } else {
            NSLog(@"%lu requests sent", (unsigned long)objects.count);
            completion(objects);
        }
    }];
}

- (void)sendUserFriendRequest:(PFUser *)user
{
    PFObject *request = [PFObject objectWithClassName:@"friendRequest"];
    request[@"from"]  = [PFUser currentUser];
    request[@"to"] = user;
    request[@"status"] = @"pending";

    [request saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            NSLog(@"the error is %@", error);
        }
    }];
}

- (void)approvedFriendRequestFrom:(PFUser *)user
{
    PFRelation *friendRelation = [[PFUser currentUser] relationForKey:@"friendRelation"];

    [friendRelation addObject:user];
    [[PFUser currentUser] saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            NSLog(@"the error is %@", error);
        }
    }];
}

- (void)removeDeniedFriendRequestFrom:(PFUser *)user
{
    PFQuery *query = [PFQuery queryWithClassName:@"friendRequest"];
    [query whereKey:@"status" equalTo:@"denied"];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        for (PFObject *object in objects) {
            [object deleteEventually];
        }
    }];
    //Get all my denied requests and remove all the requests from the database
}

- (void)getApprovedUsersToCompletion:( void (^)(NSArray *array) )completion
{
    if (![PFUser currentUser]) {
        return;
    }
    PFQuery *query = [PFQuery queryWithClassName:@"friendRequest"];
    [query whereKey:@"from" equalTo:[PFUser currentUser]];
    [query whereKey:@"status" equalTo:@"approved"];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error info %@", error);
        } else {
            NSLog(@"%lu requests sent", (unsigned long)objects.count);
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (PFObject *request in objects) {
                PFUser *user = request[@"to"];
                [array addObject:user];
                PFRelation *friendRelation = [[PFUser currentUser] relationForKey:@"friendRelation"];
                [friendRelation addObject:user];
                [[PFUser currentUser] saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
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

- (void)deleteEventFromCloudByID:(NSString *)objectId ToCompletion:( void (^)() )completion
{
    PFQuery *query = [PFQuery queryWithClassName:@"Events"];

    // Retrieve the object by id
    [query getObjectInBackgroundWithId:objectId
                                 block: ^(PFObject *eventObj, NSError *error) {
        [eventObj deleteInBackground];
        completion();
    }];
}


- (void)getCurrentUserInfoToCompletion:( void (^)(User * obj) )completion{
    
    [self getUserInfo:[FIRAuth auth].currentUser toCompletion:^(User *obj) {
        
        completion(obj);
    }];
}

- (void)getUserInfo: (FIRUser*)user toCompletion:( void (^)(User * obj) )completion{


    FIRDatabaseQuery *usersQuery = [[[self.ref child:@"users"] queryOrderedByChild:@"email"] queryEqualToValue:user.email];
    //FIRDatabaseQuery *userQuery = [usersQuery queryEqualToValue:user.email childKey:@"email"];
    
    [usersQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
                NSMutableDictionary *userDict = snapshot.value;
                User *newUser = [User new];
                newUser.whatsup = [NSString stringWithFormat:@"%@", [userDict objectForKey:@"whatsup"]];
                newUser.locationDescription = [NSString stringWithFormat:@"%@", [userDict objectForKey:@"locationDescription"]];
                newUser.email = user.email;
                newUser.username = user.displayName;
                newUser.gender = [NSString stringWithFormat:@"%@", [userDict objectForKey:@"gender"]];
        
                NSDictionary *locationDict = [userDict objectForKey:@"location"];
        
                if (locationDict) {
                        newUser.location = [[CLLocation alloc] initWithLatitude:[locationDict[@"lati"] doubleValue] longitude:[locationDict[@"long"] doubleValue]];
                }
                
                completion(newUser);
    }];
    

}


- (void)updateUser:(FIRUser *)user Username:(NSString *)username ToCompletion:( void (^)(NSError *error) )completion
{
    [[[[_ref child:@"users"] child:user.uid] child:@"username"] setValue:username withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        completion(error);
    }];
}

- (void)updateUser:(FIRUser *)user Email:(NSString *)email ToCompletion:( void (^)(NSError *error) )completion
{
    [[[[_ref child:@"users"] child:user.uid] child:@"email"] setValue:email withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        completion(error);
    }];
}

- (void)updateUser:(FIRUser *)user Whatsup:(NSString *)whatsup ToCompletion:( void (^)(NSError *error) )completion
{
    [[[[_ref child:@"users"] child:user.uid] child:@"whatsup"] setValue:whatsup withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        completion(error);
    }];
}

- (void)updateUser:(FIRUser *)user Gender:(NSString *)gender ToCompletion:( void (^)(NSError *error) )completion
{
    [[[[_ref child:@"users"] child:user.uid] child:@"gender"] setValue:gender withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        completion(error);
    }];
}

- (void)updateUser:(FIRUser *)user Location:(NSString *)location ToCompletion:( void (^)(NSError *error) )completion
{
    [[[[_ref child:@"users"] child:user.uid] child:@"location"] setValue:location withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        completion(error);
    }];
}

@end
