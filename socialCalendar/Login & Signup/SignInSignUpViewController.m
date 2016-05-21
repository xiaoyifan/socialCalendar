//
//  SignInSignUpViewController.m
//  socialCalendar
//
//  Created by Yifan Xiao on 5/20/16.
//  Copyright © 2016 Yifan Xiao. All rights reserved.
//

#import "AppState.h"
#import "MeasurementHelper.h"
#import "SignInSignUpViewController.h"
#import <JVFloatLabeledText/JVFloatLabeledText.h>

@import Firebase;

@interface SignInSignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation SignInSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapSignIn:(id)sender {
    // Sign In with credentials.
    NSString *email = _emailField.text;
    NSString *password = _passwordField.text;
    [[FIRAuth auth] signInWithEmail:email
                           password:password
                         completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                             if (error) {
                                 NSLog(@"%@", error.localizedDescription);
                                 return;
                             }
                             [self signedIn:user];
                         }];
}

- (IBAction)didTapSignUp:(id)sender {
    NSString *email = _emailField.text;
    NSString *password = _passwordField.text;
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                 if (error) {
                                     NSLog(@"%@", error.localizedDescription);
                                     return;
                                 }
                                 [self setDisplayName:user];
                             }];
}

- (void)setDisplayName:(FIRUser *)user {
    FIRUserProfileChangeRequest *changeRequest =
    [user profileChangeRequest];
    // Use first part of email as the default display name
    changeRequest.displayName = [[user.email componentsSeparatedByString:@"@"] objectAtIndex:0];
    [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        [self signedIn:[FIRAuth auth].currentUser];
    }];
}

- (IBAction)didRequestPasswordReset:(id)sender {
    
    UIAlertController *prompt =
    [UIAlertController alertControllerWithTitle:nil
                                        message:@"Email:"
                                 preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController *weakPrompt = prompt;
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   UIAlertController *strongPrompt = weakPrompt;
                                   NSString *userInput = strongPrompt.textFields[0].text;
                                   if (!userInput.length)
                                   {
                                       return;
                                   }
                                   [[FIRAuth auth] sendPasswordResetWithEmail:userInput
                                                                   completion:^(NSError * _Nullable error) {
                                                                       if (error) {
                                                                           NSLog(@"%@", error.localizedDescription);
                                                                           return;
                                                                       }
                                                                   }];
                                   
                               }];
    [prompt addTextFieldWithConfigurationHandler:nil];
    [prompt addAction:okAction];
    [self presentViewController:prompt animated:YES completion:nil];
    
}

- (void)signedIn:(FIRUser *)user {
    [MeasurementHelper sendLoginEvent];
    
    [AppState sharedInstance].displayName = user.displayName.length > 0 ? user.displayName : user.email;
    [AppState sharedInstance].photoUrl = user.photoURL;
    [AppState sharedInstance].signedIn = YES;

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
