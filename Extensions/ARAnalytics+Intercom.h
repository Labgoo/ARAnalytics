#import "ARAnalytics.h"

typedef NS_ENUM(NSUInteger, ARPreviewPosition){
    ARPreviewPositionBottomLeft   = 0,
    ARPreviewPositionBottomRight  = 1,
    ARPreviewPositionTopLeft      = 2,
    ARPreviewPositionTopRight     = 3
};

@interface ARAnalytics (Intercom)

+ (void)presentMessageComposer;

+ (void)presentConversationList;

+ (void)setPreviewPosition:(ARPreviewPosition)previewPosition;

+ (void)setPreviewPaddingWithX:(CGFloat)x y:(CGFloat)y;

@end

