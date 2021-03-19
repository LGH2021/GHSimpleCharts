//
//  RadarViewController.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/3/3.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "RadarViewController.h"
#import "GHSimpleCharts.h"
#import "UIColor+GHSimpleCharts.h"
#import "GHConfigs.h"

@interface RadarViewController ()
@end

@implementation RadarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    NSDictionary *chartDict = GHConfigs.chartViewDatas;
    GHRadarChartView *radarView = [[GHRadarChartView alloc] initWithFrame:GHConfigs.chartViewFrame];
    radarView.raduis = 100;
    radarView.values = chartDict[@"values"];
    radarView.labels = chartDict[@"labels"];
    radarView.clockwise = NO;
    radarView.valueFillColor = UIColorRGBA(84, 112, 198, 0.5);
    radarView.showValues = YES;
    radarView.animateDuration = 1;
    radarView.spacingColor1 = UIColor.whiteColor;
    radarView.spacingColor2 = UIColorRGB(246, 248, 252);
    [self.view addSubview:radarView];
   
}
@end
