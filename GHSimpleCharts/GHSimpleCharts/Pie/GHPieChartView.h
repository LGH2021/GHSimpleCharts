//
//  GHSimplePieView.h
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/18.
//  Copyright © 2021 LGH. All rights reserved.
//


#import "GHBaseChartsView.h"
#import "GHSimpleChartsEnum.h"
#import "GHCTool.h"
@protocol GHPieChartsInfoViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface GHPieChartView : GHBaseChartsView
/// 饼图颜色，默认为随机颜色
@property (nullable, strong, nonatomic) NSArray <UIColor *> *colors;

/// 开始位置，默认.top
@property (assign, nonatomic) GHArcChartStartingDirection startDirection;

/// YES:顺时针，NO:逆时针，默认NO
@property (assign, nonatomic) BOOL clockwise;

/// 位置偏移
@property (assign, nonatomic) CGPoint offset;

/// 饼图半径，1或2个元素，2个元素时为环形
@property (copy, nonatomic) NSArray *raduis;

/// 详情格式化：{n}为名称，{v}为数值，{p}为百分比；其中{.xp}表示保留x位小数，最多保留两位
@property (nullable, copy, nonatomic) NSString *infoDetailFormat;

@property (weak, nonatomic) id <GHPieChartsInfoViewDelegate> delegate;

- (void)hideInfoView;
- (void)showInfoViewAtIndex:(NSInteger)index;
@end


@protocol GHPieChartsInfoViewDelegate <NSObject>
@optional
/// 以下代理方法二选一，实现第一个后第二个会被忽略；点击chart view 弹出信息框

- (UIView *)chartView:(GHPieChartView *)pieView infoView:(UIView * _Nullable)infoView atIndex:(NSInteger)index;

- (NSDictionary <GHChartsInfoViewKey, id> *)chartView:(GHBaseChartsView *)chartView attributesForInfoViewAtIndex:(NSInteger)index;

@end
NS_ASSUME_NONNULL_END
