/** @file FIRAuthUIBaseViewController.h
    @brief Firebase Auth UI SDK
    @copyright Copyright 2016 Google Inc.
    @remarks Use of this SDK is subject to the Google APIs Terms of Service:
        https://developers.google.com/terms/
 */

#import <UIKit/UIKit.h>

@class FIRAuth;
@class FIRAuthUI;
@protocol FIRAuthProviderUI;

NS_ASSUME_NONNULL_BEGIN

/** @typedef FIRAuthUIAlertActionHandler
    @brief The type of block called when an alert view is dismissed by a user action.
 */
typedef void (^FIRAuthUIAlertActionHandler)(void);

/** @class FIRAuthUIBaseViewController
    @brief The base view controller that provides common methods for all subclasses.
 */
@interface FIRAuthUIBaseViewController : UITableViewController

/** @property auth
    @brief The @c FIRAuth instance of the application.
 */
@property(nonatomic, strong, readonly) FIRAuth *auth;

/** @property authUI
    @brief The @c FIRAuth instance of the application.
 */
@property(nonatomic, strong, readonly) FIRAuthUI *authUI;

/** @fn init
    @brief Please use @c initWithNibName:bundle:authUI:.
 */
- (nullable instancetype)init NS_UNAVAILABLE;

/** @fn initWithStyle:
    @brief Please use @c initWithNibName:bundle:authUI:.
 */
- (instancetype)initWithStyle:(UITableViewStyle)style NS_UNAVAILABLE;

/** @fn initWithNibName:bundle:
    @brief Please use @c initWithNibName:bundle:authUI:.
 */
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                         bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

/** @fn initWithNibName:bundle:authUI:
    @brief Designated initializer.
    @param nibNameOrNil The name of the nib file to associate with the view controller.
    @param nibBundleOrNil The bundle in which to search for the nib file.
    @param authUI The @c FIRAuthUI instance that manages this view controller.
 */
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                         bundle:(nullable NSBundle *)nibBundleOrNil
                         authUI:(FIRAuthUI *)authUI NS_DESIGNATED_INITIALIZER;

/** @fn initWithAuthUI:
    @brief Convenience initializer.
    @param authUI The @c FIRAuthUI instance that manages this view controller.
 */
- (instancetype)initWithAuthUI:(FIRAuthUI *)authUI;

/** @fn isValidEmail:
    @brief Statically validates email address.
    @param email The email address to validate.
 */
+ (BOOL)isValidEmail:(NSString *)email;

/** @fn showAlertWithTitle:message:
    @brief Displays an alert view with given title and message on top of the current view
        controller.
    @param title The title of the alert.
    @param message The message of the alert.
 */
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

/** @fn showSignInAlertWithEmail:provider:handler:
    @brief Displays an alert to conform with user whether she wants to proceed with the provider.
    @param email The email address to sign in with.
    @param provider The identity provider to sign in with.
    @param handler Handler for the sign in action of the alert.
 */
- (void)showSignInAlertWithEmail:(NSString *)email
                        provider:(id<FIRAuthProviderUI>)provider
                         handler:(FIRAuthUIAlertActionHandler)handler;

/** @fn pushViewController:
    @brief Push the view controller to the navigation controller of the current view controller
        with animation. The pushed view controller will have a fixed "Back" title for back button.
    @param viewController The view controller to be pushed.
 */
- (void)pushViewController:(UIViewController *)viewController;

/** @fn incrementActivity
    @brief Increment the current acitivity count. If there's positive number of activities, display
        and animate the activity indicator with a short period of delay.
    @remarks Calls to @c incrementActivity and @c decrementActivity should be balanced.
 */
- (void)incrementActivity;

/** @fn decrementActivity
    @brief Decrement the current acitivity count. If the count reaches 0, stop and hide the
        activity indicator.
    @remarks Calls to @c incrementActivity and @c decrementActivity should be balanced.
 */
- (void)decrementActivity;

@end

NS_ASSUME_NONNULL_END
