//
//  ARAnalytics.m
//  Art.sy
//
//  Created by orta therox on 18/12/2012.
//  Copyright (c) 2012 Art.sy. All rights reserved.
//

#import "ARAnalytics.h"
#import "ARAnalyticalProvider.h"
#import "ARAnalyticsProviders.h"

static ARAnalytics *_sharedAnalytics;

@interface ARAnalytics ()
@property (strong) NSMutableDictionary *eventsDictionary;
@property (strong) NSMutableDictionary *eventsPropertiesDictionary;
@property (strong) NSSet *providers;
@end

#if TARGET_OS_IPHONE
#import "ARNavigationControllerDelegateProxy.h"
@interface ARAnalytics ()
{
    ARNavigationControllerDelegateProxy *_proxyDelegate;
}
@property (strong, readonly) ARNavigationControllerDelegateProxy *proxyDelegate;
@end
#endif

#if !TARGET_OS_IPHONE
@implementation UIViewController @end
@implementation UINavigationController @end
#endif

@implementation ARAnalytics

+ (void) initialize {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _sharedAnalytics = [[ARAnalytics alloc] init];
        _sharedAnalytics.providers = [NSSet set];
    });
}

- (NSMutableDictionary *)eventsDictionary {
    if (!_eventsDictionary) {
        _eventsDictionary = [NSMutableDictionary dictionary];
    }
    return _eventsDictionary;
}

- (NSMutableDictionary *)eventsPropertiesDictionary {
    if (!_eventsPropertiesDictionary) {
        _eventsPropertiesDictionary = [NSMutableDictionary dictionary];
    }
    return _eventsPropertiesDictionary;
}

#pragma mark -
#pragma mark Analytics Setup

// By using the constants at the bottom you can

