//
//  UIBarButtonItem+AXBadgeView.h
//  AXBadgeView
//
//  Created by ai on 15/12/7.
//  Copyright © 2015年 AiXing. All rights reserved.
//

#import "AXBadgeView.h"

@interface UIBarButtonItem (AXBadgeView)
/// Badge view.
@property(readonly, nonatomic) AXBadgeView *badgeView;
/// Show badge view with a badge style.
- (void)showBadge:(BOOL)animated;
/// Clear badge.
- (void)clearBadge:(BOOL)animated;
@end
