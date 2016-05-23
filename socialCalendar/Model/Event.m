/**
 * This file is generated using the remodel generation script.
 * The name of the input file is Event.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "Event.h"

@implementation Event

- (instancetype)initWithTitle:(NSString *)title time:(NSDate *)time reminderTime:(NSDate *)reminderTime location:(CLLocation *)location locationDescription:(NSString *)locationDescription note:(NSString *)note group:(NSArray<User *> *)group objectId:(NSString *)objectId isInternalEvent:(BOOL)isInternalEvent
{
  if ((self = [super init])) {
    _title = [title copy];
    _time = [time copy];
    _reminderTime = [reminderTime copy];
    _location = [location copy];
    _locationDescription = [locationDescription copy];
    _note = [note copy];
    _group = [group copy];
    _objectId = [objectId copy];
    _isInternalEvent = isInternalEvent;
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t title: %@; \n\t time: %@; \n\t reminderTime: %@; \n\t location: %@; \n\t locationDescription: %@; \n\t note: %@; \n\t group: %@; \n\t objectId: %@; \n\t isInternalEvent: %@; \n", [super description], _title, _time, _reminderTime, _location, _locationDescription, _note, _group, _objectId, _isInternalEvent ? @"YES" : @"NO"];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_title hash], [_time hash], [_reminderTime hash], [_location hash], [_locationDescription hash], [_note hash], [_group hash], [_objectId hash], (NSUInteger)_isInternalEvent};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 9; ++ii) {
    unsigned long long base = (((unsigned long long)result) << 32 | subhashes[ii]);
    base = (~base) + (base << 18);
    base ^= (base >> 31);
    base *=  21;
    base ^= (base >> 11);
    base += (base << 6);
    base ^= (base >> 22);
    result = base;
  }
  return result;
}

- (BOOL)isEqual:(Event *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    _isInternalEvent == object->_isInternalEvent &&
    (_title == object->_title ? YES : [_title isEqual:object->_title]) &&
    (_time == object->_time ? YES : [_time isEqual:object->_time]) &&
    (_reminderTime == object->_reminderTime ? YES : [_reminderTime isEqual:object->_reminderTime]) &&
    (_location == object->_location ? YES : [_location isEqual:object->_location]) &&
    (_locationDescription == object->_locationDescription ? YES : [_locationDescription isEqual:object->_locationDescription]) &&
    (_note == object->_note ? YES : [_note isEqual:object->_note]) &&
    (_group == object->_group ? YES : [_group isEqual:object->_group]) &&
    (_objectId == object->_objectId ? YES : [_objectId isEqual:object->_objectId]);
}

@end

