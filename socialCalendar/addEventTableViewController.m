//
//  addEventTableViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 5/25/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "addEventTableViewController.h"
#import "HSDatePickerViewController.h"
#import "mapViewController.h"
#import "KLCPopup.h"

@interface addEventTableViewController ()<HSDatePickerViewControllerDelegate, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;


@property (nonatomic, strong) KLCPopup *reminderPopup;

@property (nonatomic, strong) NSArray *pickerData;

@end

@implementation addEventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pickerData = @[@"10 mins head", @"15 mins head", @"30 mins head", @"1 hour head", @"5 hour head", @"1 day head"];

}


- (IBAction)timeButtonPressed:(UIButton *)sender {
    
    HSDatePickerViewController *hsdpvc = [HSDatePickerViewController new];
    hsdpvc.delegate = self;
    
    [self presentViewController:hsdpvc animated:YES completion:nil];
    
}

#pragma mark - HSDatePickerViewControllerDelegate
- (void)hsDatePickerPickedDate:(NSDate *)date {
    NSLog(@"Date picked %@", date);
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    dateFormater.dateFormat = @"yyyy.MM.dd HH:mm:ss";
   self.timeLabel.text = [dateFormater stringFromDate:date];
    
}

- (IBAction)addReminder:(UIButton *)sender {
    UIPickerView *myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    myPickerView.delegate = self;
    myPickerView.layer.cornerRadius = 15.0;
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.backgroundColor = [UIColor colorWithRed:(184.0/255.0) green:(233.0/255.0) blue:(122.0/255.0) alpha:1.0];
    
    self.reminderPopup = [KLCPopup popupWithContentView:myPickerView
                                               showType: KLCPopupShowTypeSlideInFromLeft
                                            dismissType: KLCPopupDismissTypeSlideOutToRight
                                               maskType: KLCPopupMaskTypeDimmed
                               dismissOnBackgroundTouch:YES
                                  dismissOnContentTouch:NO];
    

//    self.reminderPopup.willStartDismissingCompletion = ^{
//        //get the reminder data and dismiss
//    };
    
    
    
    [self.reminderPopup show];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    self.reminderLabel.text = self.pickerData[row];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.pickerData.count;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.pickerData[row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}



//unwind segue
- (IBAction)unwindToTable:(UIStoryboardSegue *)segue{
    
    mapViewController *source = [segue sourceViewController];
    CLLocation *itemLocation = source.selectedLocation;
    NSString *address = source.selectedLocationAddress;
    self.itemLocation = [[CLLocation alloc] initWithLatitude:itemLocation.coordinate.latitude longitude:itemLocation.coordinate.longitude];
    //assign the location to the add view controller, this is the location data from the map view controller
    
    NSLog(@"the selected location is: %f, %f", self.itemLocation.coordinate.latitude, self.itemLocation.coordinate.longitude);
    
    if (itemLocation != nil) {
        self.locationLabel.text = [NSString stringWithFormat:@"%@",address];
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
