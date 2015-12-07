//
//  AXBadgeView.m
//  AXBadgeView
//
//  Created by ai on 15/12/7.
//  Copyright © 2015年 AiXing. All rights reserved.
//

#import "AXBadgeView.h"

@interface AXBadgeView ()
{
    NSString *_textStorage;
}
@property(strong, nonatomic) NSLayoutConstraint *horizontalLayout;
@property(strong, nonatomic) NSLayoutConstraint *verticalLayout;
@property(strong, nonatomic) NSLayoutConstraint *widthLayout;
@property(strong, nonatomic) NSLayoutConstraint *heightLayout;
@end

@implementation AXBadgeView
#pragma mark - Initializer
- (instancetype)init {
    if (self = [super init]) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializer];
    }
    return self;
}

- (void)initializer {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.font = [UIFont systemFontOfSize:12];
    self.backgroundColor = [UIColor redColor];
    self.textColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
    _offsets = CGPointMake(CGFLOAT_MAX, CGFLOAT_MIN);
    _textStorage = @"";
    self.style = AXBadgeViewNormal;
    _hideOnZero = YES;
    _minSize = CGSizeMake(12.0, 12.0);
    [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"text"];
}

#pragma mark - Override
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"]) {
        NSString *text = [change objectForKey:NSKeyValueChangeNewKey];
        if (_hideOnZero) {
            switch (_style) {
                case AXBadgeViewNumber:
                    if ([text integerValue] == 0) {
                        self.hidden = YES;
                    } else {
                        self.hidden = NO;
                    }
                    break;
                case AXBadgeViewText:
                    if ([text isEqualToString:@""]) {
                        self.hidden = YES;
                    } else {
                        self.hidden = NO;
                    }
                    break;
                case AXBadgeViewNew:
                    break;
                default:
                    break;
            }
        } else {
            self.hidden = NO;
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize susize = [super sizeThatFits:size];
    susize.width = MAX(susize.width + susize.height/2, _minSize.width);
    susize.height = MAX(susize.height, _minSize.height);
    return susize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [self setOffsets:_offsets];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    UIView *suview = self.superview;
    if(!suview) return;
    [self setOffsets:_offsets];
    if (![suview.constraints containsObject:self.verticalLayout]) {
        [suview addConstraint:_verticalLayout];
    }
    if (![suview.constraints containsObject:self.horizontalLayout]) {
        [suview addConstraint:_horizontalLayout];
    }
    [suview setNeedsLayout];
}

- (void)setText:(NSString *)text {
    _textStorage = [text copy];
    switch (_style) {
        case AXBadgeViewNew:
            [super setText:@"new"];
            break;
        case AXBadgeViewText:
            [super setText:_textStorage];
            break;
        case AXBadgeViewNumber:
            [super setText:[NSString stringWithFormat:@"%@", @([_textStorage integerValue])]];
            break;
        default:
            [super setText:@""];
            break;
    }
    [self sizeToFit];
    self.layer.cornerRadius = CGRectGetHeight(self.bounds)/2;
    self.layer.masksToBounds = YES;
    if (![self.constraints containsObject:self.widthLayout]) {
        [self addConstraint:_widthLayout];
    }
    if (![self.constraints containsObject:self.heightLayout]) {
        [self addConstraint:_heightLayout];
    }
    _widthLayout.constant = CGRectGetWidth(self.bounds);
    _heightLayout.constant = CGRectGetHeight(self.bounds);
    [self setNeedsLayout];
}

#pragma mark - Getters
- (NSLayoutConstraint *)widthLayout {
    if (_widthLayout) return _widthLayout;
    _widthLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    return _widthLayout;
}

- (NSLayoutConstraint *)heightLayout {
    if (_heightLayout) return _heightLayout;
    _heightLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    return _heightLayout;
}

#pragma mark - Setters
- (void)setStyle:(AXBadgeViewStyle)style {
    _style = style;
    [self setText:_textStorage];
}

- (void)setOffsets:(CGPoint)offsets {
    _offsets = offsets;
    
    if (self.superview) {
        CGFloat centerXConstant = _offsets.x;
        CGFloat centerYConstant = _offsets.y;
        if ([self.superview.constraints containsObject:_horizontalLayout]) {
            [self.superview removeConstraint:_horizontalLayout];
        }
        if ([self.superview.constraints containsObject:_verticalLayout]) {
            [self.superview removeConstraint:_verticalLayout];
        }
        if (centerXConstant == CGFLOAT_MIN || centerXConstant == 0.0) {
            _horizontalLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        } else if (centerXConstant == CGFLOAT_MAX || centerXConstant == CGRectGetWidth(self.superview.bounds)) {
            _horizontalLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        } else {
            _horizontalLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:centerXConstant/CGRectGetWidth(self.superview.bounds) constant:0.0];
        }
        if (centerYConstant == CGFLOAT_MIN || centerYConstant == 0.0) {
            _verticalLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        } else if (centerYConstant == CGFLOAT_MAX || centerYConstant == CGRectGetHeight(self.superview.bounds)) {
            _verticalLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        } else {
            _verticalLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:centerYConstant/CGRectGetHeight(self.superview.bounds) constant:0.0];
        }
        [self.superview addConstraint:_horizontalLayout];
        [self.superview addConstraint:_verticalLayout];
        [self.superview setNeedsLayout];
    }
}

- (void)setMinSize:(CGSize)minSize {
    _minSize = minSize;
    [self sizeToFit];
    [self setText:_textStorage];
}

#pragma mark - Public

- (void)showAnimated:(BOOL)animated {
    if (!_attachedView) return;
    [_attachedView addSubview:self];
    self.transform = CGAffineTransformMakeScale(.0, .0);
    if (animated) {
        [UIView animateWithDuration:0.5 delay:.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:7 animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    } else {
        self.transform = CGAffineTransformIdentity;
    }
}

- (void)showInView:(UIView *)view animated:(BOOL)animated {
    _attachedView = view;
    [self showAnimated:animated];
}

- (void)hideAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
                self.alpha = 1.0;
            }
        }];
    } else {
        [self removeFromSuperview];
    }
}
@end