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
#endif
    return [super init];
}

#ifdef AR_APPSEE_EXISTS

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    [AppsFlyerTracker sharedTracker].customerUserID = userID;
    if (email) {
        [[AppsFlyerTracker sharedTracker] setUserEmails:@[email] withCryptType:EmailCryptTypeNone];
    }
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [[AppsFlyerTracker sharedTracker] trackEvent:event withValue:@""];
}

#endif

@end

// All media sources

NSString *const kARAFAttributeKeyAFStatus = @"af_status";
NSString *const kARAFAttributeKeyAFMessage = @"af_message";
NSString *const kARAFAttributeKeyMediaSource = @"media_source";
NSString *const kARAFAttributeKeyCampaignName = @"campaign";
NSString *const kARAFAttributeKeyClickID = @"clickid";
NSString *const kARAFAttributeKeyAFSiteID = @"af_siteid";
NSString *const kARAFAttributeKeyClickTime = @"click_time";
NSString *const kARAFAttributeKeyInstallTime = @"install_time";
NSString *const kARAFAttributeKeyAgency = @"agency";

// Facebook

NSString *const kARAFAttributeKeyIsFB = @"is_fb";
NSString *const kARAFAttributeKeyFBAdGroupName = @"adgroup_name";
NSString *const kARAFAttributeKeyFBAdGroupID = @"adgroup_id";
NSString *const kARAFAttributeKeyFBCampaignID = @"campaign_id";
NSString *const kARAFAttributeKeyFBAdSetName = @"adset_name";
NSString *const kARAFAttributeKeyFBAdSetID = @"adset_id";
NSString *const kARAFAttributeKeyFBAdID = @"ad_id";

// Valid values

NSString *const kARAFAttributeAFStatusOrganic = @"Organic";
NSString *const kARAFAttributeAFStatusNonOrganic = @"Non-organic";
NSString *const kARAFAttributeAFStatusError = @"Error";
