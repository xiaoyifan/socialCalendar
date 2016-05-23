/**
 * This file is generated using the remodel generation script.
 * The name of the input file is User.value
 */

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface User : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *objectId;
@property (nonatomic, readonly, copy) NSString *whatsup;
@property (nonatomic, readonly, copy) NSString *password;
@property (nonatomic, readonly, copy) NSString *email;
@property (nonatomic, readonly, copy) NSDate *createAt;
@property (nonatomic, readonly, copy) NSDate *signIn;
@property (nonatomic, readonly, copy) NSString *gender;
@property (nonatomic, readonly, copy) CLLocation *location;
@property (nonatomic, readonly, copy) NSString *locationDescription;

- (instancetype)initWithObjectId:(NSString *)objectId whatsup:(NSString *)whatsup password:(NSString *)password email:(NSString *)email createAt:(NSDate *)createAt signIn:(NSDate *)signIn gender:(NSString *)gender location:(CLLocation *)location locationDescription:(NSString *)locationDescription;

@end

