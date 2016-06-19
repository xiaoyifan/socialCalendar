/** @file FIRFacebookAuthUI.h
    @brief Firebase Auth Facebook Provider UI SDK
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

/** @class FIRFacebookAuthUI
    @brief AuthUI components for Facebook Login.
 */
@interface FIRFacebookAuthUI : NSObject <FIRAuthProviderUI>

/** @property appId
    @brief The Facebook App ID.
 */
@property(nonatomic, copy, readonly) NSString *appID;

/** @property scopes
    @brief The scopes to use with Facebook Login.
    @remarks Defaults to using "email" scopes.
 */
@property(nonatomic, copy) NSArray<NSString *> *scopes;

/** @fn init
    @brief Please use initWithAppId:
 */
- (nullable instancetype)init NS_UNAVAILABLE;

/** @fn initWithAppID:
    @brief Designated initializer.
    @param appId The Facebook App ID.
 */
- (nullable instancetype)initWithAppID:(NSString *)appID NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
