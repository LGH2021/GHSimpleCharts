//
//  GHRadarChartView.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/26.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "GHRadarChartView.h"
#import "GHCTool.h"
#import "UIColor+GHSimpleCharts.h"
@interface GHRadarChartView ()
{
    CGFloat _startAngle;
    CGFloat _perAngle;
    CGPoint _center;
    CGFloat _bgSpacing;
    NSMutableArray *_angleArr;
    NSMutableDictionary *_valueRaduisDict;
}

@property (strong, nonatomic) UIColor *nameLabelColor;
@property (strong, nonatomic) UIFont *nameLabelFont;
@end

@implementation GHRadarChartView
- (void)initialize {
    [super initialize];
    self.spacingColor1 = UIColor.whiteColor;
    self.spacingColor2 = UIColorRGB(246, 248, 252);
    self.spacingLineColor = UIColor.lightGrayColor;
    self.angleLineColor = UIColor.lightGrayColor;
    self.valueLineColor = UIColorRGB(84, 112, 198);
    _angleArr = [NSMutableArray arrayWithCapacity:self.minCount];
    _valueRaduisDict = [NSMutableDictionary dictionaryWithCapacity:self.minCount];
    self.valueLabelColor = UIColor.darkGrayColor;
    self.valueLabelFont = [UIFont systemFontOfSize:11];
    self.nameLabelColor = UIColor.darkGrayColor;
    self.nameLabelFont = [UIFont systemFontOfSize:10];
}

- (void)draws {
    [_angleArr removeAllObjects];
    CGPoint center = GHRectGetCenter(self.bounds);
    center.x += self.offset.x;
    center.y += self.offset.y;
    _center = center;
    
    _perAngle = M_PI * 2 / self.minCount;

    NSMutableArray *bgPathArray = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *slPathArray = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *valueLabelArray = [NSMutableArray arrayWithCapacity:self.minCount];
    NSMutableArray *nameLabelArray = [NSMutableArray arrayWithCapacity:self.minCount];
    NSInteger count = MAX(5, self.minCount);
    for (int i = 0; i < count; i++) {
        if (i < 5) {
            [bgPathArray addObject:UIBezierPath.bezierPath];
            [slPathArray addObject:UIBezierPath.bezierPath];
        }
        if (i < self.minCount) {
            if (self.showValues) {
                [valueLabelArray addObject:[self labelWithTextColor:self.valueLabelColor font:self.valueLabelFont]];
            }
            
            [nameLabelArray addObject:[self labelWithTextColor:self.nameLabelColor font:self.nameLabelFont]];
        }
    }
 
    UIBezierPath *alPath = UIBezierPath.bezierPath;
    UIBezierPath *vlPath = UIBezierPath.bezierPath;
    
    if (self.raduis == 0) {
        CGFloat raduis = MIN(self.bounds.size.height, self.bounds.size.width)/2;
        self.raduis = raduis;
    }
    CGFloat max = self.max;
    if (max == 0) {
        max = self.perValue * self.valueNum;
    } else if (max > self.maxValue) {
        max = self.maxValue;
    }
    
    _bgSpacing = sin((M_PI - _perAngle)/2) * self.raduis * .2;
    
    for (int i = 0; i < self.minCount; i++) {
        CGFloat len = [self.values[i] floatValue] * self.raduis / max;
        if (len + 1 >= self.raduis) {
            len = self.raduis - 1;
        }
        [_valueRaduisDict setObject:@(len) forKey:@(i)];
        for (int k = 0; k < 5; k++) {
            CGFloat temp1 = 2 * k + 1;
            UIBezierPath *bgPath = bgPathArray[k];
            [self setupPath:bgPath atIndex:i withRaduis:self.raduis * temp1 / 10];
            
            CGFloat temp2 = 2 * (k + 1);
            UIBezierPath *slPath = slPathArray[k];
            [self setupPath:slPath atIndex:i withRaduis:self.raduis * temp2 / 10];
        }
        [self setupAngleLinePath:alPath atIndex:i withRaduis:self.raduis];
        [self setupPath:vlPath atIndex:i withRaduis:len withLenDict:YES];
        if (self.showValues) {
            [self setupValueLabel:valueLabelArray[i] atIndex:i raduis:len];
        }
        [self setupNameLabel:nameLabelArray[i] atIndex:i raduis:self.raduis];
    }
    
    [self addBGLayerWithArray:bgPathArray];
    [self addSpacingLineLayerWithArray:slPathArray];
    [self addLineLayerWithPath:alPath strokeColor:self.angleLineColor];
    [self addValueLayerWithPath:vlPath];
    [self addLabelWithArray:nameLabelArray];
    if (self.showValues) {
        [self addLabelWithArray:valueLabelArray];
    }
    
}