+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary {
    if (analyticsDictionary[ARTestFlightAppToken]) {
        [self setupTestFlightWithAppToken:analyticsDictionary[ARTestFlightAppToken]];
    }
    
    if (analyticsDictionary[ARFlurryAPIKey]) {
        [self setupFlurryWithAPIKey:analyticsDictionary[ARFlurryAPIKey]];
    }
    
    if (analyticsDictionary[ARGoogleAnalyticsID]) {
        [self setupGoogleAnalyticsWithID:analyticsDictionary[ARGoogleAnalyticsID]];
    }
    
    if (analyticsDictionary[ARKISSMetricsAPIKey]) {
        [self setupKISSMetricsWithAPIKey:analyticsDictionary[ARKISSMetricsAPIKey]];
    }
    
    if (analyticsDictionary[ARLocalyticsAppKey]) {
        [self setupLocalyticsWithAppKey:analyticsDictionary[ARLocalyticsAppKey]];
    }
    
    if (analyticsDictionary[ARMixpanelToken]) {
        // ARMixpanelHost is nil if you want the default provider. So we can make
        // the presumption of it here.
        [self setupMixpanelWithToken:analyticsDictionary[ARMixpanelToken] andHost:analyticsDictionary[ARMixpanelHost]];
    }
    
    if (analyticsDictionary[ARCountlyAppKey] && analyticsDictionary[ARCountlyHost]) {
        [self setupCountlyWithAppKey:analyticsDictionary[ARCountlyAppKey] andHost:analyticsDictionary[ARCountlyHost]];
    }
    
    if (analyticsDictionary[ARBugsnagAPIKey]) {
        [self setupBugsnagWithAPIKey:analyticsDictionary[ARBugsnagAPIKey]];
    }
    
    if (analyticsDictionary[ARHelpshiftAppID] && analyticsDictionary[ARHelpshiftDomainName] && analyticsDictionary[ARHelpshiftAPIKey]) {
        [self setupHelpshiftWithAppID:analyticsDictionary[ARHelpshiftAppID] domainName:analyticsDictionary[ARHelpshiftDomainName] apiKey:analyticsDictionary[ARHelpshiftAPIKey]];
    }
    
    if (analyticsDictionary[ARTapstreamAccountName] && analyticsDictionary[ARTapstreamDeveloperSecret]) {
        [self setupTapstreamWithAccountName:analyticsDictionary[ARTapstreamAccountName] developerSecret:analyticsDictionary[ARTapstreamDeveloperSecret] config:analyticsDictionary[ARTapstreamConfig]];
    }
    
    if (analyticsDictionary[ARNewRelicAppToken]) {
        [self setupNewRelicWithAppToken:analyticsDictionary[ARNewRelicAppToken]];
    }
    
    if (analyticsDictionary[ARAmplitudeAPIKey]) {
        [self setupAmplitudeWithAPIKey:analyticsDictionary[ARAmplitudeAPIKey]];
    }
    
    if (analyticsDictionary[ARHockeyAppBetaID]) {
        [self setupHockeyAppWithBetaID:analyticsDictionary[ARHockeyAppBetaID] liveID:analyticsDictionary[ARHockeyAppLiveID]];
    }
    
    if (analyticsDictionary[ARParseApplicationID] && analyticsDictionary[ARParseClientKey]) {
        [self setupParseAnalyticsWithApplicationID:analyticsDictionary[ARParseApplicationID] clientKey:analyticsDictionary[ARParseClientKey]];
    }
    
    if (analyticsDictionary[ARHeapAppID]) {
        [self setupHeapAnalyticsWithApplicationID:analyticsDictionary[ARHeapAppID]];
    }
    
    if (analyticsDictionary[ARChartbeatID]) {
        [self setupChartbeatWithApplicationID:analyticsDictionary[ARChartbeatID]];
    }
    
    if (analyticsDictionary[ARUMengAnalyticsID]) {
        [self setupUMengAnalyticsIDWithAppkey:analyticsDictionary[ARUMengAnalyticsID]];
    }
    
    if (analyticsDictionary[ARLibratoEmail] && analyticsDictionary[ARLibratoToken]) {
        [self setupLibratoWithEmail:analyticsDictionary[ARLibratoEmail] token:analyticsDictionary[ARLibratoToken] prefix:analyticsDictionary[ARLibratoPrefix]];
    }
    
    if (analyticsDictionary[ARAppseeAPIKey]) {
        [self setupAppseeWithAPIKey:analyticsDictionary[ARAppseeAPIKey] regressProperties:[analyticsDictionary[ARAppseeRegressProperties] boolValue]];
    }
    
    if (analyticsDictionary[ARAppsFlyerKey] && analyticsDictionary[ARItuneAppID]) {
        [self setupAppsFlyerWithITunesAppID:analyticsDictionary[ARItuneAppID] key:analyticsDictionary[ARAppsFlyerKey]];
    }

    if (analyticsDictionary[ARIntercomApiKey] && analyticsDictionary[ARIntercomAppId]) {
        [self setupIntercomWithApiKey:analyticsDictionary[ARIntercomApiKey]
                             forAppId:analyticsDictionary[ARIntercomAppId]];
    }
    
    // Crashlytics / Crittercism should stay at the bottom of this,
    // as they both need to register exceptions, and you'd only use one.
    
    if (analyticsDictionary[ARCrashlyticsAPIKey]) {
        [self setupCrashlyticsWithAPIKey:analyticsDictionary[ARCrashlyticsAPIKey]];
    }
    
    if (analyticsDictionary[ARCrittercismAppID]) {
        [self setupCrittercismWithAppID:analyticsDictionary[ARCrittercismAppID]];
    }
}

+ (void)setupProvider:(ARAnalyticalProvider*)provider {
    _sharedAnalytics.providers = [_sharedAnalytics.providers setByAddingObject:provider];
}

+ (void)removeProvider:(ARAnalyticalProvider *)provider {
    NSMutableSet *mutableSet = [NSMutableSet setWithSet:_sharedAnalytics.providers];
    [mutableSet removeObject:provider];
    _sharedAnalytics.providers = mutableSet.copy;
}

+ (NSSet *)currentProviders
{
    return _sharedAnalytics.providers;
}

+ (void)setupTestFlightWithAppToken:(NSString *)token {
#ifdef AR_TESTFLIGHT_EXISTS
    TestFlightProvider *provider = [[TestFlightProvider alloc] initWithIdentifier:token];
    [self setupProvider:provider];
#endif
}

+ (void)setupCrashlyticsWithAPIKey:(NSString *)key {
#ifdef AR_CRASHLYTICS_EXISTS
    CrashlyticsProvider *provider = [[CrashlyticsProvider alloc] initWithIdentifier:key];
    [self setupProvider:provider];
#endif
}

+ (void)setupMixpanelWithToken:(NSString *)token {
#ifdef AR_MIXPANEL_EXISTS
    [self setupMixpanelWithToken:token andHost:nil];
#endif
}

