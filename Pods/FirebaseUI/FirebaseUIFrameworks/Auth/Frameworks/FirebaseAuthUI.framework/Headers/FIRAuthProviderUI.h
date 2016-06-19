/** @file FIRAuthProviderUI.h
    @brief Firebase Auth UI SDK
    @copyright Copyright 2015 Google Inc.
    @remarks Use of this SDK is subject to the Google APIs Terms of Service:
        https://developers.google.com/terms/
 */

#import <UIKit/UIKit.h>

@class FIRAuth;
@class FIRAuthCredential;
@class FIRUserInfo;

NS_ASSUME_NONNULL_BEGIN

/** @typedef FIRAuthProviderSignInCompletionBlock
    @brief The type of block used to notify the auth system of the result of a sign-in flow.
    @see FIRAuthProvider.signInWithAuth:email:presentingViewController:completion:
 */
typedef void (^FIRAuthProviderSignInCompletionBlock)(FIRAuthCredential *_Nullable credential,
                                                     NSError *_Nullable error);

/** @protocol FIRAuthProviderUI
    @brief Represents an authentication provider (such as Google Sign In or Facebook Login) which
        can be used with the AuthUI classes (like @c FIRAuthPickerViewController).
    @remarks @c FIRAuthUI.signInProviders is populated with a list of @c FIRAuthProviderUI instances
        to provide users with sign-in options.
 */
@protocol FIRAuthProviderUI <NSObject>

/** @property providerID
    @brief A unique identifier for the provider.
 */
@property(nonatomic, copy, readonly) NSString *providerID;

/** @property shortName
    @brief A short display name for the provider.
 */
@property(nonatomic, copy, readonly) NSString *shortName;

/** @property signInLabel
    @brief A localized label for the provider's sign-in button.
 */
@property(nonatomic, copy, readonly) NSString *signInLabel;

/** @property icon
    @brief The icon image of the provider.
 */
@property(nonatomic, strong, readonly) UIImage *icon;

/** @property buttonBackgroundColor
    @brief The background color that should be used for the sign in button of the provider.
 */
@property(nonatomic, strong, readonly) UIColor *buttonBackgroundColor;

/** @property buttonTextColor
    @brief The text color that should be used for the sign in button of the provider.
 */
@property(nonatomic, strong, readonly) UIColor *buttonTextColor;

/** @fn signInWithAuth:email:presentingViewController:completion:
    @brief Called when the user wants to sign in using this auth provider.
    @remarks Implementors should invoke the completion block when the sign-in process has terminated
        or is canceled. There are two valid combinations of parameters; either @c credentials and
        @c userInfo are both non-nil, or @c error is non-nil. Errors must specify an error code
        which is one of the @c FIRAuthErrorCode codes. It is very important that all possible code
        paths eventually call this method to inform the auth system of the result of the sign-in
        flow.
    @param auth The @c FIRAuth instance which is starting the sign-in flow.
    @param email The email address of the user if it's known.
    @param presentingViewController The view controller used to present the UI.
    @param completion See remarks. A block to invoke when the sign-in process completes.
 */
- (void)signInWithAuth:(FIRAuth *)auth
                       email:(nullable NSString *)email
    presentingViewController:(nullable UIViewController *)presentingViewController
                  completion:(nullable FIRAuthProviderSignInCompletionBlock)completion;

/** @fn signOutWithAuth:
    @brief Called when the user wants to sign out.
    @param auth The @c FIRAuth instance which is starting the sign out flow.
 */
- (void)signOutWithAuth:(FIRAuth *)auth;

@optional;

/** @fn handleOpenURL:
    @brief May be used to help complete a sign-in flow which requires a callback from Safari.
    @param URL The URL which may be handled by the auth provider if an URL is expected.
    @param sourceApplication The application which tried opening the URL.
    @return YES if your auth provider handled the URL. NO otherwise.
 */
- (BOOL)handleOpenURL:(NSURL *)URL sourceApplication:(NSString *)sourceApplication;

@end

NS_ASSUME_NONNULL_END
