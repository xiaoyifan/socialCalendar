/**
 * This file is generated using the remodel generation script.
 * The name of the input file is Event.value
 */

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "User.h"

@interface Event : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSDate *time;
@property (nonatomic, readonly, copy) NSDate *reminderTime;
@property (nonatomic, readonly, copy) CLLocation *location;
@property (nonatomic, readonly, copy) NSString *locationDescription;
@property (nonatomic, readonly, copy) NSString *note;
@property (nonatomic, readonly, copy) NSArray<User *> *group;
@property (nonatomic, readonly, copy) NSString *objectId;
@property (nonatomic, readonly) BOOL isInternalEvent;

- (instancetype)initWithTitle:(NSString *)title time:(NSDate *)time reminderTime:(NSDate *)reminderTime location:(CLLocation *)location locationDescription:(NSString *)locationDescription note:(NSString *)note group:(NSArray<User *> *)group objectId:(NSString *)objectId isInternalEvent:(BOOL)isInternalEvent;

@end