- (void)addBGLayerWithArray:(NSArray *)array {
    for (int i = 0; i < 5; i++) {
        UIColor *color = self.spacingColor1;
        if (i % 2 == 1) {
            color = self.spacingColor2;
        }
        
        UIBezierPath *bgPath = array[i];
        [self addBGLayerWithPath:bgPath strokeColor:color];
    }
}

- (void)addSpacingLineLayerWithArray:(NSArray *)array {
    for (int i = 0; i < 5; i++) {
        UIBezierPath *slPath = array[i];
        [self addLineLayerWithPath:slPath strokeColor:self.spacingLineColor];
    }
}

- (void)setupAngleLinePath:(UIBezierPath *)path atIndex:(NSUInteger)i withRaduis:(CGFloat)raduis {
    CGFloat angle = [self angleAtIndex:i];
    CGPoint point = [self pointWithLength:raduis angle:angle center:_center];
    [path moveToPoint:_center];
    [path addLineToPoint:point];
}

- (void)setupPath:(UIBezierPath *)bezierPath atIndex:(NSUInteger)i withRaduis:(CGFloat)raduis {
    [self setupPath:bezierPath atIndex:i withRaduis:raduis withLenDict:NO];
}

- (void)setupPath:(UIBezierPath *)bezierPath atIndex:(NSUInteger)i withRaduis:(CGFloat)raduis withLenDict:(BOOL)withLenDict {
    CGFloat angle = [self angleAtIndex:i];
    CGPoint point = [self pointWithLength:raduis angle:angle center:_center];
    
    if (i == 0) {
        [bezierPath moveToPoint:point];
        return;
    }
      
    [bezierPath addLineToPoint:point];
    
    if (i == self.minCount - 1) {
        CGFloat r1 = raduis;
        CGFloat r2 = raduis;
        if (withLenDict) {
            r1 = [[_valueRaduisDict objectForKey:@(0)] floatValue];
            r2 = [[_valueRaduisDict objectForKey:@(1)] floatValue];
        }
        [bezierPath addLineToPoint:[self pointWithLength:r1 angle:[self angleAtIndex:0] center:_center]];
        [self setupPath:bezierPath atIndex:1 withRaduis:r2];
    }
}

- (void)addBGLayerWithPath:(UIBezierPath *)path strokeColor:(UIColor *)color {
    [self addLayerWithPath:path strokeColor:color lineWidth:_bgSpacing];
}

- (void)addLineLayerWithPath:(UIBezierPath *)path strokeColor:(UIColor *)color {
    [self addLayerWithPath:path strokeColor:color lineWidth:1];
}

- (void)addLayerWithPath:(UIBezierPath *)path strokeColor:(UIColor *)color lineWidth:(CGFloat)lineWidth {
    [self addLayerWithPath:path strokeColor:color lineWidth:lineWidth fillColor:nil];
}

