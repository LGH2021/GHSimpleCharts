//
//  GHCTool.h
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/18.
//  Copyright © 2021 LGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHSimpleChartsEnum.h"
/** 获取 width/height 较小的值 */
CG_EXTERN CGFloat GHRectGetMin(CGRect rect);

/** 获取 rect 的中心点 */
CG_EXTERN CGPoint GHRectGetCenter(CGRect rect);

NS_ASSUME_NONNULL_BEGIN

@interface GHCTool : NSObject
+ (CABasicAnimation *)animationWithKeyPath:(NSString *)path from:(id)fv to:(id)tv duration:(CFTimeInterval)duration;

+ (CAShapeLayer *)layerWithPath:(UIBezierPath *)path;

+ (CGPoint)pointWithLength:(CGFloat)length angle:(CGFloat)angle center:(CGPoint)point clockwise:(BOOL)clockwise direction:(GHArcChartStartingDirection)direction;
@end

NS_ASSUME_NONNULL_END
