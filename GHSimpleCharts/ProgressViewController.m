//
//  ProgressViewController.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/3/3.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "ProgressViewController.h"
#import "GHSimpleCharts.h"
#import "GHConfigs.h"
#import "UIViewController+CreateControl.h"
@interface ProgressViewController ()
@property (strong, nonatomic) GHProgressChartView *progressView;
@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    GHProgressChartView *progressView = [[GHProgressChartView alloc] initWithFrame:GHConfigs.chartViewFrame];
    progressView.animateDuration = 2;
    progressView.value = arc4random()%100/100.0;
    progressView.radius = 100;
    progressView.bgStrokeColor = UIColor.lightGrayColor;
    progressView.tintStrokeColor = UIColor.orangeColor;
    progressView.lineWidth = 15;
    progressView.clockwise = NO;
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    NSArray *arr = @[
        @{@"title": @"顺时针", @"sel": @"setClockwise:"},
        @{@"title": @"渐变色", @"sel": @"setColors:"},
        @{@"title": @"线的形状", @"sel": @"setCap:"},
        @{@"title": @"虚线", @"sel": @"setDash:"},
        @{@"title": @"起始角度", @"sel": @"setAngle:"},
        @{@"title": @"开始位置", @"sel": @"setStartingDirection:", @"items": @[@"上", @"下", @"左", @"右"]},
    ];
    
    [self addSubviewsWithArray:arr];
}

- (void)setClockwise:(UISwitch *)swh {
    self.progressView.clockwise = swh.on;
    [self.progressView reloadData];
}

- (void)setColors:(UISwitch *)swh {
    self.progressView.tintStrokeColor = swh.on? @[UIColor.cyanColor, UIColor.greenColor]: UIColor.orangeColor;
    [self.progressView reloadData];
}

- (void)setCap:(UISwitch *)swh {
    // 虚线是不生效
    self.progressView.isLineCapRound = swh.on;
    [self.progressView reloadData];
}

- (void)setDash:(UISwitch *)swh {
    self.progressView.lineDashPattern = swh.on? @[@5, @3]: nil;
    [self.progressView reloadData];
}

- (void)setAngle:(UISwitch *)swh {
    self.progressView.startAngle = swh.on? M_PI_2/4: 0;
    self.progressView.endAngle = swh.on? M_PI * 3/4: M_PI * 2;
    [self.progressView reloadData];
}

- (void)setStartingDirection:(UISegmentedControl *)seg {
    self.progressView.startDirection = (GHArcChartStartingDirection)seg.selectedSegmentIndex;
    [self.progressView reloadData];
}
@end