- (void)addLayerWithPath:(UIBezierPath *)path strokeColor:(UIColor *)color lineWidth:(CGFloat)lineWidth fillColor:(UIColor *)fillColor {
    CAShapeLayer *layer = [GHCTool layerWithPath:path];
    layer.lineWidth = lineWidth;
    layer.strokeColor = color.CGColor;
    if (fillColor) {
        layer.fillColor = fillColor.CGColor;
    }
    [self.layer addSublayer:layer];
    if (lineWidth == 2 && self.animateDuration > 0) {
        
        CAAnimation *an1 = [GHCTool animationWithKeyPath:@"transform.scale" from:@0 to:@1 duration:self.animateDuration];
        CAAnimation *an2 = [GHCTool animationWithKeyPath:@"position" from:[NSValue valueWithCGPoint:_center] to:[NSValue valueWithCGPoint:CGPointZero] duration:self.animateDuration];
        
        CAAnimationGroup *group = CAAnimationGroup.new;
        group.animations = @[an1, an2];
        group.duration = self.animateDuration;
        group.repeatCount = 1;
        group.fillMode = kCAFillModeForwards;
        group.removedOnCompletion = NO;

        [layer addAnimation:group forKey:@""];
    }
}

- (void)addValueLayerWithPath:(UIBezierPath *)path {
    [self addLayerWithPath:path strokeColor:self.valueLineColor lineWidth:2 fillColor:self.valueFillColor];
}

- (CGPoint)pointWithLength:(CGFloat)length angle:(CGFloat)angle center:(CGPoint)center {
    return [GHCTool pointWithLength:length angle:angle center:center clockwise:self.clockwise direction:GHArcChartStartingDirectionUp];
}

- (void)setupValueLabel:(UILabel *)label atIndex:(NSUInteger)i raduis:(CGFloat)raduis {
    [self setupLabel:label atIndex:i raduis:raduis text:[NSString stringWithFormat:@"%@", self.values[i]]];
}

- (void)setupNameLabel:(UILabel *)label atIndex:(NSUInteger)i raduis:(CGFloat)raduis {
    [self setupLabel:label atIndex:i raduis:raduis text:self.labels[i]];
}

- (void)setupLabel:(UILabel *)label atIndex:(NSUInteger)i raduis:(CGFloat)raduis text:(NSString *)text {
    CGFloat angle = [self angleAtIndex:i];
    CGPoint point = [self pointWithLength:raduis angle:angle center:_center];
    label.text = text;
    CGRect rect = {{0, 0}, {self.bounds.size.width, label.font.pointSize + 2}};
    label.frame = rect;
    CGFloat spacing = 5;
    BOOL isEQX = NO;
    if (i == 0 || i == self.minCount/2.0) {
        isEQX = YES;
    }
    if (isEQX) {
        label.textAlignment = NSTextAlignmentCenter;
        if (point.y < _center.y) {
            label.center = CGPointMake(point.x, point.y - rect.size.height/2 - spacing);
        } else {
            label.center = CGPointMake(point.x, point.y + rect.size.height/2 + spacing);
        }
    } else {
        CGPoint center = CGPointZero;
        center.y = point.y;
        
        CGFloat width = 0;
        
        if (point.x < _center.x) {
            width = point.x - spacing;
            center.x = point.x - width/2 - spacing;
            label.textAlignment = NSTextAlignmentRight;
        } else {
            label.textAlignment = NSTextAlignmentLeft;
            width = self.bounds.size.width - point.x - spacing;
            center.x = point.x + spacing + width / 2;
        }
        rect.size.width = width;
        label.frame = rect;
        label.center = center;
    }
}

- (void)addLabelWithArray:(NSArray *)array {
    for (UIView *v in array) {
        [self addSubview:v];
    }
}

- (UILabel *)labelWithTextColor:(UIColor *)textColor font:(UIFont *)font {
    UILabel *label = UILabel.new;
    label.font = font;
    label.textColor = textColor;
    return label;
}

- (CGFloat)angleAtIndex:(NSUInteger)i {
    if (i >= _angleArr.count) {
        [_angleArr addObject:@(_perAngle * i * (1 - self.clockwise * 2))];
    }
    return [_angleArr[i] floatValue];
}

- (NSUInteger)valueNum {
    return 5;
}
@end
