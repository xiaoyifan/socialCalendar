//
//  eventsViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 5/24/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "socialCalendar-Swift.h"

#import "WXApi.h"
#import "WXApiObject.h"

#import "eventsViewController.h"
#import "eventViewCell.h"
#import "addEventTableViewController.h"
#import "AAShareBubbles.h"
#import "popingViewController.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "expireMarkingView.h"
#import "SCEventInfoViewController.h"
#import "AppState.h"

#import "UIColor+CustomColors.h"

#import <QuartzCore/QuartzCore.h>

@interface eventsViewController () <AAShareBubblesDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

@property NSMutableArray *events;
@property NSMutableArray *fetchedEvents;

@property eventObject *eventToShare;

@property (retain, nonatomic) ViewController *vc;

@property NSInteger cellIndexToDelete;

@end

@implementation eventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.vc = [[ViewController alloc] init];
//    [self presentViewController:self.vc animated:NO completion:nil];
//    [self.view addSubview:self.vc.view];

    [self loadDataEvents];

    self.tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#EDEDED"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%@", [PFUser currentUser]);

}

/**
 *  query the data from Parse to load the table
 */
- (void)loadDataEvents
{
    if ([PFUser currentUser]) {
        PFInstallation *installation = [PFInstallation currentInstallation];
        installation[@"user"] = [PFUser currentUser];
        [installation saveInBackground];

        [[ParsingHandle sharedParsing] findObjectsOfCurrentUserToCompletion: ^(NSArray *array) {
            self.fetchedEvents = [[NSMutableArray alloc] init];

            for (PFObject *obj in array) {
                eventObject *newObj = [[ParsingHandle sharedParsing] parseObjectToEventObject:obj];
                [self.fetchedEvents addObject:newObj];
            }
            NSArray *sortedArray;
            sortedArray = [self.fetchedEvents sortedArrayUsingComparator: ^NSComparisonResult (id a, id b) {
                NSDate *first = ( (eventObject *)a ).time;
                NSDate *second = ( (eventObject *)b ).time;
                return [second compare:first];
            }];

            self.events = [NSMutableArray arrayWithArray:sortedArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];

                [[NSNotificationCenter defaultCenter] postNotificationName:@"tableViewdidLoad" object:self];
            });
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    eventViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];

    cell.contentView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#EDEDED"];

    cell.backgroundCardView.layer.cornerRadius = 10.0;

    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:cell.backgroundCardView.bounds];
    cell.backgroundCardView.layer.masksToBounds = YES;
    cell.backgroundCardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.backgroundCardView.layer.shadowOffset = CGSizeMake(0.2f, -0.2f);
    cell.backgroundCardView.layer.shadowOpacity = 0.2f;
    cell.backgroundCardView.layer.shadowPath = shadowPath.CGPath;

    cell.topBar.backgroundColor = [UIColor randomColor];

    eventObject *singleEvent = [self.events objectAtIndex:indexPath.row];

    cell.eventName.text = singleEvent.title;

    NSDate *eventDate = singleEvent.time;
    NSDateFormatter *dateFormater = [NSDateFormatter new];

    dateFormater.dateFormat = @"MM.dd.yyyy";
    cell.dateLabel.text = [dateFormater stringFromDate:eventDate];

    dateFormater.dateFormat = @"HH:mm";
    cell.timeLabel.text = [dateFormater stringFromDate:eventDate];

    if ([singleEvent.locationDescription isEqual:[NSNull null]] || [singleEvent.locationDescription isEqualToString:@"(null)"]) {
        cell.addressLabel.text = @"the location description is not available";
    } else {
        cell.addressLabel.text = singleEvent.locationDescription;
    }

    cell.shareButton.tag = indexPath.row;

    [cell.shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    if (indexPath.row == 5) {
    }
    if ([eventDate compare:[NSDate date]] == NSOrderedAscending) {
        cell.topBar.backgroundColor = [UIColor darkGrayColor];
        cell.expiredLabel.layer.borderColor = [UIColor customRedColor].CGColor;
        cell.expiredLabel.textColor = [UIColor customRedColor];
        cell.expiredLabel.layer.borderWidth = 3.0f;
        cell.expiredLabel.hidden = NO;
    } else {
        cell.expiredLabel.hidden = YES;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showEventInfoViewWithEvent:self.events[indexPath.row]];
}

- (void)showEventInfoViewWithEvent:(eventObject *)eventObj
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"eventDetail" bundle:nil];
    SCEventInfoViewController *eventDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"eventDetailViewController"];
    [eventDetailVC setupWithEvent:eventObj];
    [self.navigationController pushViewController:eventDetailVC animated:YES];
}


- (IBAction)unwindToMainTable:(UIStoryboardSegue *)segue
{
    addEventTableViewController *source = [segue sourceViewController];
    eventObject *item = source.object;
    if (item != nil) {
        for (int i = 0; i < self.events.count; i++) {
            eventObject *obj = [self.events objectAtIndex:i];
            if ([obj.time compare:item.time] == NSOrderedAscending) {
                [self.events insertObject:item atIndex:i];
                break;
            }
        }

        NSLog(@"%@", item.title);

        [self.tableView reloadData];
    }
}

#pragma mark - share button pressed delegate

