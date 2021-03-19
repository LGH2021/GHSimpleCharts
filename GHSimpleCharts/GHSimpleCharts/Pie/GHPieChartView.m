//
//  GHSimplePieView.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/18.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "GHPieChartView.h"
#import "GHCTool.h"
#import "UIColor+GHSimpleCharts.h"
@interface GHPieChartView ()
{
    CGFloat _tempPI;
    UIView *_ifv;
    CGPoint _arcCenter;
    CGFloat _maxRadius;
    CGFloat _radius;
    NSInteger _selectedIndex;
    CGFloat _lineWidth;
}

@property (strong, nonatomic) CAShapeLayer *pointLayer;
@property (strong, nonatomic) GHChartsInfoView *infoView;
@property (strong, nonatomic) NSMutableArray *pieLayerArray;
@property (strong, nonatomic) NSMutableArray *startEndAngleArray;
@property (strong, nonatomic) NSMutableArray *angleArray;
@property (strong, nonatomic) NSMutableDictionary *centerPointDict;
@end

@implementation GHPieChartView

/** infoView 移动动画时长 */
static CGFloat const kInfoViewAnimationDuration = 0.5;

/** 点击时半径增加宽度 */
static CGFloat const kBigLayerRadius = 5;

/** lable 与 点的间隔 */
static CGFloat const kLabelToPointSpacing = 5;

static NSString * const kDefaultFormat = @"{n}：{v}";
- (void)initialize {
    [super initialize];
    
    self.startDirection = GHArcChartStartingDirectionUp;
    _selectedIndex = -1;

    
}

- (void)reloadData {
    _ifv = nil;
    [super reloadData];
}

