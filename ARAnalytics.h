//
//  ARAnalytics.h
//  Art.sy
//
//  Created by Orta Therox on 18/12/2012.
//  Copyright (c) 2012 - Present Orta Therox & Art.sy. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

// For OS X support we need to mock up UIVIewController/UINavigationViewController

#if !TARGET_OS_IPHONE
@interface UIViewController : NSObject @end
@interface UINavigationController : NSObject @end
@protocol UINavigationControllerDelegate <NSObject> @end
#endif

@class TSConfig;
@class ARAnalyticalProvider;

/**
 @class
 ARAnalytics Main Class.
 
 @abstract
 The primary interface for dealing with in app Analytics.
 
 @discussion
 Use the ARAnalytics class to set up your analytics provider and track events.
 
 <pre>
 
 [ARAnalytics setupWithAnalytics: @{
 ARCrittercismAppID : @"KEY",
 ARKISSMetricsAPIKey : @"KEY",
 ARGoogleAnalyticsID : @"KEY"
 }];
 
 </pre>
 
 For more advanced usage, please see the <a
 href="https://github.com/orta/ARAnalytics">ARAnalytics Readme</a>.
 */

@interface ARAnalytics : NSObject <UINavigationControllerDelegate>

/// A global setup analytics API, keys are provided at the bottom of the documentation.
+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary;

/// Setup methods for each individual analytics providers
+ (void)setupTestFlightWithAppToken:(NSString *)token;
+ (void)setupCrashlyticsWithAPIKey:(NSString *)key;
+ (void)setupMixpanelWithToken:(NSString *)token;
+ (void)setupMixpanelWithToken:(NSString *)token andHost:(NSString *)host;
+ (void)setupFlurryWithAPIKey:(NSString *)key;
+ (void)setupGoogleAnalyticsWithID:(NSString *)identifier;
+ (void)setupLocalyticsWithAppKey:(NSString *)key;
+ (void)setupKISSMetricsWithAPIKey:(NSString *)key;
+ (void)setupCrittercismWithAppID:(NSString *)appID;
+ (void)setupCountlyWithAppKey:(NSString *)key andHost:(NSString *)host;
+ (void)setupBugsnagWithAPIKey:(NSString *)key;
+ (void)setupHelpshiftWithAppID:(NSString *)appID domainName:(NSString *)domainName apiKey:(NSString *)apiKey;
+ (void)setupTapstreamWithAccountName:(NSString *)accountName developerSecret:(NSString *)developerSecret;
+ (void)setupTapstreamWithAccountName:(NSString *)accountName developerSecret:(NSString *)developerSecret config:(TSConfig *)config;
+ (void)setupNewRelicWithAppToken:(NSString *)token;
+ (void)setupAmplitudeWithAPIKey:(NSString *)key;
+ (void)setupHockeyAppWithBetaID:(NSString *)betaID;
+ (void)setupHockeyAppWithBetaID:(NSString *)beta liveID:(NSString *)liveID;
+ (void)setupParseAnalyticsWithApplicationID:(NSString *)appID clientKey:(NSString *)clientKey;
+ (void)setupHeapAnalyticsWithApplicationID:(NSString *)appID;
+ (void)setupChartbeatWithApplicationID:(NSString *)appID;
+ (void)setupAppseeWithAPIKey:(NSString *)key regressProperties:(BOOL)shouldRegressProperties;
+ (void)setupAppsFlyerWithITunesAppID:(NSString *)iTunesAppID key:(NSString *)key;
+ (void)setupLibratoWithEmail:(NSString *)email token:(NSString *)token prefix:(NSString *)prefix;
+ (void)setupIntercomWithApiKey:(NSString *)apiKey forAppId:(NSString *)appId;

/// Add a provider manually
+ (void)setupProvider:(ARAnalyticalProvider *)provider;

/// Remove a provider manually
+ (void)removeProvider:(ARAnalyticalProvider *)provider;

/// Show all current providers
+ (NSSet *)currentProviders;


/// Set a per user property
/// @warning Deprecated, will be removed in next major release
+ (void)identifyUserwithID:(NSString *)userID andEmailAddress:(NSString *)email __attribute__((deprecated));