+ (void)setupMixpanelWithToken:(NSString *)token andHost:(NSString *)host {
#ifdef AR_MIXPANEL_EXISTS
    MixpanelProvider *provider = [[MixpanelProvider alloc] initWithIdentifier:token andHost:host];
    [self setupProvider:provider];
#endif
}

+ (void)setupFlurryWithAPIKey:(NSString *)key {
#ifdef AR_FLURRY_EXISTS
    FlurryProvider *provider = [[FlurryProvider alloc] initWithIdentifier:key];
    [self setupProvider:provider];
#endif
}

+ (void)setupGoogleAnalyticsWithID:(NSString *)identifier {
#ifdef AR_GOOGLEANALYTICS_EXISTS
    GoogleAnalyticsProvider *provider = [[GoogleAnalyticsProvider alloc] initWithIdentifier:identifier];
    [self setupProvider:provider];
#endif
}

+ (void)setupLocalyticsWithAppKey:(NSString *)key {
#ifdef AR_LOCALYTICS_EXISTS
    LocalyticsProvider *provider = [[LocalyticsProvider alloc] initWithIdentifier:key];
    [self setupProvider:provider];
#endif
}

+ (void)setupKISSMetricsWithAPIKey:(NSString *)key {
#ifdef AR_KISSMETRICS_EXISTS
    KISSMetricsProvider *provider = [[KISSMetricsProvider alloc] initWithIdentifier:key];
    [self setupProvider:provider];
#endif
}

+ (void)setupCrittercismWithAppID:(NSString *)appID {
#ifdef AR_CRITTERCISM_EXISTS
    CrittercismProvider *provider = [[CrittercismProvider alloc] initWithIdentifier:appID];
    [self setupProvider:provider];
#endif
}

+ (void)setupCountlyWithAppKey:(NSString *)key andHost:(NSString *)host {
#ifdef AR_COUNTLY_EXISTS
    CountlyProvider *provider = [[CountlyProvider alloc] initWithAppKey:key andHost:host];
    [self setupProvider:provider];
#endif
}

+ (void)setupBugsnagWithAPIKey:(NSString *)key {
#ifdef AR_BUGSNAG_EXISTS
    BugsnagProvider *provider = [[BugsnagProvider alloc] initWithIdentifier:key];
    [self setupProvider:provider];
#endif
}

+ (void)setupHelpshiftWithAppID:(NSString *)appID domainName:(NSString *)domainName apiKey:(NSString *)apiKey {
#ifdef AR_HELPSHIFT_EXISTS
    HelpshiftProvider *provider = [[HelpshiftProvider alloc] initWithAppID:appID domainName:domainName apiKey:apiKey];
    [self setupProvider:provider];
#endif
}

+ (void)setupTapstreamWithAccountName:(NSString *)accountName developerSecret:(NSString *)developerSecret {
#ifdef AR_TAPSTREAM_EXISTS
    TapstreamProvider *provider = [[TapstreamProvider alloc] initWithAccountName:accountName developerSecret:developerSecret];
    [self setupProvider:provider];
#endif
}

+ (void)setupTapstreamWithAccountName:(NSString *)accountName developerSecret:(NSString *)developerSecret config:(TSConfig *)config {
#ifdef AR_TAPSTREAM_EXISTS
    TapstreamProvider *provider = [[TapstreamProvider alloc] initWithAccountName:accountName developerSecret:developerSecret config:config];
    [self setupProvider:provider];
#endif
}

+ (void)setupNewRelicWithAppToken:(NSString *)token {
#ifdef AR_NEWRELIC_EXISTS
    NewRelicProvider *provider = [[NewRelicProvider alloc] initWithIdentifier:token];
    [self setupProvider:provider];
#endif
}

+ (void)setupAmplitudeWithAPIKey:(NSString *)key {
#ifdef AR_AMPLITUDE_EXISTS
    AmplitudeProvider *provider = [[AmplitudeProvider alloc] initWithIdentifier:key];
    [self setupProvider:provider];
#endif
}

+ (void)setupHockeyAppWithBetaID:(NSString *)betaID {
#ifdef AR_HOCKEYAPP_EXISTS
    [self setupHockeyAppWithBetaID:betaID liveID:nil];
#endif
}

