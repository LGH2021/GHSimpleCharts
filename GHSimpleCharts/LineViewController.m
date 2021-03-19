//
//  LineViewController.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/3/3.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "LineViewController.h"
#import "GHSimpleCharts.h"
#import "GHConfigs.h"
#import "UIViewController+CreateControl.h"
#import "UIColor+GHSimpleCharts.h"
@interface LineViewController ()
@property (strong, nonatomic) GHLineChartView *lineView;
@end

@implementation LineViewController
 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    NSDictionary *chartDict = GHConfigs.chartViewDatas;
    
    GHLineChartView *lineView = [[GHLineChartView alloc] initWithFrame:GHConfigs.chartViewFrame];
    
    lineView.values = chartDict[@"values"];
    lineView.labels = chartDict[@"labels"];
    lineView.showValues = NO;
    lineView.xDegreeOrientation = GHAxisDegreeOrientationNone;
    lineView.yDegreeOrientation = GHAxisDegreeOrientationNone;
    
    [self.view addSubview:lineView];
    
    self.lineView = lineView;
    
    NSArray *arr = @[
        @{@"title": @"显示值", @"sel": @"setShowValues:"},
        @{@"title": @"曲线", @"sel": @"setLineOrCurve:"},
        @{@"title": @"区域填充", @"sel": @"setAreaColor:"},
        @{@"title": @"添加x、y轴箭头", @"sel": @"setXYArrow:"},
        @{@"title": @"添加x、y轴名称", @"sel": @"setXYName:"},
        @{@"title": @"动画", @"sel": @"setAnimation:"},
        @{@"title": @"从y轴开始", @"sel": @"setStartAtY:"},
        @{@"title": @"左右滚动", @"sel": @"setScroll:"},
        @{@"title": @"y轴刻度线朝向", @"sel": @"setYDegreeLineOrientation:", @"items": @[@"无", @"朝右", @"朝左"]},
        @{@"title": @"x轴刻度线朝向", @"sel": @"setXDegreeLineOrientation:", @"items": @[@"无", @"朝上", @"朝下"]},
    ];
    
    [self addSubviewsWithArray:arr];
}

- (void)setShowValues:(UISwitch *)swh {
    self.lineView.showValues = swh.on;
    [self.lineView reloadData];
}

- (void)setLineOrCurve:(UISwitch *)swh {
    self.lineView.isCurve = swh.on;
    [self.lineView reloadData];
}

- (void)setAreaColor:(UISwitch *)swh {
    NSArray *color = swh.on? @[UIColorRGB(4, 191, 225), UIColor.whiteColor]: nil;
    self.lineView.areaColors = color;
    [self.lineView reloadData];
}

- (void)setXYArrow:(UISwitch *)swh {
    self.lineView.xAxisExcessLength = swh.on? 10: 0;
    self.lineView.yAxisExcessLength = swh.on? 10: 0;
    [self.lineView reloadData];
}

- (void)setXYName:(UISwitch *)swh {
    self.lineView.xAxisName = swh.on? @"(名称)": nil;
    self.lineView.yAxisName = swh.on? @"(单位)": nil;
    [self.lineView reloadData];
}

- (void)setAnimation:(UISwitch *)swh {
    self.lineView.animateDuration = swh.on? 2: 0;
    [self.lineView reloadData];
}

- (void)setStartAtY:(UISwitch *)swh {
    self.lineView.startAtYAxis = swh.on;
    [self.lineView reloadData];
}

- (void)setScroll:(UISwitch *)swh {
    // 数值设置大一点即可滚动
    self.lineView.minXAxisSpacing = swh.on? 100: 10;
    [self.lineView reloadData];
}

- (void)setXDegreeLineOrientation:(UISegmentedControl *)seg {
    NSDictionary *dict = @{@(0): @(GHAxisDegreeOrientationNone), @1: @(GHAxisDegreeOrientationUp), @2: @(GHAxisDegreeOrientationDown)};
    self.lineView.xDegreeOrientation = (GHAxisDegreeOrientation)[dict [@(seg.selectedSegmentIndex)] integerValue];
    [self.lineView reloadData];
}

- (void)setYDegreeLineOrientation:(UISegmentedControl *)seg {
    NSDictionary *dict = @{@(0): @(GHAxisDegreeOrientationNone), @1: @(GHAxisDegreeOrientationRight), @2: @(GHAxisDegreeOrientationLeft)};
    self.lineView.yDegreeOrientation = (GHAxisDegreeOrientation)[dict [@(seg.selectedSegmentIndex)] integerValue];
    [self.lineView reloadData];
}
@end
