//
//  Created by Minh Tu Le 10/04/2014.
//  Copyright (c) 2014 Wondermall inc. All rights reserved.
//


#import "AppseeProvider.h"
#import "Appsee.h"


@interface AppseeProvider ()

@end

@implementation AppseeProvider

- (id)initWithIdentifier:(NSString *)identifier {
#ifdef AR_APPSEE_EXISTS
    NSAssert([Appsee class], @"Appsee is not included");
    [Appsee start:identifier];

#endif
    return [super init];
}

#ifdef AR_APPSEE_EXISTS
/*!
    @param email is ignored by Appsee
 */
- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    [Appsee setUserID:userID];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [Appsee addEvent:event withProperties:properties];
}

#endif

@end