- (void)draws {
    
    CGFloat min = GHRectGetMin(self.bounds);
    _maxRadius = min/2;
    _lineWidth = _maxRadius;
    _radius = _lineWidth/2;
    
    if (self.raduis.count > 0) {
        if (self.raduis.count == 1) {
            id raduis = self.raduis.lastObject;
            _lineWidth = [self radiusWithObj:raduis];
            _radius = _lineWidth/2;
        } else if (self.raduis.count > 1) {
            id obj1 = self.raduis[0];
            id obj2 = self.raduis[1];
            
            CGFloat r1 = [self radiusWithObj:obj1];
            CGFloat r2 = [self radiusWithObj:obj2];
            
            CGFloat oRadius = MAX(r1, r2);
            CGFloat iRadius = MIN(r1, r2);
            
            _lineWidth = oRadius - iRadius;
            _radius = oRadius - _lineWidth/2;
        }
    }
   
    [self.pieLayerArray removeAllObjects];
    [self.angleArray removeAllObjects];
    [self.startEndAngleArray removeAllObjects];

    CGFloat angle = _tempPI;
    _arcCenter = CGPointMake(self.bounds.size.width/2 + self.offset.x, self.bounds.size.height/2 + self.offset.y);
    CGFloat delay = 0;
    for (int index = 0; index < self.minCount; index++) {
        UIColor *color;
        if (index < self.colors.count) {
            color = self.colors[index];
        } else {
            color = UIColor.randomColor;
        }
        
        CGFloat value = [self.values[index] floatValue];
        CGFloat startAngle = angle;
        CGFloat precent = value/self.total;
        CGFloat duration = [self durationWithPrecent:precent];
        CGFloat endAngle = startAngle + precent * 2 * M_PI * (self.clockwise * 2 - 1);
        
        CGFloat v = precent * 2 * M_PI;
        CGFloat lineAngle = v/2;
        
        if (index > 0) {
            CGFloat lastAngle = [self.angleArray[index - 1] floatValue];
            v += lastAngle;
            lineAngle += lastAngle;
        }
        
      
        CGPoint p1 = [self pointWithLength:_radius + _lineWidth/2 angle:lineAngle];
        CGPoint p2 = [self pointWithLength:(_radius + _lineWidth/2 + 10) angle:lineAngle];
        CGPoint c = [self pointWithLength:_radius angle:lineAngle];
        
        
        self.centerPointDict[@(index)] = [NSValue valueWithCGPoint:c];
        
        UIBezierPath *linePath = UIBezierPath.bezierPath;
        [linePath moveToPoint:p1];
        [linePath addLineToPoint:p2];
        
        CGFloat fs = 12;
        CGFloat dis = 10;
        CGFloat lx = 0;
        CGFloat lw = p2.x - dis - kLabelToPointSpacing;
        CGFloat lh = 20;
        CGFloat ly = p2.y - lh/2;
        NSTextAlignment ta = NSTextAlignmentRight;
        
        if (_arcCenter.x < p1.x) {
            dis = -10;
            lx = p2.x - dis + kLabelToPointSpacing;
            lw = self.bounds.size.width - lx;
            ta = NSTextAlignmentLeft;
        } else if (p1.x == _arcCenter.x) {
            dis = 0;
            lw = self.bounds.size.width;
            ly = p2.x - fs - kLabelToPointSpacing;
            if (p2.y < _arcCenter.y) {
                ly = p2.y + kLabelToPointSpacing;
            }
            ta = NSTextAlignmentCenter;
        }
        
        [linePath addLineToPoint:CGPointMake(p2.x - dis, p2.y)];
        
        if (self.raduis.count == 2) {
            delay = 0;
            duration = self.animateDuration;
        }
        
        CAShapeLayer *lineLayer = CAShapeLayer.layer;
        lineLayer.lineWidth = 1;
        lineLayer.path = linePath.CGPath;
        lineLayer.strokeColor = color.CGColor;
        lineLayer.strokeEnd = 0;
        lineLayer.fillColor = UIColor.clearColor.CGColor;
       
        [self.layer addSublayer:lineLayer];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(lx, ly, lw, lh)];
        label.textAlignment = ta;
        label.text = self.labels[index];
        label.font = [UIFont systemFontOfSize:fs];
        label.textColor = UIColor.darkGrayColor;
        [self addSubview:label];
        
        
        [self.angleArray addObject:@(v)];
        
        
        [self.startEndAngleArray addObject:@{@"start": @(startAngle), @"end": @(endAngle)}];
        
        
        CAShapeLayer *layer = CAShapeLayer.layer;
        layer.strokeStart = 0;
        layer.strokeEnd = 0;
        layer.fillColor = UIColor.clearColor.CGColor;
        layer.strokeColor = color.CGColor;
        
        
        [self.layer addSublayer:layer];
        [self.pieLayerArray addObject:layer];
        [self setupPieLayerAtIndex:index isSelected:NO];
        
        if (self.animateDuration > 0) {
            label.alpha = 0;
            [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
                label.alpha = 1;
            } completion:nil];
            
            [lineLayer addAnimation:[self animationWithDelay:delay duration:duration] forKey:@"l"];
            [layer addAnimation:[self animationWithDelay:delay duration:duration] forKey:@"s"];
        }
        
        angle = endAngle;
        delay += duration;
    }
}

#pragma mark - apis
- (void)hideInfoView {
    [UIView animateWithDuration:kInfoViewAnimationDuration/2 animations:^{
        self->_ifv.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            self->_ifv.hidden = YES;
        }
    }];
    [self setupPieLayerAtIndex:_selectedIndex isSelected:NO];
    _selectedIndex = -1;
}

- (void)showInfoViewAtIndex:(NSInteger)index {
    [self showInfoViewAtIndex:index center:CGPointZero];
}

#pragma mark - private

