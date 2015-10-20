//
//  MrCoin.h
//  MrCoin IOS SDK
//
//  Created by Gabor Nagy on 04/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MrCoinViewController.h"

#import "MRCFormViewController.h"
#import "MRCFormPageViewController.h"

#import "MRCEmptyViewController.h"
#import "MRCTransferViewController.h"

#import "MRCPopUpViewController.h"
#import "MRCTextViewController.h"
#import "MRCCurrencyTableViewController.h"

#import "MRCProgressView.h"
#import "MRCTextInput.h"
#import "MRCDropDown.h"
#import "MRCButton.h"
#import "MRCCopiableButton.h"

#import "MRCAPI.h"
#import "MRCSettings.h"


#define MRCOIN_URL      @"http://www.mrcoin.eu"
#define MRCOIN_SUPPORT  @"support@mrcoin.eu"

@protocol MrCoinDelegate <NSObject>

//(nonce + request method + request path + post data)
- (NSString*) requestMessageSignature:(NSString*)message privateKey:(NSString*)privateKey;
- (NSString*) requestDestinationAddress;
- (NSString*) requestPrivateKey;
- (NSString*) requestPublicKey;

@optional
- (void) openURL:(NSURL*)url;
- (void) sendMail:(NSString*)to subject:(NSString*)subject;

- (void)showErrors:(NSArray*)errors type:(MRCAPIErrorType)type;
- (void) hideErrorsPopup;
- (void) showActivityIndicator:(NSString*)message;
- (void) hideActivityIndicator;
@end

@interface MrCoin : NSObject

@property (strong, readonly) MRCAPI *api;
@property MrCoinViewController* rootController;
@property id <MrCoinDelegate> delegate;
@property BOOL needsAcceptTerms;

// Customizable
+ (void) customBundle:(NSBundle*)customBundle;

+ (void)show:(id)target; // Valid target is window
+ (MRCTextViewController*)documentViewController:(MrCoinDocumentType)type;

+ (MrCoinViewController*) rootController;
+ (instancetype) sharedController;
+ (UIStoryboard*) storyboard;
+ (UIViewController*) viewController:(NSString*)named;
+ (MRCSettings*) settings;

- (UIStoryboard*) storyboard;
- (UIViewController*) viewController:(NSString*)named;
- (MRCSettings*) settings;

+ (UIImage*) imageNamed:(NSString*)named;

+ (MRCAPI *)api;

- (void) openURL:(NSURL*)url;
- (void) sendMail:(NSString*)to subject:(NSString*)subject;

+ (NSBundle *)frameworkBundle;
- (NSString*) localizedString:(NSString*)key;


- (void)showErrorPopup:(NSString*)title message:(NSString*)message;
- (void)showErrorPopup:(NSString*)title;
- (void)showErrors:(NSArray*)errors type:(MRCAPIErrorType)type;
- (void)hideErrorPopup;

- (void)showActivityIndicator:(NSString*)message;
- (void)showActivityIndicator;
- (void)hideActivityIndicator;
@end