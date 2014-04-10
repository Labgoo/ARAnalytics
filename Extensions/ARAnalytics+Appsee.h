//
//  Created by Minh Tu Le 10/04/2014.
//  Copyright (c) 2014 Wondermall inc. All rights reserved.
//

#import "ARAnalytics.h"

@interface ARAnalytics (Appsee)

+ (void)stop;

+ (void)stopAndUpload;

+ (void)pause;

+ (void)resume;

+ (void)markViewAsSensitive:(UIView *)view;

+ (void)unmarkViewAsSensitive:(UIView *)view;

@end