- (void)showInfoViewAtIndex:(NSInteger)index center:(CGPoint)point {
    if (index != _selectedIndex) {
        [self setupPieLayerAtIndex:_selectedIndex isSelected:NO];
        [self setupPieLayerAtIndex:index isSelected:YES];
        _selectedIndex = index;
    }
    
    if (CGPointEqualToPoint(CGPointZero, point)) {
        point = [self.centerPointDict[@(index)] CGPointValue];
    }
    
    UIView *difv = nil;
    if (![_ifv isKindOfClass:self.infoView.class]) {
        difv = _ifv;
    }
    if ([self.delegate respondsToSelector:@selector(chartView:infoView:atIndex:)] && (difv = [self.delegate chartView:self infoView:difv atIndex:index])) {
        
        UIView *view = difv;
        if (_ifv) {
            view.hidden = _ifv.hidden;
        } else {
            view.hidden = YES;
        }
        if (![_ifv isKindOfClass:view.class]) {
            _ifv = view;
        }
    } else {
        NSDictionary *dict = nil;
        if ([self.delegate respondsToSelector:@selector(chartView:attributesForInfoViewAtIndex:)]) {
            dict = [self.delegate chartView:self attributesForInfoViewAtIndex:index];
        }
        CGFloat value = 100 * [self.values[index] floatValue]/self.total;
        NSString *infoFormat = self.infoDetailFormat ?: kDefaultFormat;
        NSString *detail = [[[[[infoFormat stringByReplacingOccurrencesOfString:@"{n}" withString:self.labels[index]] stringByReplacingOccurrencesOfString:@"{v}" withString:[NSString stringWithFormat:@"%@", self.values[index]]] stringByReplacingOccurrencesOfString:@"{p}" withString:[NSString stringWithFormat:@"%.f%@", value, @"%"]] stringByReplacingOccurrencesOfString:@"{.1p}" withString:[NSString stringWithFormat:@"%.1f%@", value, @"%"]] stringByReplacingOccurrencesOfString:@"{.2p}" withString:[NSString stringWithFormat:@"%.2f%@", value, @"%"]];
        
        NSMutableDictionary *mDict = @{
            GHChartsInfoViewTitle: self.title ?: @"",
            GHChartsInfoViewDetail: detail,
            GHChartsInfoViewDotBackgroundColor: [UIColor colorWithCGColor:[self.pieLayerArray[index] strokeColor]],
            GHChartsInfoViewMaxWidth: @(200)
        }.mutableCopy;
        
        if (dict) {
            [mDict addEntriesFromDictionary:dict];
        }
        
        self.infoView.attrDict = mDict.copy;
    }
    
    if (!_ifv) {
        _ifv = self.infoView;
    }
    
    if (!_ifv.superview) {
        [self addSubview:_ifv];
    }
    
    if (_ifv.hidden) {
        _ifv.hidden = NO;
        _ifv.center = point;
        _ifv.alpha = 0;
        [UIView animateWithDuration:kInfoViewAnimationDuration/2 animations:^{
            self->_ifv.alpha = 1;
        }];
    } else {
        
        [UIView animateWithDuration:kInfoViewAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self->_ifv.center = point;
        } completion:nil];
    }
}

- (CGFloat)radiusWithObj:(id)obj {
    CGFloat radius ;
    if ([obj isKindOfClass:NSString.class] && [obj hasSuffix:@"%"]) {
        radius = _maxRadius * [[obj stringByReplacingOccurrencesOfString:@"%" withString:@""] floatValue] / 100.0;
    } else {
        radius = [obj floatValue];
    }
    return radius;
}

- (void)setupPieLayerAtIndex:(NSUInteger)index isSelected:(BOOL)isSelected {
    if (index >= self.pieLayerArray.count) {
        return;
    }
          
    CAShapeLayer *layer = self.pieLayerArray[index];
    NSDictionary *angleDict = self.startEndAngleArray[index];
    CGFloat lineWidth = _lineWidth;
    CGFloat radius = _radius;
    
    if (isSelected) {
        lineWidth += kBigLayerRadius;
        radius += kBigLayerRadius/2;
    }
    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    layer.lineWidth = lineWidth;
    layer.path = [UIBezierPath bezierPathWithArcCenter:_arcCenter radius:radius startAngle:[angleDict[@"start"] floatValue] endAngle:[angleDict[@"end"] floatValue] clockwise:self.clockwise].CGPath;
    [CATransaction commit];
}

- (CAAnimation *)animationWithDelay:(CGFloat)delay duration:(NSTimeInterval)duration {
    
    CABasicAnimation *animation = [GHCTool animationWithKeyPath:@"strokeEnd" from:@0 to:@1 duration:duration];
    animation.beginTime = CACurrentMediaTime() + delay;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    return animation;
}

- (CGFloat)durationWithPrecent:(CGFloat)precent {
    return precent * self.animateDuration;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    
    if (CGPointEqualToPoint(point, _arcCenter)) {
        return;
    }
    CGFloat len = hypot(fabs(point.x-_arcCenter.x), fabs(point.y-_arcCenter.y));
    if (_radius - _lineWidth/2 >= len || len >= _radius + _lineWidth/2) {
        [self hideInfoView];
        return;
    }

    CGFloat angle = [self angleOfTouchPoint:point];
    
    NSInteger index = [self indexOfTouchPointAngle:angle];
    
    [self showInfoViewAtIndex:index center:point];
}

