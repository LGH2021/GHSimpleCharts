//
//  GHLineChartView.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/20.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "GHLineChartView.h"
#import "NSString+GHSimpleCharts.h"
#import "GHCTool.h"
@interface GHLineChartView ()
{
    CGFloat _chartHeight;
    CGPoint _lastPoint;
    CGFloat _startX;
    CGFloat _endX;
}
@property (strong, nonatomic) CAShapeLayer *lineLayer;
@property (strong, nonatomic) UIBezierPath *linePath;
@property (strong, nonatomic) NSMutableArray *pointLayerArray;

@property (strong, nonatomic) UIBezierPath *colorPath;
@property (strong, nonatomic) CAShapeLayer *colorLayer;

@property (strong, nonatomic) UIView *animationView;
@end

@implementation GHLineChartView
- (void)initialize {
    [super initialize];
    self.backgroundColor = UIColor.whiteColor;
    self.lineColor = UIColor.darkGrayColor;
    
}

#pragma mark - override
- (void)drawAtIndex:(NSUInteger)index point:(CGPoint)point chartHeight:(CGFloat)ch {
    _chartHeight = ch;
    [self drawLineAtIndex:index point:point];
    
    if (self.pointRadius > 0) {
        [self addTurningPoint:point];
    }
}

- (void)chartViewWillDrawValues {
    CGRect rect = CGRectZero;
    rect.size = self.scrollView.contentSize;
    self.animationView.frame = rect;
    [self addAnimation];
    [self addAreaColors];
}

#pragma mark - private

- (void)drawLineAtIndex:(NSUInteger)index point:(CGPoint)point {
    
    if (index == 0) {
        self.linePath = UIBezierPath.bezierPath;
        [self.linePath moveToPoint:point];
        
        if (self.areaColors) {
            self.colorPath = UIBezierPath.bezierPath;
            [self.colorPath moveToPoint:CGPointMake(point.x, _chartHeight)];
            [self.colorPath addLineToPoint:point];
            _startX = point.x;
        }
        
    } else {
        if (self.isCurve) {
            [self.linePath addCurveToPoint:point controlPoint1:CGPointMake((point.x+_lastPoint.x)/2, _lastPoint.y) controlPoint2:CGPointMake((point.x+_lastPoint.x)/2, point.y)];
            
            [self.colorPath addCurveToPoint:point controlPoint1:CGPointMake((point.x+_lastPoint.x)/2, _lastPoint.y) controlPoint2:CGPointMake((point.x+_lastPoint.x)/2, point.y)];
        } else {
            [self.linePath addLineToPoint:point];
            [self.colorPath addLineToPoint:point];
        }
    }
    
    if (index == self.minCount - 1) {
        self.lineLayer.path = self.linePath.CGPath;
        
        [self.colorPath addLineToPoint:CGPointMake(point.x, _chartHeight)];
        self.colorLayer.path = self.colorPath.CGPath;
        _endX = point.x;
    }
    _lastPoint = point;
}

- (void)addTurningPoint:(CGPoint)point {
    UIBezierPath *pointPath = [UIBezierPath bezierPathWithArcCenter:point radius:self.pointRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    CAShapeLayer *pointLayer = CAShapeLayer.layer;
    pointLayer.path = pointPath.CGPath;
    pointLayer.fillColor = self.pointColor.CGColor;
    
    [self.scrollView.layer addSublayer:pointLayer];;
    [self.pointLayerArray addObject:pointLayer];
}

- (void)addAnimation {
    if (self.animateDuration) {
        CGRect rect = self.animationView.bounds;
        CGRect rect1 = rect;
        rect1.size.width = _startX;
          
        self.animationView.frame = rect1;
            
        rect1.size.width = _endX;
        [UIView animateWithDuration:self.animateDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
               
            self.animationView.frame = rect1;
        } completion:nil];
    }
}

- (void)addAreaColors {
     if (!self.areaColors) {
        return;
    }
     
    CAGradientLayer *gradLayer = CAGradientLayer.layer;
        
    [self.animationView.layer insertSublayer:gradLayer below:self.lineLayer];

    gradLayer.frame = self.animationView.bounds;
    
    NSMutableArray *cArr = @[].mutableCopy;
    NSInteger count = MAX(self.areaColors.count, 2);
    for (int i = 0; i < count; i++) {
        if (i < self.areaColors.count) {
            [cArr addObject:(__bridge id)[self.areaColors[i] CGColor]];
        } else {
            [cArr addObject:(__bridge id)[self.areaColors[0] CGColor]];
        }
    }
    gradLayer.colors = cArr;
    gradLayer.startPoint = CGPointZero;
    gradLayer.endPoint = CGPointMake(0, 1);
    gradLayer.mask = self.colorLayer;
}

#pragma mark - lazy
- (CAShapeLayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = CAShapeLayer.layer;
        _lineLayer.strokeColor = self.lineColor.CGColor;
        _lineLayer.fillColor = UIColor.clearColor.CGColor;
        
    }
    return _lineLayer;
}

- (CAShapeLayer *)colorLayer {
    if (!_colorLayer && self.areaColors) {
        _colorLayer = CAShapeLayer.layer;
        _colorLayer.lineWidth = 1;
    }
    return _colorLayer;
}

- (NSMutableArray *)pointLayerArray {
    if (!_pointLayerArray) {
        _pointLayerArray = [NSMutableArray arrayWithCapacity:self.minCount];
    }
    return _pointLayerArray;
}

- (UIView *)animationView {
    if (!_animationView) {
        _animationView = UIView.new;
        _animationView.clipsToBounds = YES;
        [_animationView.layer addSublayer:self.lineLayer];
    }
    
    if (!_animationView.superview) {
        [self.scrollView insertSubview:_animationView atIndex:0];
    }
    return _animationView;
}

- (void)reloadData {
    [_animationView removeFromSuperview];
    _animationView = nil;
    [super reloadData];
}
@end
