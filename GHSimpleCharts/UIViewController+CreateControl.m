//
//  UIViewController+CreateControl.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/3/8.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "UIViewController+CreateControl.h"
#import "GHConfigs.h"
#import "UIColor+GHSimpleCharts.h"
#import <objc/runtime.h>

@interface UIViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation UIViewController (CreateControl)


- (void)addSubviewsWithArray:(NSArray *)array {

    CGFloat y = 0;
    CGFloat x = 10;
    CGFloat height = 32;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;

    for (NSDictionary *dict in array) {
        UIControl *control;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, screenWidth - 2 * x, height)];
        label.text = dict[@"title"];
        
        if (dict[@"items"]) {
            y = CGRectGetMaxY(label.frame);
            control = [UISegmentedControl.alloc initWithItems:dict[@"items"]];
            control.frame = CGRectMake(x, y, label.frame.size.width, height);
            [control setValue:@0 forKeyPath:@"selectedSegmentIndex"];
        } else {
            control = UISwitch.new;
            control.center = CGPointMake(screenWidth - x - control.bounds.size.width/2, label.center.y);
        }

        label.font = [UIFont systemFontOfSize:15];
        [control addTarget:self action:NSSelectorFromString(dict[@"sel"]) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:label];
        [self.scrollView addSubview:control];

        y = CGRectGetMaxY(control.frame) + 5;
    }

    self.scrollView.contentSize = CGSizeMake(0, y);
}

- (void)setScrollView:(UIScrollView *)scrollView {
    objc_setAssociatedObject(self, @selector(scrollView), scrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIScrollView *)scrollView {
    UIScrollView *scrollView = objc_getAssociatedObject(self, _cmd);
    if (!scrollView) {
        CGFloat y = CGRectGetMaxY(GHConfigs.chartViewFrame) + 10;
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height - y)];
        scrollView.showsVerticalScrollIndicator = NO;
        [self setScrollView:scrollView];
        [self.view addSubview:scrollView];
    }

    return scrollView;
}
@end