+ (void)setupHockeyAppWithBetaID:(NSString *)betaID liveID:(NSString *)liveID {
#ifdef AR_HOCKEYAPP_EXISTS
    HockeyAppProvider *provider = [[HockeyAppProvider alloc] initWithBetaIdentifier:betaID liveIdentifier:liveID];
    [self setupProvider:provider];
#endif
}

+(void)setupParseAnalyticsWithApplicationID:(NSString *)appID clientKey:(NSString *)clientKey {
#ifdef AR_PARSEANALYTICS_EXISTS
    ParseAnalyticsProvider *provider = [[ParseAnalyticsProvider alloc] initWithApplicationID:appID clientKey:clientKey];
    [self setupProvider:provider];
#endif
}

+ (void)setupHeapAnalyticsWithApplicationID:(NSString *)appID {
#ifdef AR_HEAPANALYTICS_EXISTS
    HeapAnalyticsProvider *provider = [[HeapAnalyticsProvider alloc] initWithIdentifier:appID];
    [self setupProvider:provider];
#endif
}

+ (void)setupChartbeatWithApplicationID:(NSString *)appID {
#ifdef AR_CHARTBEAT_EXISTS
    ChartbeatProvider *provider = [[ChartbeatProvider alloc] initWithIdentifier:appID];
    [self setupProvider:provider];
#endif
}

+ (void)setupAppseeWithAPIKey:(NSString *)key regressProperties:(BOOL)shouldRegressProperties{
#ifdef AR_APPSEE_EXISTS
    AppseeProvider *provider = [[AppseeProvider alloc] initWithIdentifier:key];
    provider.shouldRegressProperties = shouldRegressProperties;
    [self setupProvider:provider];
#endif
}

+ (void)setupAppsFlyerWithITunesAppID:(NSString *)iTunesAppID key:(NSString *)key {
#ifdef AR_APPSFLYER_EXISTS
    AppsFlyerProvider *provider = [[AppsFlyerProvider alloc] initWithITunesAppID:iTunesAppID key:key];
    [self setupProvider:provider];
#endif
}

+ (void)setupUMengAnalyticsIDWithAppkey:(NSString *)appID {
#ifdef AR_UMENGANALYTICS_EXISTS
    UMengAnalyticsProvider *provider = [[UMengAnalyticsProvider alloc] initWithIdentifier:appID];
    [self setupProvider:provider];
#endif
}

+ (void)setupLibratoWithEmail:(NSString *)email token:(NSString *)token prefix:(NSString *)prefix {
#ifdef AR_LIBRATO_EXISTS
    LibratoProvider *provider = [[LibratoProvider alloc] initWithEmail:email token:token prefix:prefix];
    [self setupProvider:provider];
#endif
}

+ (void)setupIntercomWithApiKey:(NSString *)apiKey forAppId:(NSString *)appId {
#ifdef AR_INTERCOM_EXISTS
    IntercomProvider *provider = [[IntercomProvider alloc] initWithApiKey:apiKey forAppId:appId];
    [self setupProvider:provider]; 
#endif
}

#pragma mark -
#pragma mark User Setup

// deprecated; use the one without the typo
+ (void)identifyUserwithID:(NSString *)userID andEmailAddress:(NSString *)email {
    [self identifyUserWithID:userID andEmailAddress:email];
}


+ (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider identifyUserWithID:userID andEmailAddress:email];
    }];
}

+ (void)setUserProperty:(NSString *)property toValue:(NSString *)value {
    if (value == nil) {
        NSLog(@"ARAnalytics: Value cannot be nil ( %@ ) ", property);
        return;
    }
    
    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider setUserProperty:property toValue:value];
    }];
}

+ (void)incrementUserProperty:(NSString *)counterName byInt:(NSInteger)amount {
    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider incrementUserProperty:counterName byInt:@(amount)];
    }];
}

#pragma mark -
#pragma mark Super Properties

+ (void)addSuperProperties:(NSDictionary *)dictionary {
    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider addSuperProperties:dictionary];
    }];
}

+ (void)removeSuperProperties:(NSString *)propertyName {
    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider removeSuperProperty:propertyName];
    }];
}

+ (void)clearSuperProperties {
    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider clearSuperProperties];
    }];
}