- (CGFloat)angleOfTouchPoint:(CGPoint)point {
    CGFloat a = 0;
    CGFloat b = 0;
    
    switch (self.startDirection) {
        case GHArcChartStartingDirectionUp: {
            a = point.x - _arcCenter.x;
            b = point.y - _arcCenter.y;
        }
            break;
            
        case GHArcChartStartingDirectionLeft: {
            b = point.x - _arcCenter.x;
            a = _arcCenter.y - point.y;
        }
            break;
            
        case GHArcChartStartingDirectionDown: {
            a = _arcCenter.x - point.x;
            b = _arcCenter.y - point.y;
        }
            break;
            
        case GHArcChartStartingDirectionRight: {
            b = _arcCenter.x - point.x;
            a = point.y - _arcCenter.y;
        }
            break;
            
        default:
            break;
    }
    CGFloat angle = atan(a/b);
    if (b >= 0) {
        angle = M_PI + angle;
    } else if (a > 0 && b < 0) {
        angle = M_PI * 2 + angle;
    } else if (a == 0 && b > 0) {
        angle = 0;
    }
    
    if (self.clockwise && angle != 0) {
        angle = M_PI * 2 - angle;
    }
    return angle;
}

- (NSInteger)indexOfTouchPointAngle:(CGFloat)angle {
    NSInteger index = NSNotFound;
    for (int i = 0; i < self.minCount - 1; i++) {
        CGFloat v1 = 0;
        if (i > 0) {
            v1 = [self.angleArray[i-1] floatValue];
        }
        CGFloat v2 = [self.angleArray[i] floatValue];
        CGFloat minV = MIN(v1, v2);
        CGFloat maxV = MAX(v1, v2);
        if (minV <= angle && angle < maxV) {
            index = i;
            break;
        }
    }
    
    if (index == NSNotFound) {
        index = self.minCount - 1;
    }
    return index;
}

- (CGPoint)pointWithLength:(CGFloat)length angle:(CGFloat)angle {
    return [GHCTool pointWithLength:length angle:angle center:_arcCenter clockwise:self.clockwise direction:self.startDirection];
}

#pragma mark - setter
- (void)setStartDirection:(GHArcChartStartingDirection)startDirection {
    _startDirection = startDirection;
    _tempPI = [@{
        @(GHArcChartStartingDirectionLeft): @(M_PI),
        @(GHArcChartStartingDirectionUp): @(M_PI * 3 /2),
        @(GHArcChartStartingDirectionRight): @0,
        @(GHArcChartStartingDirectionDown): @(M_PI/2)
    }[@(startDirection)] floatValue];
}

- (CAShapeLayer *)pointLayer {
    if (!_pointLayer) {
        _pointLayer = CAShapeLayer.layer;
        _pointLayer.fillColor = UIColor.blackColor.CGColor;
        [self.layer addSublayer:_pointLayer];
    }
    return _pointLayer;
}

- (GHChartsInfoView *)infoView {
    if (!_infoView) {
        _infoView = GHChartsInfoView.new;
        _infoView.hidden = YES;
        _infoView.alpha = 0;
    }
    return _infoView;
}

- (NSMutableArray *)pieLayerArray {
    if (!_pieLayerArray) {
        _pieLayerArray = [NSMutableArray arrayWithCapacity:self.minCount];
    }
    return _pieLayerArray;
}

- (NSMutableArray *)startEndAngleArray {
    if (!_startEndAngleArray) {
        _startEndAngleArray = [NSMutableArray arrayWithCapacity:self.minCount];
    }
    return _startEndAngleArray;
}

- (NSMutableArray *)angleArray {
    if (!_angleArray) {
        _angleArray = [NSMutableArray arrayWithCapacity:self.minCount];
    }
    return _angleArray;
}

- (NSMutableDictionary *)centerPointDict {
    if (!_centerPointDict) {
        _centerPointDict = [NSMutableDictionary dictionaryWithCapacity:self.minCount];
    }
    return _centerPointDict;
}
@end
