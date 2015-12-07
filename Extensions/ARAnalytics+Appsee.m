//
//  Created by Minh Tu Le 10/04/2014.
//  Copyright (c) 2014 Wondermall inc. All rights reserved.
//


#import "ARAnalytics+Appsee.h"
#import <Appsee/Appsee.h>


@implementation ARAnalytics (Appsee)

#pragma mark - Recording Controls

+ (void)stop {
    [Appsee stop];
}

+ (void)stopAndUpload {
    [Appsee stopAndUpload];
}

+ (void)pause {
    [Appsee pause];
}

+ (void)resume {
    [Appsee resume];
}

#pragma mark - Privacy controls

+ (void)markViewAsSensitive:(UIView *)view {
    [Appsee markViewAsSensitive:view];
}

+ (void)unmarkViewAsSensitive:(UIView *)view {
    [Appsee unmarkViewAsSensitive:view];
}

@end

