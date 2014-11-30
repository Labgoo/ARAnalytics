//
//  FlurryProvider.m
//  ARAnalyticsTests
//
//  Created by orta therox on 05/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "FlurryProvider.h"
#import "ARAnalyticsProviders.h"
#import "Flurry.h"

static const NSUInteger kFlurryMaximumNumberOfParameters = 10;

@implementation FlurryProvider
#ifdef AR_FLURRY_EXISTS

- (id)initWithIdentifier:(NSString *)identifier {
    NSAssert([Flurry class], @"Flurry is not included");
    [Flurry startSession:identifier];

    return [super init];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    if (userID) {
        [Flurry setUserID:userID];
    }

    if (email) {
        [Flurry setUserID:email];
    }
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [Flurry logEvent:event withParameters:[self dictionaryWithLimitedNumberOfKeysFromDictionary:properties]];
}

- (void)error:(NSError *)error withMessage:(NSString *)message {
	NSAssert(error, @"NSError instance has to be supplied");
	
	[Flurry logError:error.localizedFailureReason message:message error:error];
}

- (void)didShowNewPageView:(NSString *)pageTitle {
    [super didShowNewPageView:pageTitle];
    [Flurry logPageView];
}

- (void)didShowNewPageView:(NSString *)pageTitle withProperties:(NSDictionary *)properties {
    [super didShowNewPageView:pageTitle withProperties:properties];
    [Flurry logPageView];
}

#endif

#pragma mark - Private

- (NSDictionary *)dictionaryWithLimitedNumberOfKeysFromDictionary:(NSDictionary *)dictionary {
    if ([dictionary count] <= kFlurryMaximumNumberOfParameters) {
        return dictionary;
    }

    NSMutableDictionary *trimmedDictionary = [NSMutableDictionary dictionary];
    NSUInteger count = 0;
    for (id key in dictionary) {
        trimmedDictionary[key] = dictionary[key];
        ++count;
        if (count == kFlurryMaximumNumberOfParameters) {
            break;
        }
    }
    return trimmedDictionary;
}

@end
