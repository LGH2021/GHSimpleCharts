//
//  GHBarChartView.h
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/25.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "GHAxisChartView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GHBarChartView : GHAxisChartView
/// 柱子背景色
@property (nullable, strong, nonatomic) UIColor *barBackgroundColor;

/// 柱子颜色，可传多个不同颜色
@property (nonatomic) id barTintColors;

/// 用图片代替背景柱子
@property (nullable, strong, nonatomic) UIImage *barBackgroundImage;

/// 用图片代替柱子
@property (nullable, strong, nonatomic) UIImage *barTintImage;
@end

NS_ASSUME_NONNULL_END
