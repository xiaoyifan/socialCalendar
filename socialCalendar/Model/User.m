/**
 * This file is generated using the remodel generation script.
 * The name of the input file is User.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "User.h"

@implementation User

- (instancetype)initWithWhatsup:(NSString *)whatsup createAt:(NSDate *)createAt signIn:(NSDate *)signIn gender:(NSString *)gender location:(CLLocation *)location locationDescription:(NSString *)locationDescription
{
  if ((self = [super init])) {
    _whatsup = [whatsup copy];
    _createAt = [createAt copy];
    _signIn = [signIn copy];
    _gender = [gender copy];
    _location = [location copy];
    _locationDescription = [locationDescription copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t whatsup: %@; \n\t createAt: %@; \n\t signIn: %@; \n\t gender: %@; \n\t location: %@; \n\t locationDescription: %@; \n", [super description], _whatsup, _createAt, _signIn, _gender, _location, _locationDescription];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_whatsup hash], [_createAt hash], [_signIn hash], [_gender hash], [_location hash], [_locationDescription hash]};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 6; ++ii) {
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

- (BOOL)isEqual:(User *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_whatsup == object->_whatsup ? YES : [_whatsup isEqual:object->_whatsup]) &&
    (_createAt == object->_createAt ? YES : [_createAt isEqual:object->_createAt]) &&
    (_signIn == object->_signIn ? YES : [_signIn isEqual:object->_signIn]) &&
    (_gender == object->_gender ? YES : [_gender isEqual:object->_gender]) &&
    (_location == object->_location ? YES : [_location isEqual:object->_location]) &&
    (_locationDescription == object->_locationDescription ? YES : [_locationDescription isEqual:object->_locationDescription]);
}

@end
