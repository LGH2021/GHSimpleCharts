//
//  GHLineChartView.h
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/20.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "GHAxisChartView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GHValuePosition) {
    GHValuePositionAuto = 0,
    GHValuePositionUp = -1,
    GHValuePositionDown = 1
};

@interface GHLineChartView : GHAxisChartView

/// 折线的颜色
@property (strong, nonatomic) UIColor *lineColor;

/// 折线区域填充的颜色，多个时会渐变
@property (nullable, copy, nonatomic) NSArray <UIColor *> *areaColors;

/// 是否为曲线
@property (assign, nonatomic) BOOL isCurve;

/// 折线点的颜色
@property (strong, nonatomic) UIColor *pointColor;

/// value对应点的位置
@property (assign, nonatomic) GHValuePosition valuePosition;
@end

NS_ASSUME_NONNULL_END
