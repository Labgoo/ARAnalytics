//
//  ARAnalytics+Mixpanel.m
//  Pods
//
//  Created by Minh Tu Le on 8/1/14.
//
//

#import "ARAnalytics+Mixpanel.h"
#import "Mixpanel.h"

@implementation ARAnalytics (Mixpanel)

+ (void)registerSuperProperties:(NSDictionary *)properties {
    [[Mixpanel sharedInstance] registerSuperProperties:properties];
}

+ (void)registerSuperPropertiesOnce:(NSDictionary *)properties {
    [[Mixpanel sharedInstance] registerSuperPropertiesOnce:properties];
}

+ (void)registerSuperPropertiesOnce:(NSDictionary *)properties
                       defaultValue:(id)defaultValue {
    [[Mixpanel sharedInstance] registerSuperPropertiesOnce:properties
                                              defaultValue:defaultValue];
}

+ (void)unregisterSuperProperty:(NSString *)propertyName {
    [[Mixpanel sharedInstance] unregisterSuperProperty:propertyName];
}

+ (void)clearSuperProperties {
    [[Mixpanel sharedInstance] clearSuperProperties];
}

@end
