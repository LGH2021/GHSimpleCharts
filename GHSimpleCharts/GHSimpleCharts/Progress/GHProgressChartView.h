//
//  GHProgressView.h
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/18.
//  Copyright © 2021 LGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHSimpleChartsEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface GHProgressChartView : UIView

/** minValue ~ maxValue */
@property (assign, nonatomic) CGFloat value;

/** 最小值，默认0 */
@property (assign, nonatomic) CGFloat minValue;

/** 最大值，默认1 */
@property (assign, nonatomic) CGFloat maxValue;

/** 线宽，默认1 */
@property (assign, nonatomic) CGFloat lineWidth;

/** 半径 */
@property (assign, nonatomic) CGFloat radius;

/** 开始的角度，默认0；角度是顺时针增加！ */
@property (assign, nonatomic) CGFloat startAngle;

/** 结束的角度，默认 M_PI * 2 */
@property (assign, nonatomic) CGFloat endAngle;

/** YES:顺时针，NO:逆时针，默认YES */
@property (assign, nonatomic) BOOL clockwise;

/** 线的背景颜色 */
@property (strong, nonatomic) UIColor *bgStrokeColor;

/** progress 的颜色 */
@property (nonatomic) id tintStrokeColor;

/** 虚线 */
@property (nullable, copy, nonatomic) NSArray <NSNumber *> *lineDashPattern;

/** 位置偏移 */
@property (assign, nonatomic) CGPoint offset;

/** 开始位置，默认.up */
@property (assign, nonatomic) GHArcChartStartingDirection startDirection;

/** 动画时间 */
@property (assign, nonatomic) NSTimeInterval animateDuration;

/** 线的开始和结束是否为圆形，默认NO，虚线不生效 */
@property (assign, nonatomic) BOOL isLineCapRound;

- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
