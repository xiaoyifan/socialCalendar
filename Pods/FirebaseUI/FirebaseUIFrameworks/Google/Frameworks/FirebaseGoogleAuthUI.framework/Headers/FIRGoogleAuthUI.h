/** @file FIRGoogleAuthUI.h
    @brief Firebase Auth Google Provider UI SDK
    @copyright Copyright 2016 Google Inc.
    @remarks Use of this SDK is subject to the Google APIs Terms of Service:
        https://developers.google.com/terms/
 */

#import <Foundation/Foundation.h>

#if __has_feature(modules)
@import FirebaseAuthUI;
#else
#import <FirebaseAuthUI/FIRAuthProviderUI.h>
#endif

NS_ASSUME_NONNULL_BEGIN

/** @class FIRGoogleAuthUI
    @brief AuthUI components for Google Sign In.
 */
@interface FIRGoogleAuthUI : NSObject <FIRAuthProviderUI>

/** @property clientID
    @brief The Google Sign In client ID.
 */
@property(nonatomic, copy, readonly) NSString *clientID;

/** @property scopes
    @brief The scopes to use with Google Sign In.
    @remarks Defaults to using "email" and "profile" scopes.
 */
@property(nonatomic, copy) NSArray<NSString *> *scopes;

/** @fn init
    @brief Please use initWithClientId:
 */
- (nullable instancetype)init NS_UNAVAILABLE;

/** @fn initWithClientID:
    @brief Designated initializer.
    @param clientId The Google Sign In client ID.
 */
- (nullable instancetype)initWithClientID:(NSString *)clientID NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
