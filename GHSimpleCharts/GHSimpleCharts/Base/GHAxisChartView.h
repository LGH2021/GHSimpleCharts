//
//  GHAxisChartView.h
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/20.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "GHBaseChartsView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GHAxisDegreeOrientation) {
    GHAxisDegreeOrientationNone,
    GHAxisDegreeOrientationLeft,
    GHAxisDegreeOrientationRight,
    GHAxisDegreeOrientationUp,
    GHAxisDegreeOrientationDown
};

@interface GHAxisChartView : GHBaseChartsView
@property (strong, nonatomic, readonly) UIScrollView *scrollView;



/** x轴最小间隔，默认10 */
@property (assign, nonatomic) CGFloat minXAxisSpacing;

/** 柱状图柱子的宽度，折线图不生效 */
@property (assign, nonatomic) CGFloat barWidth;

/// 坐标轴名称
@property (nullable, copy, nonatomic) NSString *yAxisName;
@property (nullable, copy, nonatomic) NSString *xAxisName;
/// end

/// 坐标轴刻度的朝向
@property (assign, nonatomic) GHAxisDegreeOrientation yDegreeOrientation;
@property (assign, nonatomic) GHAxisDegreeOrientation xDegreeOrientation;
/// end

/// 是否从 y 轴开始画线，柱状图不生效 
@property (assign, nonatomic) BOOL startAtYAxis;

/// 超出坐标轴最大值的长度，定义后会加个小箭头
@property (assign, nonatomic) CGFloat xAxisExcessLength;
@property (assign, nonatomic) CGFloat yAxisExcessLength;
/// end

/// 坐标轴颜色
@property (strong, nonatomic) UIColor *yAxisColor;
@property (strong, nonatomic) UIColor *xAxisColor;
/// end

/// 坐标轴名称的颜色
@property (strong, nonatomic) UIColor *yAxisLabelColor;
@property (strong, nonatomic) UIColor *xAxisLabelColor;
/// end

/// 折线点半径, 柱状图不生效
@property (assign, nonatomic) CGFloat pointRadius;

/// 值颜色
@property (strong, nonatomic) UIColor *valueColor;
@end

NS_ASSUME_NONNULL_END
