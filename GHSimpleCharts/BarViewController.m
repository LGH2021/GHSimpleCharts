//
//  BarViewController.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/3/3.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "BarViewController.h"
#import "GHSimpleCharts.h"
#import "GHConfigs.h"
#import "UIViewController+CreateControl.h"
@interface BarViewController ()
{
    CGFloat _barWidth;
}
@property (strong, nonatomic) GHBarChartView *barView;
@end

@implementation BarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    NSDictionary *chartDict = GHConfigs.chartViewDatas;
    GHBarChartView *barView = [[GHBarChartView alloc] initWithFrame:GHConfigs.chartViewFrame];
    barView.values = chartDict[@"values"];
    barView.labels = chartDict[@"labels"];
    barView.yAxisName = @"(单位)";
    barView.barTintColors = UIColor.cyanColor;
    barView.xAxisName = @"(名称)";
    barView.yAxisExcessLength = 10;
    barView.xAxisExcessLength = 10;
    barView.animateDuration = 2;

    [self.view addSubview:barView];
    
    self.barView = barView;
    
    NSArray *arr = @[
        @{@"title": @"柱子宽度", @"sel": @"setBarWidth:"},
        @{@"title": @"柱子背景色", @"sel": @"setBarBackgroundColor:"},
        @{@"title": @"柱子颜色", @"sel": @"setBarTintColor:"},
        @{@"title": @"柱子图片", @"sel": @"setBarImage:"},
    ];
    
    [self addSubviewsWithArray:arr];
}

- (void)setBarWidth:(UISwitch *)swh {
    _barWidth = swh.on? 30: 10;
    
    if (self.barView.barTintImage) {
        return;
    }
    self.barView.barWidth = _barWidth;
    [self.barView reloadData];
}

- (void)setBarBackgroundColor:(UISwitch *)swh {
    self.barView.barBackgroundColor = swh.on? UIColor.lightGrayColor: nil;
    [self.barView reloadData];
}

- (void)setBarTintColor:(UISwitch *)swh {
    self.barView.barTintColors = swh.on? @[UIColor.redColor, UIColor.greenColor, UIColor.yellowColor]: UIColor.cyanColor;
    [self.barView reloadData];
}

- (void)setBarImage:(UISwitch *)swh {
    // 建议 barTintImage 和 barBackgroundImage 一起使用
    self.barView.barTintImage = swh.on? [UIImage imageNamed:@"man2"]: nil;
    self.barView.barBackgroundImage = swh.on? [UIImage imageNamed:@"man"]: nil;
    
    if (swh.on) {
        // 此处建议指定一下barWidth，不然可能会有点小尴尬。。。
        self.barView.barWidth = 80;
    } else {
        self.barView.barWidth = _barWidth == 0? 10: _barWidth;
    }
    
    [self.barView reloadData];
}
@end
