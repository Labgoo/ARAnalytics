//
//  IntercomProvider.m

#import "IntercomProvider.h"
#import "Intercom.h"

static NSString *const kIntercomSuperPropertiesKey = @"superProperties";

@interface IntercomProvider ()

@property(nonatomic, strong) NSDictionary *superProperties;

@end


@implementation IntercomProvider

#ifdef AR_INTERCOM_EXISTS

- (id)initWithApiKey:(NSString *)apiKey forAppId:(NSString *)appId {
    [Intercom setApiKey:apiKey forAppId:appId];
	self = [super init];
    [self _unarchiveData];
    return self;
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
	[Intercom logEventWithName:event metaData:properties];
}

- (void)didShowNewPageView:(NSString *)pageTitle withProperties:(NSDictionary *)properties {
    NSString *event = [NSString stringWithFormat:@"View @%", pageTitle];
    [Intercom logEventWithName:event metaData:properties];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    [Intercom registerUserWithUserId:userID];
    if (email) {
         [Intercom updateUserWithAttributes:@{ @"email" : email}];
    }
}

#pragma mark - Super Properties

- (void)addSuperProperties:(NSDictionary *)properties {
    properties = [properties copy];
    [self _assertPropertyTypes:properties];
    
    NSMutableDictionary *mutableSuperProperties = [NSMutableDictionary dictionaryWithDictionary:self.superProperties];
    [mutableSuperProperties addEntriesFromDictionary:properties];
    self.superProperties = [mutableSuperProperties copy];
    
    [self _updateUserWithAttributes];
    [self _archiveData];
}

- (void)removeSuperProperty:(NSString *)propertyName {
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:self.superProperties];
    [temp removeObjectForKey:propertyName];
    self.superProperties = [temp copy];
    
    [self _updateUserWithAttributes];
    [self _archiveData];
}

- (void)clearSuperProperties {
    self.superProperties = @{};

    [self _updateUserWithAttributes];
    [self _archiveData];
}

#pragma mark - Private

- (void)_archiveData {
    NSString *filePath = [self _dataFilePath];
    NSDictionary *data = @{kIntercomSuperPropertiesKey : self.superProperties};
    
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
        self.superProperties = data[kIntercomSuperPropertiesKey] ? data[kIntercomSuperPropertiesKey] : @{};
    }
}

- (NSString *)_dataFilePath {
    NSString *filename = [NSString stringWithFormat:@"ARAnalytics-IntercomProvider-data.plist"];
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

- (void)_updateUserWithAttributes {
    [Intercom updateUserWithAttributes:@{@"custom_attributes": self.superProperties}];
    
}

#endif

@end
