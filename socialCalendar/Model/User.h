/**
 * This file is generated using the remodel generation script.
 * The name of the input file is User.value
 */

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface User : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *whatsup;
@property (nonatomic, readonly, copy) NSDate *createAt;
@property (nonatomic, readonly, copy) NSDate *signIn;
@property (nonatomic, readonly, copy) NSString *gender;
@property (nonatomic, readonly, copy) CLLocation *location;
@property (nonatomic, readonly, copy) NSString *locationDescription;

- (instancetype)initWithWhatsup:(NSString *)whatsup createAt:(NSDate *)createAt signIn:(NSDate *)signIn gender:(NSString *)gender location:(CLLocation *)location locationDescription:(NSString *)locationDescription;

@end

