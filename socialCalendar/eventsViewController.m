//
//  eventsViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 5/24/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "eventsViewController.h"
#import "eventViewCell.h"
#import "addEventTableViewController.h"
#import "AAShareBubbles.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "socialCalendar-Swift.h"
#import "popingViewController.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "expireMarkingView.h"
#import "SCEventInfoViewController.h"

@interface eventsViewController () <AAShareBubblesDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

@property NSMutableArray *events;

@property eventObject *eventToShare;

@property (retain, nonatomic) ViewController *vc;

@property NSInteger cellIndexToDelete;

@end

@implementation eventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.vc = [[ViewController alloc] init];
    [self presentViewController:self.vc animated:NO completion:nil];
    [self.view addSubview:self.vc.view];

    [self loadDataEvents];

    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%@", [PFUser currentUser]);

    [self handleLogginAndSignUp];
}

/**
 *  handle the login and signup basic configuration with parse.
 */
- (void)handleLogginAndSignUp
{
    PFUser *user = [PFUser currentUser];

    if ( (![PFUser currentUser]) || (user[@"emailVerified"] == false) ) {
        // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        logInViewController.fields = (PFLogInFieldsUsernameAndPassword
                                      | PFLogInFieldsLogInButton
                                      | PFLogInFieldsSignUpButton
                                      | PFLogInFieldsPasswordForgotten
                                      | PFLogInFieldsDismissButton
                                      | PFLogInFieldsFacebook
                                      | PFLogInFieldsTwitter);
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate

        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];

        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
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
            self.events = [[NSMutableArray alloc] init];

            for (PFObject *obj in array) {
                eventObject *newObj = [[ParsingHandle sharedParsing] parseObjectToEventObject:obj];
                [self.events addObject:newObj];
            }

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

    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];

    cell.backgroundCardView.layer.cornerRadius = 10.0;

    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:cell.backgroundCardView.bounds];
    cell.backgroundCardView.layer.masksToBounds = YES;
    cell.backgroundCardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.backgroundCardView.layer.shadowOffset = CGSizeMake(0.2f, -0.2f);
    cell.backgroundCardView.layer.shadowOpacity = 0.2f;
    cell.backgroundCardView.layer.shadowPath = shadowPath.CGPath;

    cell.topBar.backgroundColor = [self randomColor];

    eventObject *singleEvent = [self.events objectAtIndex:indexPath.row];

    cell.eventName.text = singleEvent.title;

    NSDate *eventDate = singleEvent.time;
    NSDateFormatter *dateFormater = [NSDateFormatter new];

    dateFormater.dateFormat = @"MM.dd.yyyy";
    cell.dateLabel.text = [dateFormater stringFromDate:eventDate];

    dateFormater.dateFormat = @"HH:mm";
    cell.timeLabel.text = [dateFormater stringFromDate:eventDate];

    cell.addressLabel.text = singleEvent.locationDescription;

    cell.shareButton.tag = indexPath.row;

    [cell.shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    if ([eventDate compare:[NSDate date]] == NSOrderedAscending) {
        [self addExpiredMarkToView:cell.contentView];
        cell.topBar.backgroundColor = [UIColor darkGrayColor];
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

- (void)addExpiredMarkToView:(UIView *)contentView
{
    expireMarkingView *boundingView = [[expireMarkingView alloc] initWithFrame:CGRectMake(0, 0, 135.0f, 70.0f)];
    boundingView.backgroundColor = [UIColor clearColor];

    CGAffineTransform transform =
        CGAffineTransformMakeRotation(45.0f);

    boundingView.transform = transform;

    boundingView.center = CGPointMake(contentView.frame.size.width  / 2.0,
                                      contentView.frame.size.height / 2.0);

    [contentView addSubview:boundingView];

    UILabel *expiredLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 135.0f, 70.0f)];
    expiredLabel.textColor = [UIColor redColor];
    expiredLabel.text = @"expired";
    expiredLabel.font = [UIFont fontWithName:@"Avenir" size:24.0f];
    expiredLabel.transform = transform;

    expiredLabel.center = CGPointMake(contentView.frame.size.width  / 2.0 + 15,
                                      contentView.frame.size.height / 2.0 + 20);
    [contentView addSubview:expiredLabel];
}

