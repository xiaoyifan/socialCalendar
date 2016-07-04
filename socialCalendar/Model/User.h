//
//  User.h
//  socialCalendar
//
//  Created by Yifan Xiao on 7/3/16.
//  Copyright © 2016 Yifan Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

/**
 *  Event title.
 */
@property (strong, nonatomic) NSString *username;

@property (strong, nonatomic) NSString *email;

@property (strong, nonatomic) NSString *whatsup;

@property (strong, nonatomic) NSString *gender;

@property (strong, nonatomic) NSString *location;

@end
