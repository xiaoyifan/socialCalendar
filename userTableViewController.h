//
//  userTableViewController.h
//  socialCalendar
//
//  Created by Yifan Xiao on 6/4/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userTableViewController : UITableViewController

/**
 *  The array of users.
 */
@property NSMutableArray *userArray;

/**
 *  The users that the current user requested, to update the button type
 */
@property NSMutableArray *sentRequestUserArray;

/**
 *  The array of the friends of currentUser.
 */
@property NSArray *friendsArray;

@end