#pragma mark - implementation of PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password
{
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }

    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self loadDataEvents];
    [self.tableView reloadData];

    if ([user[@"emailVerified"] isEqual:@1]) {
        PFInstallation *installation = [PFInstallation currentInstallation];
        installation[@"user"] = [PFUser currentUser];
        [installation saveInBackground];

        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verification Required" message:@"please verify your email first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    NSLog(@"Failed to log in...");

    [[[UIAlertView alloc] initWithTitle:@"Login failed"
                                message:@"Please make sure you network connection is working."
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - implementation of PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info
{
    BOOL informationComplete = YES;

    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            // check completion
            informationComplete = NO;
            break;
        }
    }

    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }

    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the PFSignUpViewController
    [self loadDataEvents];

    if (user[@"emailVerified"] == false) {
        return;
    }

    [self.tableView reloadData];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error
{
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    NSLog(@"User dismissed the signUpViewController");
}

- (IBAction)unwindToMainTable:(UIStoryboardSegue *)segue
{
    addEventTableViewController *source = [segue sourceViewController];
    eventObject *item = source.object;
    if (item != nil) {
        [self.events addObject:item];

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
                          backgroundColor:[UIColor colorWithHexString:@"#00CC00"]
                              andButtonId:101];

    [shareBubbles addCustomButtonWithIcon:[UIImage imageNamed:@"weibo"]
                          backgroundColor:[UIColor colorWithHexString:@"#FFCC11"]
                              andButtonId:120];

    self.eventToShare = [self.events objectAtIndex:sender.tag];

    [shareBubbles show];
}

- (void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(int)bubbleType
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

 #pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//     if ([segue.identifier  isEqual: @"detailSegue"]) {
//
//         detailViewController *controller = (detailViewController *)[segue destinationViewController];
//
//         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//
//         eventViewCell *cell = (eventViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//
//         eventObject * selectedObject = [self.events objectAtIndex:indexPath.row];
//         //get the item tapped in the tableView
//         controller.detailObject = selectedObject;
//         controller.cardBackgroundColor = cell.topBar.backgroundColor;
//
//     }
// }


- (IBAction)logoutButtonPressed:(id)sender
{
    [PFUser logOut];

    [self handleLogginAndSignUp];
}

#pragma mark -- color choosing

- (UIColor *)randomColor
{
    NSArray *sliceColors = [NSArray arrayWithObjects:

                            [UIColor colorWithRed:121 / 255.0 green:134 / 255.0 blue:203 / 255.0 alpha:1], //5. indigo
                            [UIColor colorWithRed:174 / 255.0 green:213 / 255.0 blue:129 / 255.0 alpha:1], //14. light green
                            [UIColor colorWithRed:100 / 255.0 green:181 / 255.0 blue:246 / 255.0 alpha:1], //2. blue
                            [UIColor colorWithRed:220 / 255.0 green:231 / 255.0 blue:117 / 255.0 alpha:1], //8. lime
                            [UIColor colorWithRed:79 / 255.0 green:195 / 255.0 blue:247 / 255.0 alpha:1], //7. light blue
                            [UIColor colorWithRed:77 / 255.0 green:208 / 255.0 blue:225 / 255.0 alpha:1], //3. cyan
                            [UIColor colorWithRed:77 / 255.0 green:182 / 255.0 blue:172 / 255.0 alpha:1], //13. teal
                            [UIColor colorWithRed:129 / 255.0 green:199 / 255.0 blue:132 / 255.0 alpha:1], //9. green
                            [UIColor colorWithRed:255 / 255.0 green:241 / 255.0 blue:118 / 255.0 alpha:1], //16. yellow
                            [UIColor colorWithRed:255 / 255.0 green:213 / 255.0 blue:79 / 255.0 alpha:1], //12. amber
                            [UIColor colorWithRed:255 / 255.0 green:183 / 255.0 blue:77 / 255.0 alpha:1], //4. orange
                            [UIColor colorWithRed:255 / 255.0 green:138 / 255.0 blue:101 / 255.0 alpha:1], //10. deep orange
                            [UIColor colorWithRed:144 / 255.0 green:164 / 255.0 blue:174 / 255.0 alpha:1], //15. blue grey
                            [UIColor colorWithRed:229 / 255.0 green:155 / 255.0 blue:155 / 255.0 alpha:1], //6. red
                            [UIColor colorWithRed:240 / 255.0 green:98 / 255.0 blue:146 / 255.0 alpha:1], //1. pink
                            [UIColor colorWithRed:186 / 255.0 green:104 / 255.0 blue:200 / 255.0 alpha:1], //11. purple
                            nil];

    int rad = arc4random() % 16;
    return sliceColors[rad];
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
