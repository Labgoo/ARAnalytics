//
//  IntercomProvider.h

#import "ARAnalyticalProvider.h"

@interface IntercomProvider : ARAnalyticalProvider

- (id)initWithApiKey:(NSString *)apiKey forAppId:(NSString *)appId;

@end