/// Register a user and an associated email address, it is fine to send nils for either.
+ (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email;

/// Set a per user property
+ (void)setUserProperty:(NSString *)property toValue:(NSString *)value;

/// Adds to a user property if support exists in the provider
+ (void)incrementUserProperty:(NSString *)counterName byInt:(NSInteger)amount;

/// Adds super properites
+ (void)addSuperProperties:(NSDictionary *)dictionary;

/// Removes a super property
+ (void)removeSuperProperties:(NSString *)propertyName;

/// Clears all super properties
+ (void)clearSuperProperties;

/// Submit user events to providers
+ (void)event:(NSString *)event;

/// Submit user events to providers with additional properties
+ (void)event:(NSString *)event withProperties:(NSDictionary *)properties;

/// Submit errors to providers
+ (void)error:(NSError *)error;

/// Submit errors to providers with an associated message
+ (void)error:(NSError *)error withMessage:(NSString *)message;

/// Monitor Navigation changes as page view
+ (void)pageView:(NSString *)pageTitle;
+ (void)pageView:(NSString *)pageTitle withProperties:(NSDictionary *)properties;


#if TARGET_OS_IPHONE
/// Monitor a navigation controller, submitting each [ARAnalytics pageView:] on didShowViewController
/// @warning Deprecated in favour of monitorNavigationController:
+ (void)monitorNavigationViewController:(UINavigationController *)controller __attribute__((deprecated));

/// Monitor a navigation controller, submitting each [ARAnalytics pageView:] on didShowViewController
+ (void)monitorNavigationController:(UINavigationController *)controller;
#endif

/// Let ARAnalytics deal with the timing of an event
+ (void)startTimingEvent:(NSString *)event;

/// @warning the properites must not contain the key string `length` .
+ (void)startTimingEvent:(NSString *)event withProperties:(NSDictionary *)properties;

/// Trigger a finishing event for the timing
+ (void)finishTimingEvent:(NSString *)event;

+ (BOOL)isTrackingEvent:(NSString *)event;

/// @warning the properites must not contain the key string `length` .
+ (void)finishTimingEvent:(NSString *)event withProperties:(NSDictionary *)properties;

+ (void)addProperties:(NSDictionary *)properties forEvent:(NSString *)event;

+ (void)removePropertiesForEvent:(NSString *)event;

@end

/// an NSLog-like command that send to providers
extern void ARLog (NSString *format, ...);

/// A try-catch for nil protection wrapped event
extern void ARAnalyticsEvent (NSString *event, NSDictionary *properties);

/// Provide keys for the setupWithDictionary
extern NSString *const ARCountlyAppKey;
extern NSString *const ARCountlyHost;
extern NSString *const ARTestFlightAppToken;
extern NSString *const ARCrashlyticsAPIKey;
extern NSString *const ARMixpanelToken;
extern NSString *const ARMixpanelHost;
extern NSString *const ARFlurryAPIKey;
extern NSString *const ARLocalyticsAppKey;
extern NSString *const ARKISSMetricsAPIKey;
extern NSString *const ARBugsnagAPIKey;
extern NSString *const ARCrittercismAppID;
extern NSString *const ARGoogleAnalyticsID;
extern NSString *const ARHelpshiftAppID;
extern NSString *const ARHelpshiftDomainName;
extern NSString *const ARHelpshiftAPIKey;
extern NSString *const ARTapstreamAccountName;
extern NSString *const ARTapstreamDeveloperSecret;
extern NSString *const ARTapstreamConfig;
extern NSString *const ARNewRelicAppToken;
extern NSString *const ARAmplitudeAPIKey;
extern NSString *const ARHockeyAppBetaID;
extern NSString *const ARHockeyAppLiveID;
extern NSString *const ARParseApplicationID;
extern NSString *const ARParseClientKey;
extern NSString *const ARHeapAppID;
extern NSString *const ARChartbeatID;
extern NSString *const ARAppseeRegressProperties;
extern NSString *const ARAppseeAPIKey;
extern NSString *const ARAppsFlyerKey;
extern NSString *const ARItuneAppID;
extern NSString *const ARUMengAnalyticsID;
extern NSString *const ARLibratoEmail;
extern NSString *const ARLibratoToken;
extern NSString *const ARLibratoPrefix;
extern NSString *const ARIntercomApiKey;
extern NSString *const ARIntercomAppId;
