//
//  AppsFlyerProvider.m
//  Pods
//
//  Created by Minh Tu Le on 7/3/14.
//
//

#import "AppsFlyerProvider.h"
#import "AppsFlyerTracker.h"


@implementation AppsFlyerProvider

- (instancetype)initWithIdentifier:(NSString *)identifier {
    return [self initWithITunesAppID:@"" key:identifier];
}

- (instancetype)initWithITunesAppID:(NSString *)iTunesAppID key:(NSString *)key {
#ifdef AR_APPSFLYER_EXISTS
    NSAssert([AppsFlyerTracker class], @"AppsFlyer is not included");
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
    [AppsFlyerTracker sharedTracker].appleAppID = iTunesAppID;
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = key;
    [AppsFlyerTracker sharedTracker].isHTTPS = YES;
#endif
    return [super init];
}

#ifdef AR_APPSEE_EXISTS

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    [AppsFlyerTracker sharedTracker].customerUserID = userID;
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [[AppsFlyerTracker sharedTracker] trackEvent:event withValue:@""];
}

#endif

@end
