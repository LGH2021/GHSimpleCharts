//
//  GHRadarChartView.h
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/26.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "GHBaseChartsView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GHRadarChartView : GHBaseChartsView
/** YES:顺时针，NO:逆时针，默认NO */
@property (assign, nonatomic) BOOL clockwise;
/** 位置偏移 */
@property (assign, nonatomic) CGPoint offset;
/** 半径 */
@property (assign, nonatomic) CGFloat raduis;

/// 分隔颜色
@property (strong, nonatomic) UIColor *spacingColor1;
@property (strong, nonatomic) UIColor *spacingColor2;

/// 分隔线颜色
@property (strong, nonatomic) UIColor *spacingLineColor;

/// 角度线颜色
@property (strong, nonatomic) UIColor *angleLineColor;

/// 自定义最大值
@property (assign, nonatomic) CGFloat max;

/// value 的线颜色
@property (strong, nonatomic) UIColor *valueLineColor;

/// value 的填充颜色
@property (strong, nonatomic) UIColor *valueFillColor;

/// value 文字的颜色
@property (strong, nonatomic) UIColor *valueLabelColor;

/// value 文字的font
@property (strong, nonatomic) UIFont *valueLabelFont;


@end

NS_ASSUME_NONNULL_END
