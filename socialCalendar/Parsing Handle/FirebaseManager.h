//
//  ParsingHandle.h
//  socialCalendar
//
//  Created by Yifan Xiao on 5/29/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@import FirebaseDatabase;
@import Firebase;

@interface FirebaseManager : NSObject

+(id)sharedInstance;


-(void)findObjectsOfCurrentUserToCompletion:(void(^)(NSArray *array))completion;

-(void)findObjectsOfUser:(FIRUser *)user ToCompletion:(void(^)(NSArray *array))completion;

-(void)findObjectsofDate:(NSDate *)date ToCompletion:(void (^)(NSArray *array))completion;

-(NSArray *)findObjectsFromNativeCalendarOnDate:(NSDate *)date;

-(void)insertNewObjectToDatabase:(eventObject *)newObj createdBy:(FIRUser *)user ToCompletion:(void (^)(NSError *error))completion;

-(void)insertNewObjectToDatabase:(eventObject *)newObj ToCompletion:(void (^)(NSError *error))completion;


-(eventObject *)parseObjectToEventObject:(PFObject *)object;

-(void)getAllUsersToCompletion:(void (^)(NSArray *array))completion;

-(void)getMyFriendsToCompletion:(void (^)(NSArray *array))completion;

-(void)getMyPendingReceivedRequestToCompletion:(void (^)(NSArray *array))completion;

-(void)getMyPendingSentRequestToCompletion:(void (^)(NSArray *array))completion;

-(void)sendUserFriendRequest:(PFUser *)user;

-(void)approvedFriendRequestFrom:(PFUser *)user;

- (void)removeDeniedFriendRequestFrom:(PFUser *)user;

-(void)getApprovedUsersToCompletion:(void (^)(NSArray *array))completion;

-(void)deleteEventFromCloudByID:(NSString *)objectId ToCompletion:(void (^)())completion;

- (void)updateUser:(FIRUser *)user Email:(NSString*)email ToCompletion:( void (^)(NSError *error) )completion;
- (void)updateUser:(FIRUser *)user Username:(NSString*)username ToCompletion:( void (^)(NSError *error) )completion;
- (void)updateUser:(FIRUser *)user Gender:(NSString*)gender ToCompletion:( void (^)(NSError *error) )completion;
- (void)updateUser:(FIRUser *)user Location:(NSString*)location ToCompletion:( void (^)(NSError *error) )completion;
- (void)updateUser:(FIRUser *)user Whatsup:(NSString *)whatsup ToCompletion:( void (^)(NSError *error) )completion;

@end
