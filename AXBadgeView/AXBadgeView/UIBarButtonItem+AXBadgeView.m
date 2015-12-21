//
//  UIBarButtonItem+AXBadgeView.m
//  AXBadgeView
//
//  Created by ai on 15/12/7.
//  Copyright © 2015年 AiXing. All rights reserved.
//

#import "UIBarButtonItem+AXBadgeView.h"
#import <objc/runtime.h>

@implementation UIBarButtonItem (AXBadgeView)
- (AXBadgeView *)badgeView {
    AXBadgeView *badgeView = objc_getAssociatedObject(self, _cmd);
    if (!badgeView) {
        badgeView = [[AXBadgeView alloc] init];
        objc_setAssociatedObject(self, _cmd, badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return badgeView;
}

- (void)showBadge:(BOOL)animated {
    [self.badgeView showInView:[self valueForKeyPath:@"_view"] animated:animated];
}

- (void)clearBadge:(BOOL)animated {
    [self.badgeView hideAnimated:animated completion:NULL];
}
@end
