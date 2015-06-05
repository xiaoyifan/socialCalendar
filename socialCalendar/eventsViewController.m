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
#import "detailViewController.h"

@interface eventsViewController ()<AAShareBubblesDelegate>

@property NSMutableArray *events;

@end

@implementation eventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initData];
    
    if ([PFUser currentUser]) {
        
        [[ParsingHandle sharedParsing] findObjectsOfCurrentUserToCompletion:^(NSArray *array){
            
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"%@", [PFUser currentUser]);
    
    if (![PFUser currentUser]) { // No user logged in
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    eventViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];

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
    cell.timeLabel.text =[dateFormater stringFromDate:eventDate];
    
    cell.addressLabel.text = singleEvent.locationDescription;
    
    cell.shareButton.tag = indexPath.row;
    
    [cell.shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)shareButtonClicked:(UIButton*)sender
{
    NSLog(@"share button %ld clicked", (long)sender.tag);
    
    
    AAShareBubbles *shareBubbles = [[AAShareBubbles alloc] initCenteredInWindowWithRadius:150];
    shareBubbles.delegate = self;
    shareBubbles.bubbleRadius = 45; // Default is 40
    shareBubbles.showFacebookBubble = YES;
    shareBubbles.showTwitterBubble = YES;
    shareBubbles.showMailBubble = YES;
    shareBubbles.showGooglePlusBubble = YES;
    shareBubbles.showLinkedInBubble = YES;
    shareBubbles.showWhatsappBubble = YES;
    
    [shareBubbles show];
}

-(UIColor *)randomColor{
    NSArray *sliceColors =[NSArray arrayWithObjects:
                           
                           [UIColor colorWithRed:121/255.0 green:134/255.0 blue:203/255.0 alpha:1], //5. indigo
                           [UIColor colorWithRed:174/255.0 green:213/255.0 blue:129/255.0 alpha:1], //14. light green
                           [UIColor colorWithRed:100/255.0 green:181/255.0 blue:246/255.0 alpha:1], //2. blue
                           [UIColor colorWithRed:220/255.0 green:231/255.0 blue:117/255.0 alpha:1], //8. lime
                           [UIColor colorWithRed:79/255.0 green:195/255.0 blue:247/255.0 alpha:1], //7. light blue
                           [UIColor colorWithRed:77/255.0 green:208/255.0 blue:225/255.0 alpha:1], //3. cyan
                           [UIColor colorWithRed:77/255.0 green:182/255.0 blue:172/255.0 alpha:1], //13. teal
                           [UIColor colorWithRed:129/255.0 green:199/255.0 blue:132/255.0 alpha:1], //9. green
                           [UIColor colorWithRed:255/255.0 green:241/255.0 blue:118/255.0 alpha:1], //16. yellow
                           [UIColor colorWithRed:255/255.0 green:213/255.0 blue:79/255.0 alpha:1], //12. amber
                           [UIColor colorWithRed:255/255.0 green:183/255.0 blue:77/255.0 alpha:1], //4. orange
                           [UIColor colorWithRed:255/255.0 green:138/255.0 blue:101/255.0 alpha:1], //10. deep orange
                           [UIColor colorWithRed:144/255.0 green:164/255.0 blue:174/255.0 alpha:1], //15. blue grey
                           [UIColor colorWithRed:229/255.0 green:155/255.0 blue:155/255.0 alpha:1], //6. red
                           [UIColor colorWithRed:240/255.0 green:98/255.0 blue:146/255.0 alpha:1], //1. pink
                           [UIColor colorWithRed:186/255.0 green:104/255.0 blue:200/255.0 alpha:1], //11. purple
                           nil];
    
    int rad = arc4random() % 16;
    return sliceColors[rad];
    
}

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


#pragma mark - implementation of PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
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
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
    
    [[[UIAlertView alloc] initWithTitle:@"Login failed"
                                message:@"Please make sure you network connection is working."
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - implementation of PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
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
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

- (IBAction)unwindToMainTable:(UIStoryboardSegue *)segue {
    
    addEventTableViewController *source = [segue sourceViewController];
    eventObject *item = source.object;
    if (item != nil) {
       [self.events addObject:item];
        
        NSLog(@"%@",item.title);
        
        [self.tableView reloadData];
    }
}


#pragma mark - share button pressed delegate

-(void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(int)bubbleType
{
    switch (bubbleType) {
        case AAShareBubbleTypeFacebook:
            NSLog(@"Facebook");
            break;
        case AAShareBubbleTypeTwitter:
            NSLog(@"Twitter");
            break;
        case AAShareBubbleTypeGooglePlus:
            NSLog(@"Google+");
            break;
        case AAShareBubbleTypeLinkedIn:
            NSLog(@"LinkedIn");
            break;
        case AAShareBubbleTypeWhatsapp:
            NSLog(@"Whatsapp");
            break;
        case AAShareBubbleTypeMail:
            NSLog(@"mail");
            break;
        default:
            break;
    }
}

-(void)aaShareBubblesDidHide:(AAShareBubbles *)bubbles {
    NSLog(@"All Bubbles hidden");
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     if ([segue.identifier  isEqual: @"detailSegue"]) {
         
         detailViewController *controller = (detailViewController *)[segue destinationViewController];
         
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         
         eventViewCell *cell = (eventViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
         
         eventObject * selectedObject = [self.events objectAtIndex:indexPath.row];
         //get the item tapped in the tableView
         controller.detailObject = selectedObject;
         controller.cardBackgroundColor = cell.topBar.backgroundColor;
         
     }
 }


- (IBAction)logoutButtonPressed:(id)sender {
    
    [PFUser logOut];
}



@end
