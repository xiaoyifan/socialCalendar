//
//  ParsingHandle.h
//  socialCalendar
//
//  Created by Yifan Xiao on 5/29/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParsingHandle : NSObject

+(id)sharedParsing;


-(void)findObjectsOfCurrentUserToCompletion:(void(^)(NSArray *array))completion;

-(void)findObjectsOfUser:(PFUser *)user ToCompletion:(void(^)(NSArray *array))completion;

-(void)insertNewObjectToDatabase:(eventObject *)newObj createdBy:(PFUser *)user;

-(void)insertNewObjectToDatabase:(eventObject *)newObj;


-(eventObject *)parseObjectToEventObject:(PFObject *)object;


@end
