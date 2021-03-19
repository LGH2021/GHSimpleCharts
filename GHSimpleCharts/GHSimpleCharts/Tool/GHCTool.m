//
//  GHCTool.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/18.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "GHCTool.h"

@implementation GHCTool
CGFloat GHRectGetMin(CGRect rect) {
    return MIN(rect.size.height, rect.size.width);
}

CGPoint GHRectGetCenter(CGRect rect) {
    return CGPointMake((rect.size.width - rect.origin.x)/2, (rect.size.height - rect.origin.y)/2);
}

+ (CABasicAnimation *)animationWithKeyPath:(NSString *)path from:(id)fv to:(id)tv duration:(CFTimeInterval)duration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:path];
    animation.fromValue = fv;
    animation.toValue = tv;
    animation.duration = duration;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

+ (CAShapeLayer *)layerWithPath:(UIBezierPath *)path {
    CAShapeLayer *layer = CAShapeLayer.layer;
    layer.fillColor = UIColor.clearColor.CGColor;
    layer.path = path.CGPath;
    return layer;
}

+ (CGPoint)pointWithLength:(CGFloat)length angle:(CGFloat)angle center:(CGPoint)point clockwise:(BOOL)clockwise direction:(GHArcChartStartingDirection)direction {
    
    CGFloat lineAngle = angle;
    if (direction == GHArcChartStartingDirectionLeft) {
        lineAngle += M_PI_2;
    } else if (direction == GHArcChartStartingDirectionDown) {
        lineAngle += M_PI;
    } else if (direction == GHArcChartStartingDirectionRight) {
        lineAngle += M_PI_2 * 3;
    }
           
    if (lineAngle >= M_PI * 2) {
        lineAngle -= M_PI * 2;
    }
           
    if (clockwise) {
        lineAngle = M_PI * 2 - lineAngle;
    }
           
    CGFloat x = sin(lineAngle) * length;
    CGFloat y = cos(lineAngle) * length;
      
    if (clockwise && (direction == GHArcChartStartingDirectionLeft || direction == GHArcChartStartingDirectionRight)) {
        x *= -1;
        y *= -1;
    }
    
    return CGPointMake(point.x - x, point.y - y);
}
@end
