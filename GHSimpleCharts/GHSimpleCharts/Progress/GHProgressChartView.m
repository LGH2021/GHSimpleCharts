//
//  GHProgressView.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/18.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "GHProgressChartView.h"
#import "GHCTool.h"
@interface GHProgressChartView ()
{
    CGFloat _tempPI;
}

@property (strong, nonatomic) CAShapeLayer *bgLayer;
@property (strong, nonatomic) CAShapeLayer *progressLayer;

@end

@implementation GHProgressChartView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.maxValue = 1;
    self.lineWidth = 1;
    self.bgStrokeColor = UIColor.lightGrayColor;
    self.tintStrokeColor = UIColor.orangeColor;
    self.endAngle = M_PI * 2;
    self.clockwise = YES;
    self.startDirection = GHArcChartStartingDirectionUp;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _setupLayerPath];
    });
}

- (void)_setupLayerPath {
    [self.layer addSublayer:self.bgLayer];
    [self.layer addSublayer:self.progressLayer];
    
    CGFloat radius = self.radius;
    if (radius == 0) {
        radius = GHRectGetMin(self.bounds)/2;
    }
      
    if (radius * 2 + self.lineWidth > GHRectGetMin(self.bounds)) {
        radius -= (radius + self.lineWidth/2 - GHRectGetMin(self.bounds)/2);
    }
    
    if (self.animateDuration > 0) {
        [self.progressLayer removeAnimationForKey:@"ak"];
        self.progressLayer.strokeEnd = 0;
        [self.progressLayer addAnimation:[self animationWithFrom:@0 to:@([self progressWithValue:self.value])] forKey:@"ak"];
    } else {
        self.progressLayer.strokeEnd = [self progressWithValue:self.value];
    }
    
      
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2 + self.offset.x, self.bounds.size.height/2 + self.offset.y) radius:radius startAngle:(self.startAngle * (self.clockwise * 2 - 1) + _tempPI) endAngle:(self.endAngle * (self.clockwise * 2 - 1) + _tempPI) clockwise:self.clockwise];
    
    self.bgLayer.frame = self.bounds;
    self.bgLayer.path = path.CGPath;
      
    self.progressLayer.frame = self.bounds;
    self.progressLayer.path = path.CGPath;
    
    if (self.lineDashPattern.count >= 2) {
        self.progressLayer.lineCap = kCALineCapButt;
    } else {
        self.progressLayer.lineCap = self.isLineCapRound? kCALineCapRound: kCALineCapButt;
    }
    if (self.endAngle - self.startAngle != M_PI * 2) {
        self.bgLayer.lineCap = self.progressLayer.lineCap;
    }
    
    if ([self.tintStrokeColor isKindOfClass:NSArray.class] && [self.tintStrokeColor count] > 1) {
        [self.progressLayer removeFromSuperlayer];
        NSMutableArray *cArr = [NSMutableArray arrayWithCapacity:[self.tintStrokeColor count]];
        for (int i = 0; i < [self.tintStrokeColor count]; i++) {
            id obj = [self.tintStrokeColor objectAtIndex:i];
            if ([obj isKindOfClass:UIColor.class]) {
                UIColor *color = obj;
                [cArr addObject:(__bridge id)color.CGColor];
            }
        }
        CAGradientLayer *gradLayer = CAGradientLayer.layer;
        [self.layer addSublayer:gradLayer];
        gradLayer.frame = self.bounds;
        gradLayer.colors = cArr;
        CGPoint start = CGPointZero;
        CGPoint end = CGPointZero;
        switch (self.startDirection) {
            case GHArcChartStartingDirectionUp: {
                end = CGPointMake(0, 1);
            }
                break;
            case GHArcChartStartingDirectionDown: {
                start = CGPointMake(0, 1);
          
            }
                break;
            case GHArcChartStartingDirectionLeft: {
                end = CGPointMake(1, 0);
            }
                break;
            case GHArcChartStartingDirectionRight: {
                start = CGPointMake(1, 0);
            }
                break;
            default:
                break;
        }
        gradLayer.startPoint = start;
        gradLayer.endPoint = end;
        gradLayer.mask = self.progressLayer;
    }
}

- (CGFloat)progressWithValue:(CGFloat)value {
    CGFloat progress = (value - self.minValue)/(self.maxValue - self.minValue);
    if (progress > 1) {
        progress = 1;
    } else if (progress < 0) {
        progress = 0;
    }
    return progress;
}

- (void)reloadData {
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self _setupLayerPath];
}
#pragma mark - setter
- (void)setStartDirection:(GHArcChartStartingDirection)direction {
    _startDirection = direction;
    _tempPI = [@{
        @(GHArcChartStartingDirectionLeft): @(M_PI),
        @(GHArcChartStartingDirectionUp): @(M_PI * 3 /2),
        @(GHArcChartStartingDirectionRight): @0,
        @(GHArcChartStartingDirectionDown): @(M_PI/2)
    }[@(direction)] floatValue];
}

- (void)setLineDashPattern:(NSArray<NSNumber *> *)lineDashPattern {
    _lineDashPattern = lineDashPattern;
    self.bgLayer.lineDashPattern = lineDashPattern;
    self.progressLayer.lineDashPattern = lineDashPattern;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.bgLayer.lineWidth = lineWidth;
    self.progressLayer.lineWidth = lineWidth;
}

- (void)setBgStrokeColor:(UIColor *)bgStrokeColor {
    _bgStrokeColor = bgStrokeColor;
    self.bgLayer.strokeColor = bgStrokeColor.CGColor;
}

- (void)setTintStrokeColor:(id)tintStrokeColor {
    _tintStrokeColor = tintStrokeColor;
    if ([tintStrokeColor isKindOfClass:UIColor.class]) {
        self.progressLayer.strokeColor = [tintStrokeColor CGColor];
    } else if ([tintStrokeColor isKindOfClass:NSArray.class] && [tintStrokeColor count] == 1) {
        self.progressLayer.strokeColor = [tintStrokeColor CGColor];
    }
}

- (void)setValue:(CGFloat)value {

    if (self.animateDuration == 0) {
        _value = value;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.progressLayer.strokeEnd = [self progressWithValue:value];
        [CATransaction commit];
        return;
    }

    [self.progressLayer addAnimation:[self animationWithFrom:@([self progressWithValue:self.value]) to:@([self progressWithValue:value])] forKey:@"ak"];
    
    _value = value;
}

- (CABasicAnimation *)animationWithFrom:(id)from to:(id)to {
    CABasicAnimation *ba = [GHCTool animationWithKeyPath:@"strokeEnd" from:from to:to duration:self.animateDuration];
    ba.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return ba;
}

#pragma mark - lazy
- (CAShapeLayer *)bgLayer {
    if (!_bgLayer) {
        _bgLayer = CAShapeLayer.layer;
        _bgLayer.fillColor = UIColor.clearColor.CGColor;
    }
    return _bgLayer;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = CAShapeLayer.layer;
        _progressLayer.fillColor = UIColor.clearColor.CGColor;
    }
    return _progressLayer;
}

@end