+ (NSDictionary *)_combinePropertiesWithLocalizedHour:(NSDictionary *)properties {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"HH"];
    NSString *hour = [dateFormatter stringFromDate:date];
    NSMutableDictionary *combinedProperties = [NSMutableDictionary dictionaryWithDictionary:properties];
    [combinedProperties addEntriesFromDictionary:@{
                                                   @"localized hour" : hour,
                                                   }];
    return combinedProperties;
}

#pragma mark -
#pragma mark Events


+ (void)event:(NSString *)event {
    [self event:event withProperties:nil];
}

+ (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    NSDictionary *combinedProperties = [_sharedAnalytics mergeProperties:[ARAnalytics _combinePropertiesWithLocalizedHour:properties] forEvent:event];
    
    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider event:event withProperties:combinedProperties];
    }];
}

#pragma mark -
#pragma mark Errors

+ (void)error:(NSError *)error {
    [self error:error withMessage:nil];
}

+ (void)error:(NSError *)error withMessage:(NSString *)message {
    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider error:error withMessage:message];
    }];
}

#pragma mark -
#pragma mark Monitor Navigation Controller

+ (void)pageView:(NSString *)pageTitle {
    if (!pageTitle) return;
    
    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider didShowNewPageView:pageTitle];
    }];
}

+ (void)pageView:(NSString *)pageTitle withProperties:(NSDictionary *)properties {
    if (!pageTitle) return;
    
    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider didShowNewPageView:pageTitle withProperties:properties];
    }];
}

+ (void)monitorNavigationViewController:(UINavigationController *)controller {
    [self monitorNavigationController:controller];
}

+ (void)monitorNavigationController:(UINavigationController *)controller {
    
#if TARGET_OS_IPHONE
    // Set a new original delegate on the proxy
    _sharedAnalytics.proxyDelegate.originalDelegate = controller.delegate;
    // Then set the new controllers delegate as the proxy
    controller.delegate = _sharedAnalytics.proxyDelegate;
#endif
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
#if TARGET_OS_IPHONE
    [self.class pageView:viewController.title];
#endif
}

#if TARGET_OS_IPHONE
/// Lazily loaded
- (ARNavigationControllerDelegateProxy *)proxyDelegate
{
    if (!_proxyDelegate) {
        _proxyDelegate = [[ARNavigationControllerDelegateProxy alloc] initWithAnalyticsDelegate:self];
    }
    return _proxyDelegate;
}
#endif

#pragma mark -
#pragma mark Timing Events

+ (void)startTimingEvent:(NSString *)event withProperties:(NSDictionary *)properties {
    _sharedAnalytics.eventsDictionary[event] = [NSDate date];
    
    if (properties) {
        _sharedAnalytics.eventsPropertiesDictionary[event] = properties;
    }
}

+ (void)startTimingEvent:(NSString *)event {
    [ARAnalytics startTimingEvent:event withProperties:nil];
}

+ (void)finishTimingEvent:(NSString *)event {
    [self finishTimingEvent:event withProperties:nil];
}

+(void)finishTimingEvent:(NSString *)event withProperties:(NSDictionary *)properties {
    NSDate *startDate = _sharedAnalytics.eventsDictionary[event];
    if (!startDate) {
        NSLog(@"ARAnalytics: finish timing event called without a corrosponding start timing event");
        return;
    }
    
    NSTimeInterval eventInterval = [[NSDate date] timeIntervalSinceDate:startDate];
    [_sharedAnalytics.eventsDictionary removeObjectForKey:event];
    
    NSDictionary *combinedProperties = [_sharedAnalytics mergeProperties:properties forEvent:event];
    [_sharedAnalytics.eventsPropertiesDictionary removeObjectForKey:event];
    
    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider logTimingEvent:event withInterval:@(eventInterval) properties:combinedProperties];
    }];
}

+ (BOOL)isTrackingEvent:(NSString *)event {
    return _sharedAnalytics.eventsDictionary[event] != nil
    || _sharedAnalytics.eventsPropertiesDictionary[event] != nil;
}

+ (void)addProperties:(NSDictionary *)properties forEvent:(NSString *)event {
    _sharedAnalytics.eventsPropertiesDictionary[event] = [_sharedAnalytics mergeProperties:properties
                                                                                  forEvent:event];
}

+ (void)removePropertiesForEvent:(NSString *)event {
    [_sharedAnalytics.eventsPropertiesDictionary removeObjectForKey:event];
}


#pragma mark -
#pragma mark Util

