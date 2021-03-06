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
#import <LocalAuthentication/LocalAuthentication.h>

#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>
#import <JVFloatLabeledTextField.h>
#import <JVFloatLabeledTextView.h>

const static CGFloat kJVFieldFontSize = 16.0f;

const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;

@interface SignInSignUpViewController ()
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *emailField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passwordField;

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UILabel *signupLabel;

@property (weak, nonatomic) IBOutlet UISwitch *operationSwitch;

@end

@implementation SignInSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureTextFields];
    
    [self switchDataChanged];
    
    NSLog(@"%@", [FIRAuth auth].currentUser);
    
    [_operationSwitch addTarget:self action:@selector(switchDataChanged) forControlEvents:UIControlEventValueChanged];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    if ([FIRAuth auth].currentUser) {
        [self signedIn:[FIRAuth auth].currentUser];
    }
    
    LAContext * localContext = [LAContext new];
    
    BOOL hasTouchId = [localContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    
    if (hasTouchId) {
        [localContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Touch to Login" reply:^(BOOL success, NSError * _Nullable error) {
           
            if (success) {
                
                [self signedIn:[FIRAuth auth].currentUser];
            }
            
        }];
    }
    
}

- (void)configureTextFields{
    
    UIColor *floatingLabelColor = [UIColor brownColor];
    
    _emailField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"E-mail", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    _emailField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _emailField.floatingLabelTextColor = floatingLabelColor;
    _emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _emailField.translatesAutoresizingMaskIntoConstraints = NO;
    _emailField.keepBaseline = YES;
    
    
    _passwordField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"password", @"")
                                                                        attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    _passwordField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _passwordField.floatingLabelTextColor = floatingLabelColor;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.translatesAutoresizingMaskIntoConstraints = NO;
    _passwordField.keepBaseline = YES;

}

- (void)switchDataChanged{
    
    if (self.operationSwitch.isOn) {
        self.loginLabel.textColor = [UIColor blackColor];
        self.signupLabel.textColor = [UIColor disabledTextColor];
    }
    else {
        self.loginLabel.textColor = [UIColor disabledTextColor];
        self.signupLabel.textColor = [UIColor blackColor];
    }
    
}

- (IBAction)confirmButtonTapped:(id)sender {
    
    
    if (self.operationSwitch.isOn) {
        [self didTapSignIn:sender];
    }
    else{
        [self didTapSignUp:sender];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapSignIn:(id)sender {
    // Sign In with credentials.
    NSString *email = _emailField.text;
    NSString *password = _passwordField.text;
    [SVProgressHUD show];
    [[FIRAuth auth] signInWithEmail:email
                           password:password
                         completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                             [SVProgressHUD dismiss];
                             if (error) {
                                 NSLog(@"%@", error.localizedDescription);
                                 SCLAlertView *alert = [[SCLAlertView alloc] init];
                                 [alert showError:self title:@"Sign in failed" subTitle:@"please type in the right method" closeButtonTitle:@"OK" duration:1.0f];
                                 return;
                             }
                             [self signedIn:user];
                         }];
}

- (IBAction)didTapSignUp:(id)sender {
    NSString *email = _emailField.text;
    NSString *password = _passwordField.text;
    [SVProgressHUD show];
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                 [SVProgressHUD dismiss];
                                 if (error) {
                                     NSLog(@"%@", error.localizedDescription);
                                     SCLAlertView *alert = [[SCLAlertView alloc] init];
                                     [alert showError:@"Sign Up failed" subTitle:@"The action can't be completed now. Sorry." closeButtonTitle:@"OK" duration:1.0f];
                                     return;
                                 }
                                 [self setDisplayName:user];
                                 SCLAlertView *alert = [SCLAlertView new];
                                 [alert showSuccess:@"Sign Up accepted" subTitle:@"Now type in your e-mail and password again to signin" closeButtonTitle:@"OK" duration:1.0f];
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
        
        // [START basic_write]
        [[[[[FIRDatabase database] reference] child:@"users"] child:user.uid]
         setValue:@{@"username": user.displayName}];
        // [END basic_write]
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
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    UITabBarController *controller = (UITabBarController*)[mainStoryboard
                                                       instantiateViewControllerWithIdentifier: @"baseTabbarController"];
    
    [self presentViewController:controller animated:YES completion:nil];

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
