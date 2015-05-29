//
//  detailViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 5/28/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "detailViewController.h"

@interface detailViewController ()

@property (weak, nonatomic) IBOutlet UIView *cardView;

@property (weak, nonatomic) IBOutlet UILabel *eventLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;

@property (weak, nonatomic) IBOutlet UITextView *noteLabel;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end

@implementation detailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardView.backgroundColor = self.cardBackgroundColor;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    
    self.eventLabel.text = self.detailObject.title;
    self.timeLabel.text = [NSString stringWithFormat:@"%@", self.detailObject.time];
    self.reminderLabel.text = [NSString stringWithFormat:@"%@", self.detailObject.reminderDate];
    self.noteLabel.text = self.detailObject.eventNote;
    self.locationLabel.text = self.detailObject.locationDescription;
    
}

- (void)viewDidLayoutSubviews {
    [self.mainScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 800)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
 
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
