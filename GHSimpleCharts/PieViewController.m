//
//  PieViewController.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/3/3.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "PieViewController.h"
#import "GHSimpleCharts.h"
#import "GHConfigs.h"
#import "UIViewController+CreateControl.h"
@interface PieViewController ()<GHPieChartsInfoViewDelegate>
@property (strong, nonatomic) GHPieChartView *pieView;
@property (assign, nonatomic) BOOL isCustom;
@end

@implementation PieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    NSDictionary *chartDict = GHConfigs.chartViewDatas;
    GHPieChartView *pieView = [[GHPieChartView alloc] initWithFrame:GHConfigs.chartViewFrame];
    pieView.values = chartDict[@"values"];
    pieView.labels = chartDict[@"labels"];
    pieView.title = @"标题";
    pieView.raduis = @[@"70%"];
    pieView.clockwise = NO;
    pieView.delegate = self;
    pieView.animateDuration = 2.5;
    [self.view addSubview:pieView];
    self.pieView = pieView;
    NSArray *arr = @[
        @{@"title": @"顺时针", @"sel": @"setClockwise:"},
        @{@"title": @"位置偏移", @"sel": @"setOffset:"},
        @{@"title": @"详情格式化", @"sel": @"setFormat:"},
        @{@"title": @"环形", @"sel": @"setRaduis:"},
        @{@"title": @"自定义浮框", @"sel": @"setCustomView:"},
        @{@"title": @"开始位置", @"sel": @"setStartingDirection:", @"items": @[@"上", @"下", @"左", @"右"]},
    ];
    
    [self addSubviewsWithArray:arr];
    
}

- (void)setClockwise:(UISwitch *)swh {
    self.pieView.clockwise = swh.on;
    [self.pieView reloadData];
}

- (void)setOffset:(UISwitch *)swh {
    self.pieView.offset = swh.on? CGPointMake(50, 50): CGPointZero;
    [self.pieView reloadData];
}

- (void)setFormat:(UISwitch *)swh {
    self.pieView.infoDetailFormat = swh.on? @"{n}: {v} 占比{.1p}": nil;
    [self.pieView reloadData];
}

- (void)setRaduis:(UISwitch *)swh {
    // 半径可传固定值或百分数，如果传百分数时，会基于pieView的宽高值较小的来计算
    // 例如 pieView.frame = CGRectMake(0, 0, 200, 100); raduis = @[@"50%"]; 则实际半径为 100 * .5 * 50%（100为直径，要先求半径再求百分比值）
    
    self.pieView.raduis = swh.on? @[@"70%", @50]: @[@"100"];
    [self.pieView reloadData];
}

- (void)setCustomView:(UISwitch *)swh {
    self.isCustom = swh.on;
    [self.pieView reloadData];
}

- (void)setStartingDirection:(UISegmentedControl *)seg {
    self.pieView.startDirection = (GHArcChartStartingDirection)seg.selectedSegmentIndex;
    [self.pieView reloadData];
}

- (NSDictionary<GHChartsInfoViewKey,id> *)chartView:(GHBaseChartsView *)chartView attributesForInfoViewAtIndex:(NSInteger)index {
    return @{GHChartsInfoViewDotTypeName: @(arc4random()%4), GHChartsInfoViewTitle: [NSString stringWithFormat:@"title %tu", index]};
}

- (UIView *)chartView:(GHPieChartView *)pieView infoView:(UIView *)infoView atIndex:(NSInteger)index {
    UIView *view = infoView;
    NSInteger tag = 10;
    // [infoView isMemberOfClass:你自定义的view.class]
    if (![infoView isMemberOfClass:UIView.class] && self.isCustom) {
        UILabel *label = UILabel.new;
        label.tag = tag;
        label.numberOfLines = 0;
        view = UIView.new;
        view.backgroundColor = UIColor.yellowColor;
        [view addSubview:label];
    }
    
    if (view) {
        UILabel *label = (UILabel *)[view viewWithTag:tag];
        label.text = [NSString stringWithFormat:@"标题\n名称：%@\n数据：%@", self.pieView.labels[index], self.pieView.values[index]];
        label.frame = CGRectMake(0, 0, 120, 10080);
        [label sizeToFit];
        CGSize size = CGRectInset(label.frame, -10, -10).size;
        CGRect rect = view.frame;
        rect.size = size; // 自定义的view需要确定size
        view.frame = rect;
        label.center = GHRectGetCenter(view.bounds);
    }
    return view;
}

@end
