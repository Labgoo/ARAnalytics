//
//  Created by Minh Tu Le 10/04/2014.
//  Copyright (c) 2014 Wondermall inc. All rights reserved.
//


#import "ARAnalytics+Intercom.h"
#import "Intercom.h"


@implementation ARAnalytics (Intercom)

+ (void)presentMessageComposer {
    [Intercom presentMessageComposer];
}

+ (void)presentConversationList {
    [Intercom presentConversationList];
}

+ (void)setPreviewPosition:(ARPreviewPosition)previewPosition {
    ICMPreviewPosition position = [self _translatePreviewPosition:previewPosition];
    [Intercom setPreviewPosition:position];
}

+ (void)setPreviewPaddingWithX:(CGFloat)x y:(CGFloat)y {
    [Intercom setPreviewPaddingWithX:x y:y];
}

+ (ICMPreviewPosition) _translatePreviewPosition:(ARPreviewPosition)previewPosition {
    switch (previewPosition) {
        case ARPreviewPositionBottomLeft:
            return ICMPreviewPositionBottomLeft;
        
        case ARPreviewPositionBottomRight:
            return ICMPreviewPositionBottomRight;
            
        case ARPreviewPositionTopLeft:
            return ICMPreviewPositionTopLeft;
            
        case ARPreviewPositionTopRight:
            return ICMPreviewPositionTopRight;
            
        default:
            return ICMPreviewPositionBottomLeft;
    }
}

@end

