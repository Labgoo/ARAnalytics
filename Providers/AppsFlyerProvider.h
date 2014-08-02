//
//  AppsFlyerProvider.h
//  Pods
//
//  Created by Minh Tu Le on 7/3/14.
//
//

#import "ARAnalyticalProvider.h"

@interface AppsFlyerProvider : ARAnalyticalProvider

- (instancetype)initWithITunesAppID:(NSString *)iTunesAppID key:(NSString *)key;

@end

// Key names are taken from the following guide
// http://support.appsflyer.com/entries/69796693-Accessing-AppsFlyer-Attribution-Conversion-Data-from-the-SDK-Deferred-Deep-linking-

// All media sources

extern NSString *const kARAFAttributeKeyAFStatus;
extern NSString *const kARAFAttributeKeyAFMessage;
extern NSString *const kARAFAttributeKeyMediaSource;
extern NSString *const kARAFAttributeKeyCampaignName;
extern NSString *const kARAFAttributeKeyClickID;
extern NSString *const kARAFAttributeKeyAFSiteID;
extern NSString *const kARAFAttributeKeyClickTime;
extern NSString *const kARAFAttributeKeyInstallTime;
extern NSString *const kARAFAttributeKeyAgency;

// Facebook

extern NSString *const kARAFAttributeKeyIsFB;
extern NSString *const kARAFAttributeKeyFBAdGroupName;
extern NSString *const kARAFAttributeKeyFBAdGroupID;
extern NSString *const kARAFAttributeKeyFBCampaignID;
extern NSString *const kARAFAttributeKeyFBAdSetName;
extern NSString *const kARAFAttributeKeyFBAdSetID;
extern NSString *const kARAFAttributeKeyFBAdID;

// Valid values

extern NSString *const kARAFAttributeAFStatusOrganic;
extern NSString *const kARAFAttributeAFStatusNonOrganic;
extern NSString *const kARAFAttributeAFStatusError;
