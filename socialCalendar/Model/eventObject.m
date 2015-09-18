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
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.title forKey:kEventTitleKey];
    [encoder encodeObject:self.time forKey:kEventTimeKey];
    [encoder encodeObject:self.reminderDate forKey:kEventRemindTimeKey];
    [encoder encodeObject:self.location forKey:kEventLocationKey];
    [encoder encodeObject:self.locationDescription forKey:kEventLocationDescriptionKey];
    [encoder encodeObject:self.eventNote forKey:kEventNoteKey];
    [encoder encodeObject:self.group forKey:kEventGroupKey];
    [encoder encodeObject:self.objectId forKey:kEventObjectIDKey];
    [encoder encodeBool:self.isInternalEvent forKey:kEventInternalKey];
}

//implement the decoding method
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    self.title = [decoder decodeObjectForKey:kEventTitleKey];
    self.time = [decoder decodeObjectForKey:kEventTimeKey];
    self.reminderDate = [decoder decodeObjectForKey:kEventRemindTimeKey];
    self.location = [decoder decodeObjectForKey:kEventLocationKey];
    self.locationDescription = [decoder decodeObjectForKey:kEventLocationDescriptionKey];
    self.eventNote = [decoder decodeObjectForKey:kEventNoteKey];
    self.group = [decoder decodeObjectForKey:kEventGroupKey];
    self.objectId = [decoder decodeObjectForKey:kEventObjectIDKey];
    self.isInternalEvent = [decoder decodeObjectForKey:kEventInternalKey];

    return self;
}

@end