- (void)shareButtonClicked:(UIButton *)sender
{
    AAShareBubbles *shareBubbles = [[AAShareBubbles alloc] initCenteredInWindowWithRadius:150];
    shareBubbles.delegate = self;
    shareBubbles.bubbleRadius = 45; // Default is 40
    shareBubbles.showFacebookBubble = YES;
    shareBubbles.showTwitterBubble = YES;
    shareBubbles.showMailBubble = YES;

    [shareBubbles addCustomButtonWithIcon:[UIImage imageNamed:@"wechat"]
                          backgroundColor:[UIColor hx_colorWithHexRGBAString:@"#00CC00"]
                              andButtonId:101];

    [shareBubbles addCustomButtonWithIcon:[UIImage imageNamed:@"weibo"]
                          backgroundColor:[UIColor hx_colorWithHexRGBAString:@"#FFCC11"]
                              andButtonId:120];

    self.eventToShare = [self.events objectAtIndex:sender.tag];

    [shareBubbles show];
}

- (void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(AAShareBubbleType)bubbleType
{
    switch (bubbleType) {
        case AAShareBubbleTypeFacebook:
            NSLog(@"Facebook");
            [self shareOnFacebook];
            break;

        case AAShareBubbleTypeTwitter:
            NSLog(@"Twitter");
            [self shareOnTwitter];
            break;

        case AAShareBubbleTypeMail:
            NSLog(@"mail");
            [self shareOnMail];
            break;
        case 101:
            NSLog(@"wechat");
            [self shareOnWechat];
            break;

        case 120:
            NSLog(@"Weibo");
            [self shareOnWeibo];
            break;

        default:
            break;
    }
}

- (void)shareOnFacebook
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebookPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];

        NSDate *date = self.eventToShare.time;

        NSDateFormatter *dateFormater = [NSDateFormatter new];

        dateFormater.dateFormat = @"MM.dd.yyyy";
        NSString *dateString = [dateFormater stringFromDate:date];

        dateFormater.dateFormat = @"HH:mm";
        NSString *timeString = [dateFormater stringFromDate:date];

        NSString *text = [NSString stringWithFormat:@"%@, join us at the event: %@ at %@", dateString, self.eventToShare.title, timeString];
        [facebookPost setInitialText:text];
        [self presentViewController:facebookPost animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                            message:@"You can't send a Facebook post right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)shareOnTwitter
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitterPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];

        NSDate *date = self.eventToShare.time;

        NSDateFormatter *dateFormater = [NSDateFormatter new];

        dateFormater.dateFormat = @"MM.dd.yyyy";
        NSString *dateString = [dateFormater stringFromDate:date];

        dateFormater.dateFormat = @"HH:mm";
        NSString *timeString = [dateFormater stringFromDate:date];

        NSString *text = [NSString stringWithFormat:@"%@, join us at the event: %@ at %@", dateString, self.eventToShare.title, timeString];
        [twitterPost setInitialText:text];
        [self presentViewController:twitterPost animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                            message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)shareOnMail
{
    NSString *emailTitle = @"Event Invite";
    // Email Content
    NSDate *date = self.eventToShare.time;

    NSDateFormatter *dateFormater = [NSDateFormatter new];

    dateFormater.dateFormat = @"MM.dd.yyyy";
    NSString *dateString = [dateFormater stringFromDate:date];

    dateFormater.dateFormat = @"HH:mm";
    NSString *timeString = [dateFormater stringFromDate:date];

    NSString *text = [NSString stringWithFormat:@"%@, join us at the event: %@ at %@", dateString, self.eventToShare.title, timeString];

    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:text isHTML:NO];

    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;

        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;

        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;

        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;

        default:
            break;
    }

    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)shareOnWechat
{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text = self.eventToShare.title;
    req.bText = YES;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}

- (void)shareOnWeibo
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        SLComposeViewController *weiboPost = [SLComposeViewController
                                              composeViewControllerForServiceType:SLServiceTypeSinaWeibo];

        NSDate *date = self.eventToShare.time;

        NSDateFormatter *dateFormater = [NSDateFormatter new];

        dateFormater.dateFormat = @"MM.dd.yyyy";
        NSString *dateString = [dateFormater stringFromDate:date];

        dateFormater.dateFormat = @"HH:mm";
        NSString *timeString = [dateFormater stringFromDate:date];

        NSString *text = [NSString stringWithFormat:@"%@, join us at the event: %@ at %@", dateString, self.eventToShare.title, timeString];
        [weiboPost setInitialText:text];
        [self presentViewController:weiboPost animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                            message:@"You can't send a weibo right now, make sure your device has an internet connection and you have at least one Weibo account setup"
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)aaShareBubblesDidHide:(AAShareBubbles *)bubbles
{
    NSLog(@"All Bubbles hidden");
}

- (IBAction)logoutButtonPressed:(id)sender
{
    FIRAuth *firebaseAuth = [FIRAuth auth];
    NSError *signOutError;
    BOOL status = [firebaseAuth signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
    [AppState sharedInstance].signedIn = false;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- event deleting

- (void)deleteButtonClicked:(UIButton *)sender
{
    self.cellIndexToDelete = sender.tag;

    popingViewController *popViewController = [popingViewController new];
    popViewController.transitioningDelegate = (id)self;
    popViewController.modalPresentationStyle = UIModalPresentationCustom;
    popViewController.delegate = self;
    [self.navigationController presentViewController:popViewController
                                            animated:YES
                                          completion:NULL];
}

#pragma mark -- popping view delegate
- (void)sendDataToSource
{
    // Delete the object from the datasource.
    eventObject *object = [self.events objectAtIndex:self.cellIndexToDelete];

    [self.events removeObjectAtIndex:self.cellIndexToDelete];

    [[ParsingHandle sharedParsing] deleteEventFromCloudByID:object.objectId ToCompletion: ^() {
    }];

    // Tell the table what has changed.
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.cellIndexToDelete inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];

    [self.tableView reloadData];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    return [PresentingAnimator new];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}

@end
