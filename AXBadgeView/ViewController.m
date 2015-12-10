//
//  ViewController.m
//  AXBadgeView
//
//  Created by ai on 15/12/7.
//  Copyright © 2015年 AiXing. All rights reserved.
//

#import "ViewController.h"
#import "AXBadgeKit.h"

@interface ViewController ()
@property(weak, nonatomic) IBOutlet UIView *showsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstant;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_showsView showBadge:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _showsView.badgeView.offsets = CGPointMake(50, 0);
        _showsView.badgeView.style = AXBadgeViewNew;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _heightConstant.constant = 50;
            _widthConstant.constant = 50;
            [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:7 animations:^{
                [self.view layoutSubviews];
            } completion:^(BOOL finished) {
            }];
        });
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationItem.leftBarButtonItem showBadge:YES];
//    self.navigationItem.leftBarButtonItem.badgeView.style = AXBadgeViewNew;
    self.navigationItem.leftBarButtonItem.badgeView.style = AXBadgeViewNumber;
    self.navigationItem.leftBarButtonItem.badgeView.text = @"2";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationItem.leftBarButtonItem.badgeView.text = @"3";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.navigationItem.leftBarButtonItem.badgeView.text = @"4";
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapLeftItem:(UIBarButtonItem *)sender {
    if (sender.badgeView.hidden) {
        [sender showBadge:YES];
        self.navigationItem.leftBarButtonItem.badgeView.text = @"2";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.navigationItem.leftBarButtonItem.badgeView.text = @"3";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.navigationItem.leftBarButtonItem.badgeView.text = @"4";
            });
        });
    } else {
        [sender clearBadge:YES];
    }
}
@end