//
//  UIView+AXBadgeView.m
//  AXBadgeView
//
//  Created by ai on 15/12/7.
//  Copyright © 2015年 AiXing. All rights reserved.
//

#import "UIView+AXBadgeView.h"
#import <objc/runtime.h>

@implementation UIView (AXBadgeView)
- (AXBadgeView *)badgeView {
    AXBadgeView *badgeView = objc_getAssociatedObject(self, _cmd);
    if (!badgeView) {
        badgeView = [[AXBadgeView alloc] init];
        objc_setAssociatedObject(self, _cmd, badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return badgeView;
}

- (void)showBadge:(BOOL)animated {
    [self.badgeView showInView:self animated:animated];
}

- (void)clearBadge:(BOOL)animated {
    [self.badgeView hideAnimated:animated];
    objc_setAssociatedObject(self, @selector(badgeView), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
