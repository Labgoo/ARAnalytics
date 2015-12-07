//
//  Created by Minh Tu Le 10/04/2014.
//  Copyright (c) 2014 Wondermall inc. All rights reserved.
//


#import "AppseeProvider.h"
#import <Appsee/Appsee.h>

static NSString *const kAppseeProviderSuperPropertiesKey = @"superProperties";


@interface AppseeProvider ()

@property(nonatomic, strong) NSDictionary *superProperties;

@end

@implementation AppseeProvider

- (id)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (!self) {
        return nil;
    }
    
#ifdef AR_APPSEE_EXISTS
    NSAssert([Appsee class], @"Appsee is not included");
    [Appsee start:identifier];
    [Appsee setDebugToNSLog:YES];
    
    self.superProperties = @{};
    [self _unarchiveData];
#endif
    
    return self;
}

#ifdef AR_APPSEE_EXISTS
/*!
 @param email is ignored by Appsee
 */
- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    [Appsee setUserID:userID];
}

- (void)addSuperProperties:(NSDictionary *)properties {
    properties = [properties copy];
    [self _assertPropertyTypes:properties];
    
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:self.superProperties];
    [temp addEntriesFromDictionary:properties];
    self.superProperties = [temp copy];
    
    [self _archiveData];
}

- (void)removeSuperProperty:(NSString *)propertyName {
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:self.superProperties];
    [temp removeObjectForKey:propertyName];
    self.superProperties = [temp copy];
    
    [self _archiveData];
}

- (void)clearSuperProperties {
    self.superProperties = @{};
    
    [self _archiveData];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    NSMutableDictionary *propertiesWithSuperProperties = nil;
    if (self.shouldRegressProperties == NO) {
        properties = [properties copy];
        propertiesWithSuperProperties = [NSMutableDictionary dictionaryWithDictionary:self.superProperties];
        [propertiesWithSuperProperties addEntriesFromDictionary:properties];
    }
    
    [Appsee addEvent:event withProperties:propertiesWithSuperProperties];
}

#endif

#pragma mark - Private

- (void)_archiveData {
    NSString *filePath = [self _dataFilePath];
    NSDictionary *data = @{
                           kAppseeProviderSuperPropertiesKey : self.superProperties
                           };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![NSKeyedArchiver archiveRootObject:data toFile:filePath]) {
            NSLog(@"%@ unable to archive events data", self);
        }
    });
}

- (void)_unarchiveData {
    NSString *filePath = [self _dataFilePath];
    NSDictionary *data;
    
    @try {
        data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    @catch (NSException *exception) {
        NSLog(@"User data file %@ is corrupted. Reading returns error!", filePath);
    }
    
    if (data) {
        self.superProperties = data[kAppseeProviderSuperPropertiesKey] ? data[kAppseeProviderSuperPropertiesKey] : @{};
    }
}

- (NSString *)_dataFilePath {
    NSString *filename = [NSString stringWithFormat:@"ARAnalytics-AppseeProvider-data.plist"];
    return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
            stringByAppendingPathComponent:filename];
}

- (void)_assertPropertyTypes:(NSDictionary *)properties {
    for (id __unused k in properties) {
        NSAssert([k isKindOfClass: [NSString class]], @"%@ property keys must be NSString. got: %@ %@", self, [k class], k);
        // would be convenient to do: id v = [properties objectForKey:k]; but
        // when the NSAssert's are stripped out in release, it becomes an
        // unused variable error. also, note that @YES and @NO pass as
        // instances of NSNumber class.
        NSAssert([properties[k] isKindOfClass:[NSString class]] ||
                 [properties[k] isKindOfClass:[NSNumber class]] ||
                 [properties[k] isKindOfClass:[NSNull class]] ||
                 [properties[k] isKindOfClass:[NSArray class]] ||
                 [properties[k] isKindOfClass:[NSDictionary class]] ||
                 [properties[k] isKindOfClass:[NSDate class]] ||
                 [properties[k] isKindOfClass:[NSURL class]],
                 @"%@ property values must be NSString, NSNumber, NSNull, NSArray, NSDictionary, NSDate or NSURL. got: %@ %@", self, [properties[k] class], properties[k]);
    }
}

@end

