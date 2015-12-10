//
//  AXBadgeView.m
//  AXBadgeView
//
//  Created by ai on 15/12/7.
//  Copyright © 2015年 AiXing. All rights reserved.
//

#import "AXBadgeView.h"

#define kAXBadgeViewBreatheAnimationKey     @"breathe"
#define kAXBadgeViewRotateAnimationKey      @"rotate"
#define kAXBadgeViewShakeAnimationKey       @"shake"
#define kAXBadgeViewScaleAnimationKey       @"scale"
#define kAXBadgeViewBounceAnimationKey      @"bounce"

typedef NS_ENUM(NSUInteger, AXAxis)
{
    AXAxisX = 0,
    AXAxisY,
    AXAxisZ
};

// Degrees to radians
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

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
    self.animation = AXBadgeViewAnimationNone;
    _hideOnZero = YES;
    _minSize = CGSizeMake(12.0, 12.0);
    [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    self.hidden = YES;
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
    if (self.isVisible) {
        [self showAnimated:YES];
    }
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

- (BOOL)isVisible {
    return !self.hidden;
}

#pragma mark - Setters
- (void)setStyle:(AXBadgeViewStyle)style {
    _style = style;
    [self setText:_textStorage];
}

- (void)setAnimation:(AXBadgeViewAnimation)animation {
    _animation = animation;
    switch (_animation) {
        case AXBadgeViewAnimationBreathe:
            [self.layer addAnimation:[self breathingAnimationWithDuration:1.2] forKey:kAXBadgeViewBreatheAnimationKey];
            break;
        case AXBadgeViewAnimationBounce:
            [self.layer addAnimation:[self bounceAnimationWithRepeat:CGFLOAT_MAX duration:0.8 forLayer:self.layer] forKey:kAXBadgeViewBounceAnimationKey];
            break;
        case AXBadgeViewAnimationScale:
            [self.layer addAnimation:[self scaleAnimationFrom:1.2 toScale:0.8 duration:0.8 repeat:MAXFLOAT] forKey:kAXBadgeViewScaleAnimationKey];
            break;
        case AXBadgeViewAnimationShake:
            [self.layer addAnimation:[self shakeAnimationWithRepeat:CGFLOAT_MAX duration:0.8 forLayer:self.layer] forKey:kAXBadgeViewShakeAnimationKey];
            break;
        default:
            [self.layer removeAllAnimations];
            break;
    }
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
    [_attachedView bringSubviewToFront:self];
    if (self.hidden) {
        self.hidden = NO;
    }
    self.transform = CGAffineTransformMakeScale(.0, .0);
    if (animated) {
        [UIView animateWithDuration:0.5 delay:.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:7 animations:^{
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
                self.hidden = YES;
                self.alpha = 1.0;
            }
        }];
    } else {
        self.hidden = YES;
    }
}

#pragma mark - Private
/**
 *  breathing forever
 *
 *  @param time duritaion, from clear to fully seen
 *
 *  @return animation obj
 */
- (CABasicAnimation *)breathingAnimationWithDuration:(CGFloat)duration
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:0.1];
    animation.autoreverses=YES;
    animation.duration=duration;
    animation.repeatCount=FLT_MAX;
    animation.removedOnCompletion=NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

/**
 *  breathing with fixed repeated times
 *
 *  @param repeatTimes times
 *  @param time        duritaion, from clear to fully seen
 *
 *  @return animation obj
 */
- (CABasicAnimation *)breathingAnimationWithRepeat:(CGFloat)repeating duration:(CGFloat)duration
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:0.4];
    animation.repeatCount=repeating;
    animation.duration=duration;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.autoreverses=YES;
    return  animation;
}

/**
 *  //rotate
 *
 *  @param dur         duration
 *  @param degree      rotate degree in radian(弧度)
 *  @param axis        axis
 *  @param repeatCount repeat count
 *
 *  @return animation obj
 */
- (CABasicAnimation *)rotationAnimationWithDuration:(CGFloat)duration degree:(CGFloat)degree direction:(AXAxis)axis repeatCount:(NSUInteger)repeatCount
{
    CABasicAnimation* animation;
    NSArray *axisArr = @[@"transform.rotation.x", @"transform.rotation.y", @"transform.rotation.z"];
    animation = [CABasicAnimation animationWithKeyPath:axisArr[axis]];
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue= [NSNumber numberWithFloat:degree];
    animation.duration= duration;
    animation.autoreverses= NO;
    animation.cumulative= YES;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.repeatCount= repeatCount;
    animation.delegate= self;
    
    return animation;
}

/**
 *  scale animation
 *
 *  @param fromScale   the original scale value, 1.0 by default
 *  @param toScale     target scale
 *  @param time        duration
 *  @param repeatTimes repeat counts
 *
 *  @return animaiton obj
 */
- (CABasicAnimation *)scaleAnimationFrom:(CGFloat)fromScale toScale:(CGFloat)toScale duration:(float)duration repeat:(float)repeating
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(fromScale);
    animation.toValue = @(toScale);
    animation.duration = duration;
    animation.autoreverses = YES;
    animation.repeatCount = repeating;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

/**
 *  shake
 *
 *  @param repeatTimes time
 *  @param time        duration
 *  @param obj         always be CALayer
 *  @return aniamtion obj
 */
- (CAKeyframeAnimation *)shakeAnimationWithRepeat:(CGFloat)repeating duration:(CGFloat)duration forLayer:(CALayer *)layer
{
    CGPoint originPos = CGPointZero;
    CGSize originSize = CGSizeZero;
    if ([layer isKindOfClass:[CALayer class]]) {
        originPos = [layer position];
        originSize = [layer bounds].size;
    }
    CGFloat hOffset = originSize.width / 4;
    CAKeyframeAnimation* anim=[CAKeyframeAnimation animation];
    anim.keyPath=@"transform";
    anim.values=@[
                  [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)],
                  [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-hOffset, 0, 0)],
                  [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)],
                  [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(hOffset, 0, 0)],
                  [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)]
                  ];
    anim.repeatCount=repeating;
    anim.duration=duration;
    anim.fillMode = kCAFillModeForwards;
    return anim;
}

/**
 *  bounce
 *
 *  @param repeatTimes time
 *  @param time        duration
 *  @param obj         always be CALayer
 *  @return aniamtion obj
 */
- (CAKeyframeAnimation *)bounceAnimationWithRepeat:(CGFloat)repeating duration:(CGFloat)duration forLayer:(CALayer *)layer
{
    CGPoint originPos = CGPointZero;
    CGSize originSize = CGSizeZero;
    if ([layer isKindOfClass:[CALayer class]]) {
        originPos = [layer position];
        originSize = [layer bounds].size;
    }
    CGFloat hOffset = originSize.height / 4;
    CAKeyframeAnimation* anim=[CAKeyframeAnimation animation];
    anim.keyPath=@"transform";
    anim.values=@[
                  [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)],
                  [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -hOffset, 0)],
                  [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)],
                  [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, hOffset, 0)],
                  [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)]
                  ];
    anim.repeatCount=repeating;
    anim.duration=duration;
    anim.fillMode = kCAFillModeForwards;
    return anim;
}
@end