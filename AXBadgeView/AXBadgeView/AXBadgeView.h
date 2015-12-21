//
//  AXBadgeView.h
//  AXBadgeView
//
//  Created by ai on 15/12/7.
//  Copyright © 2015年 AiXing. All rights reserved.
//

#import <UIKit/UIKit.h>
/// AXBadge style.
typedef NS_ENUM(NSUInteger, AXBadgeViewStyle) {
    /// Normal shows a red dot.
    AXBadgeViewNormal,
    /// Number shows a number form text.
    AXBadgeViewNumber,
    /// Text shows a custom text.
    AXBadgeViewText,
    /// New shows a new text.
    AXBadgeViewNew
};
/// Animation type.
typedef NS_ENUM(NSUInteger, AXBadgeViewAnimation)
{
    /// Animation none, badge view stay still.
    AXBadgeViewAnimationNone = 0,
    /// Animation scale.
    AXBadgeViewAnimationScale,
    /// Animation shake.
    AXBadgeViewAnimationShake,
    /// Animation bounce.
    AXBadgeViewAnimationBounce,
    /// Animation breathe.
    AXBadgeViewAnimationBreathe
};
///
/// AXBadgeView
///
@interface AXBadgeView : UILabel
/// Attached view.
@property(weak, nonatomic) UIView *attachedView;
/// Style of badge view. Defaults to AXBadgeViewNormal.
@property(assign, nonatomic) AXBadgeViewStyle style UI_APPEARANCE_SELECTOR;
/// Animation type of badge view. Defaults to None.
@property(assign, nonatomic) AXBadgeViewAnimation animation UI_APPEARANCE_SELECTOR;
/// Offsets, Defaults to (CGFLOAT_MAX, CGFLOAT_MIN).
@property(assign, nonatomic) CGPoint offsets UI_APPEARANCE_SELECTOR;
/// Hide on zero content. Defaults to YES
@property(assign, nonatomic) BOOL hideOnZero;
/// Min size. Defaults to {12.0, 12.0}.
@property(assign, nonatomic) CGSize minSize UI_APPEARANCE_SELECTOR;
/// Is badge visible.
@property(readonly, nonatomic, getter=isVisible) BOOL visible;
/// Scale content when set new content to badge label. Defaults to NO.
@property(assign, nonatomic, getter=isScaleContent) BOOL scaleContent;
/// Show badge view with animation.
///
/// @param animated show badge with or without animation.
- (void)showAnimated:(BOOL)animated;
/// Hide badge view.
///
/// @param animated hide badge with or without animation.
- (void)hideAnimated:(BOOL)animated completion:(dispatch_block_t)completion;
/// Show badge view from a attched view.
///
/// @param view a attached view.
/// @param animated show badge with or without animation.
- (void)showInView:(UIView *)view animated:(BOOL)animated;
@end