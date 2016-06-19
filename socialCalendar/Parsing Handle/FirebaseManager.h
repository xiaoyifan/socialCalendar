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

- (FIRDatabaseQuery *) getEventQueryFromCurrentUser;

- (FIRDatabaseQuery *) getEventQueryFromUser: (FIRUser *)user;

-(void)findObjectsOfCurrentUserToCompletion:(void(^)(NSArray *array))completion;

-(void)findObjectsOfUser:(PFUser *)user ToCompletion:(void(^)(NSArray *array))completion;

-(void)findObjectsofDate:(NSDate *)date ToCompletion:(void (^)(NSArray *array))completion;

-(NSArray *)findObjectsFromNativeCalendarOnDate:(NSDate *)date;

-(void)insertNewObjectToDatabase:(eventObject *)newObj createdBy:(PFUser *)user ToCompletion:(void (^)())completion;

-(void)insertNewObjectToDatabase:(eventObject *)newObj ToCompletion:(void (^)())completion;


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

-(void)updateUser:(PFUser*)user Email:(NSString*)email ToCompletion:( void (^)(BOOL finished) )completion;
-(void)updateUser:(PFUser*)user Username:(NSString*)username ToCompletion:( void (^)(BOOL finished) )completion;
-(void)updateUser:(PFUser*)user Education:(NSString*)education ToCompletion:( void (^)(BOOL finished) )completion;
-(void)updateUser:(PFUser*)user Work:(NSString*)work ToCompletion:( void (^)(BOOL finished) )completion;
-(void)updateUser:(PFUser*)user Website:(NSString*)website ToCompletion:( void (^)(BOOL finished) )completion;
-(void)updateUser:(PFUser*)user Gender:(NSString*)gender ToCompletion:( void (^)(BOOL finished) )completion;
-(void)updateUser:(PFUser*)user Location:(NSString*)location ToCompletion:( void (^)(BOOL finished) )completion;
- (void)updateUser:(PFUser *)user Whatsup:(NSString *)whatsup ToCompletion:( void (^)(BOOL finished) )completion;

@end