- (void)iterateThroughProviders:(void(^)(ARAnalyticalProvider *provider))providerBlock {
    for (ARAnalyticalProvider *provider in _providers) {
        providerBlock(provider);
    }
}

- (NSDictionary *)mergeProperties:(NSDictionary *)properties forEvent:(NSString *)event {
    NSDictionary *savedProperties = _sharedAnalytics.eventsPropertiesDictionary[event];
    if (!savedProperties) {
        return properties;
    }
    
    NSMutableDictionary *combinedProperties = [NSMutableDictionary dictionaryWithDictionary:savedProperties];
    [combinedProperties addEntriesFromDictionary:properties];
    
    return [combinedProperties copy];
}

@end

void ARLog (NSString *format, ...) {
    if (format == nil) {
        printf("nil \n");
        return;
    }
    // Get a reference to the arguments that follow the format parameter
    va_list argList;
    va_start(argList, format);
    // Perform format string argument substitution, reinstate %% escapes, then print
    
    @autoreleasepool {
        NSString *parsedFormatString = [[NSString alloc] initWithFormat:format arguments:argList];
        parsedFormatString = [parsedFormatString stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"];
        printf("ARLog : %s\n", parsedFormatString.UTF8String);
        
        [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
            [provider remoteLog:parsedFormatString];
        }];
    }
    
    va_end(argList);
}

void ARAnalyticsEvent (NSString *event, NSDictionary *properties) {
    @try {
        [ARAnalytics event:event withProperties:properties];
    }
    
    @catch (NSException *exception) {
        NSLog(@"ARAnalytics: Exception raised when handling event %@ - %@ - %@", event, exception.name, exception.reason);
    }
}

NSString *const ARCountlyAppKey = @"ARCountlyAppKey";
NSString *const ARCountlyHost = @"ARCountlyHost";
NSString *const ARTestFlightAppToken = @"ARTestFlight";
NSString *const ARCrashlyticsAPIKey = @"ARCrashlytics";
NSString *const ARMixpanelToken = @"ARMixpanel";
NSString *const ARMixpanelHost = @"ARMixpanelHost";
NSString *const ARFlurryAPIKey = @"ARFlurry";
NSString *const ARBugsnagAPIKey = @"ARBugsnag";
NSString *const ARLocalyticsAppKey = @"ARLocalytics";
NSString *const ARKISSMetricsAPIKey = @"ARKISSMetrics";
NSString *const ARCrittercismAppID = @"ARCrittercism";
NSString *const ARGoogleAnalyticsID = @"ARGoogleAnalytics";
NSString *const ARHelpshiftAppID = @"ARHelpshiftAppID";
NSString *const ARHelpshiftDomainName = @"ARHelpshiftDomainName";
NSString *const ARHelpshiftAPIKey = @"ARHelpshiftAPIKey";
NSString *const ARTapstreamAccountName = @"ARTapstreamAccountName";
NSString *const ARTapstreamDeveloperSecret = @"ARTapstreamDeveloperSecret";
NSString *const ARTapstreamConfig = @"ARTapstreamConfig";
NSString *const ARNewRelicAppToken = @"ARNewRelicAppToken";
NSString *const ARAmplitudeAPIKey = @"ARAmplitudeAPIKey";
NSString *const ARHockeyAppLiveID = @"ARHockeyAppLiveID";
NSString *const ARHockeyAppBetaID = @"ARHockeyAppBetaID";
NSString *const ARParseApplicationID = @"ARParseApplicationID";
NSString *const ARParseClientKey = @"ARParseClientKey";
NSString *const ARHeapAppID = @"ARHeapAppID";
NSString *const ARChartbeatID = @"ARChartbeatID";
NSString *const ARAppseeRegressProperties = @"ARAppseeRegressProperties";
NSString *const ARAppseeAPIKey = @"ARAppseeAPIKey";
NSString *const ARAppsFlyerKey = @"ARAppsFlyerKey";
NSString *const ARItuneAppID = @"ARItuneAppID";
NSString *const ARUMengAnalyticsID = @"ARUMengAnalyticsID";
NSString *const ARLibratoEmail = @"ARLibratoEmail";
NSString *const ARLibratoToken = @"ARLibratoToken";
NSString *const ARLibratoPrefix = @"ARLibratoPrefix";
NSString *const ARIntercomApiKey = @"ARInteSetuprcomApiKey";
NSString *const ARIntercomAppId = @"ARIntercomAppId";
