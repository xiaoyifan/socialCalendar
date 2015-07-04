//
//  eventObject.m
//  socialCalendar
//
//  Created by Yifan Xiao on 5/26/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "eventObject.h"

@implementation eventObject

//Implement the encoding method
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.time forKey:@"time"];
    [encoder encodeObject:self.reminderDate forKey:@"reminderDate"];
    [encoder encodeObject:self.location forKey:@"location"];
    [encoder encodeObject:self.locationDescription forKey:@"locationDescription"];
    [encoder encodeObject:self.eventNote forKey:@"eventNote"];
    [encoder encodeObject:self.group forKey:@"group"];
    [encoder encodeObject:self.objectId forKey:@"objectId"];

    
}

//implement the decoding method
- (id) initWithCoder:(NSCoder *)decoder {
    self = [super init];
    self.title = [decoder decodeObjectForKey:@"title"];
    self.time = [decoder decodeObjectForKey:@"time"];
    self.reminderDate = [decoder decodeObjectForKey:@"reminderDate"];
    self.location = [decoder decodeObjectForKey:@"location"];
    self.locationDescription = [decoder decodeObjectForKey:@"locationDescription"];
    self.eventNote = [decoder decodeObjectForKey:@"eventNote"];
    self.group = [decoder decodeObjectForKey:@"group"];
    self.objectId = [decoder decodeObjectForKey:@"objectId"];
    
    return self;
}

@end
