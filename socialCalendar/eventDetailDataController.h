//
//  eventDetailDataController.h
//  socialCalendar
//
//  Created by Yifan Xiao on 7/11/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SCEventDetailModuleType)
{
    SCEventDetailModuleTypeName = 0,
    SCEventDetailModuleTypeAddress,
    SCEventDetailModuleTypeCount
};


@class eventDetailDataController;

@protocol eventDetailDataControllerDelegate <NSObject>

/**
 *  Indicates to the view controller when user taps on a cell.
 *
 *  @param dataController The data controller.
 *  @param indexPath      The selected index path.
 */
- (void)eventDetailDataController:(eventDetailDataController *)dataController didSelectAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface eventDetailDataController : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id <eventDetailDataControllerDelegate> delegate;
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) eventObject *event;
//@property (strong, nonatomic) LPStoreMapController *mapController;

/**
 *  Setup the data controller.
 *
 *  @param delegate       The view controller that will receive delegation messages.
 *  @param store          The store to display.
 *  @param tableView      The table view.
 */
- (void)setupWithDelegate:(id<eventDetailDataControllerDelegate>)delegate event:(eventObject *)event tableView:(UITableView *)tableView;

@end
