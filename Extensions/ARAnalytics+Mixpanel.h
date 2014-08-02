//
//  ARAnalytics+Mixpanel.h
//  Pods
//
//  Created by Minh Tu Le on 8/1/14.
//
//

#import "ARAnalytics.h"

@interface ARAnalytics (Mixpanel)

+ (void)registerSuperProperties:(NSDictionary *)properties;

+ (void)registerSuperPropertiesOnce:(NSDictionary *)properties;

+ (void)registerSuperPropertiesOnce:(NSDictionary *)properties defaultValue:(id)defaultValue;

+ (void)unregisterSuperProperty:(NSString *)propertyName;

+ (void)clearSuperProperties;

@end
