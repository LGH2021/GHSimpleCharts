//
//  GHAxisChartView.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/20.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "GHAxisChartView.h"
#import "NSString+GHSimpleCharts.h"
#import "GHAxisChartViewProtocol.h"
#import "GHCTool.h"
@interface GHAxisChartView () <UIScrollViewDelegate, GHAxisChartViewProtocol>
{
    CGRect _chartRect;
    BOOL _lineChartStartAtYAxis;
    CGFloat _realBarWidth;
    CGFloat _chartContentHeight;
    CGFloat _yAxisBeginValue;
}
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation GHAxisChartView
static NSUInteger kY_AxisLabelTag = 10;
- (void)initialize {
    [super initialize];
    self.xAxisColor = UIColor.darkGrayColor;
    self.yAxisColor = UIColor.darkGrayColor;
    self.minXAxisSpacing = 10;
    self.yDegreeOrientation = GHAxisDegreeOrientationRight;
    self.xDegreeOrientation = GHAxisDegreeOrientationUp;
    _chartRect.origin = CGPointZero;
    _chartRect.size = self.bounds.size;
    if ([self isBar]) {
        _realBarWidth = 10;
    }
}

- (void)draws {
    
    [self addSubview:self.scrollView];
    [self.scrollView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    

    [self drawAxis];
}

#pragma mark - private
- (void)drawAxis {
    CGFloat fontSize = 10;
    CGFloat labelHeight = 0;
    UIFont *axisFont = [UIFont systemFontOfSize:fontSize];
    
    CGFloat v = self.perValue * self.valueNum;
    NSString *vStr = [NSString stringWithFormat:@"%.f", v];
    if (v > (NSInteger)v) {
        vStr = [NSString stringWithFormat:@"%.1f", v];
    }
    CGFloat degreeWidth = [vStr sizeWithFont:axisFont width:200].width;
    CGFloat nameWidth = [self.yAxisName sizeWithFont:axisFont width:200].width;
    CGFloat yAxisLabelMaxWidth = MAX(degreeWidth, nameWidth);
    
    CGFloat yAxisStartX = yAxisLabelMaxWidth + 5;
    if (self.yDegreeOrientation == GHAxisDegreeOrientationLeft) {
        yAxisStartX += 5;
    }
    
    CGSize xAxisNameSize = CGSizeZero;
    if (self.xAxisName) {
        xAxisNameSize = [self.xAxisName sizeWithFont:axisFont width:100];
        xAxisNameSize.width += 3;
    }
    
    CGFloat yLen = [self getYAxisExcessLengthAndSetupYAxisNameWithWidth:yAxisLabelMaxWidth font:axisFont];
    
    CGFloat yn = 0, yl = 0;
    if (yLen == -1) {
        yn = 1;
    } else {
        yl = yLen;
    }
    
    CGFloat xLen = self.xAxisExcessLength;
    if (self.xAxisName.length > 0 && xLen == 0) {
        xLen = -1;
    }
    
    CGFloat cw = self.bounds.size.width - yAxisStartX - xAxisNameSize.width;
    CGFloat temp = 0;
    if (_lineChartStartAtYAxis) {
        temp = -0.5;
    }
    
    CGFloat xl = 0;
    if (xLen > -1) {
        xl = xLen;
    }

    CGFloat w = (cw - xl)/(self.labels.count + temp);
    CGFloat pw = MAX(w, self.minXAxisSpacing);
    if ([self isBar]) {
        pw = MAX(w, self.minXAxisSpacing + _realBarWidth);
    }
    NSMutableArray *sizeArray = [NSMutableArray arrayWithCapacity:self.labels.count];
    for (int i = 0; i < self.labels.count; i++) {
        CGSize size = [self.labels[i] sizeWithFont:axisFont width:pw];
        [sizeArray addObject:[NSValue valueWithCGSize:size]];
        if (size.height > labelHeight) {
            labelHeight = size.height;
        }
    }
    
    CGFloat ch = self.bounds.size.height - labelHeight - 5;
    if (self.xDegreeOrientation == GHAxisDegreeOrientationDown) {
        ch -= 5;
    }
    CGFloat topSpace = 0;
    if (!self.yAxisName && self.yAxisExcessLength == 0) {
        topSpace = 20;
    }
    CGFloat ph = (ch - yl - topSpace)/(self.valueNum + yn);
    if (yLen == -1) {
        yl = ph;
    }
    if ([self isBar]) {
        UIImage *image = [self valueForKeyPath:@"barTintImage"];
        if (image) {
            CGFloat h1 = self.valueNum * ph;
            CGFloat w1 = pw - self.minXAxisSpacing;
            CGFloat h2 = image.size.height;
            CGFloat w2 = image.size.width;
            CGFloat sc1 = h1 / w1;
            CGFloat sc2 = h2 / w2;
            if (sc1 > sc2) {
                ph = h2 * w1 / (w2 * self.valueNum);
            }
        }
    }
    
    _yAxisBeginValue = ch - ph * self.valueNum;
    _chartContentHeight = ch;
    CGFloat yAxisStartY = _yAxisBeginValue - yl;
    UIView *yAxisLabel = [self viewWithTag:kY_AxisLabelTag];
    CGRect yalFrame = yAxisLabel.frame;
    yalFrame.origin.y = yAxisStartY;
    yAxisLabel.frame = yalFrame;
    
    _chartRect.origin.x = yAxisStartX;
    _chartRect.size.width = cw;
    self.scrollView.frame = _chartRect;
    
    [self setupXAxisNameWithChartHeight:ch font:axisFont size:xAxisNameSize];
    
    NSInteger count = MAX(self.valueNum + 1, self.minCount);
    
    BOOL hasXArrow = NO;
    UIBezierPath *yAxisPath = UIBezierPath.bezierPath;
    if (yl > 0) {
        [yAxisPath moveToPoint:CGPointMake(yAxisStartX - 4, yAxisStartY + 5)];
        [yAxisPath addLineToPoint:CGPointMake(yAxisStartX, yAxisStartY)];
        [yAxisPath addLineToPoint:CGPointMake(yAxisStartX + 4, yAxisStartY + 5)];
    }
    
    [yAxisPath moveToPoint:CGPointMake(yAxisStartX, yAxisStartY)];
    [yAxisPath addLineToPoint:CGPointMake(yAxisStartX, ch)];
    
    UIBezierPath *xAxisPath = UIBezierPath.bezierPath;
    [xAxisPath moveToPoint:CGPointMake(yAxisStartX, ch)];
    [xAxisPath addLineToPoint:CGPointMake(CGRectGetMaxX(_chartRect), ch)];
    
    if (xl > 0 || self.xAxisName.length > 0 || _lineChartStartAtYAxis) {
        [xAxisPath moveToPoint:CGPointMake(CGRectGetMaxX(_chartRect) - 5, ch + 4)];
        [xAxisPath addLineToPoint:CGPointMake(CGRectGetMaxX(_chartRect), ch)];
        [xAxisPath addLineToPoint:CGPointMake(CGRectGetMaxX(_chartRect) - 5, ch - 4)];
        hasXArrow = YES;
    }
    
    UIBezierPath *xDegreePath = UIBezierPath.bezierPath;
    CGFloat ly = 0;
    for (int i = 0; i < count; i++) {
        if (i < self.values.count) {
            [self drawValuesAtIndex:i xSpacing:pw ySpacing:ph];
        }
        
        if (i <= self.valueNum) {
            
            
            CGFloat vl = self.perValue * i;
            NSString *format = @"%.f";
            if (vl < 1 && vl > 0) {
                format = @"%.1f";
            }
            ly = ch - i * ph ;
            
            if (i > 0 && (self.yDegreeOrientation == GHAxisDegreeOrientationLeft || self.yDegreeOrientation == GHAxisDegreeOrientationRight)) {
                
                CGFloat degreeWidth = 5;
                if (self.yDegreeOrientation == GHAxisDegreeOrientationLeft) {
                    degreeWidth = -5;
                }
                
                [yAxisPath moveToPoint:CGPointMake(yAxisStartX, ly)];
                [yAxisPath addLineToPoint:CGPointMake(yAxisStartX + degreeWidth, ly)];
            }
                
            UILabel *yLabel = [self degreeLabelWithText:[NSString stringWithFormat:format, vl] font:axisFont];
            yLabel.textColor = self.yAxisLabelColor;
            [self addSubview:yLabel];
                
            CGRect rect = {{0, 0}, {yAxisLabelMaxWidth, labelHeight}};
            rect.origin.y = ly - labelHeight/2;
            yLabel.frame = rect;
        }
        if (i < self.labels.count) {
            UILabel *xLabel = [self degreeLabelWithText:self.labels[i] font:axisFont];
            xLabel.textColor = self.xAxisLabelColor;
            xLabel.textAlignment = NSTextAlignmentCenter;
            xLabel.numberOfLines = 0;
            CGFloat xly = ch + 5;
            if (self.xDegreeOrientation == GHAxisDegreeOrientationDown) {
                xly += 5;
            }
            CGRect lr = {{i * pw, xly}, {pw, [sizeArray[i] CGSizeValue].height}};
            xLabel.frame = lr;
            
            if (_lineChartStartAtYAxis) {
                CGPoint center = xLabel.center;
                center.x -= pw/2;
                xLabel.center = center;
            }
            if (self.xDegreeOrientation == GHAxisDegreeOrientationUp || self.xDegreeOrientation == GHAxisDegreeOrientationDown) {
                if ((_lineChartStartAtYAxis && i > 0) || (!_lineChartStartAtYAxis && !(hasXArrow && self.xAxisExcessLength == 0 && i == self.labels.count - 1))) {
                    
                    CGFloat degreeWidth = 5;
                    if (self.xDegreeOrientation == GHAxisDegreeOrientationUp) {
                        degreeWidth = -5;
                    }
                    CGFloat x = CGRectGetMaxX(lr);
                    if (_lineChartStartAtYAxis) {
                        x = CGRectGetMinX(lr);
                    } else if (i == self.labels.count - 1) {
                        x -= .5;
                    }
                    
                    [xDegreePath moveToPoint:CGPointMake(x, ch)];
                    [xDegreePath addLineToPoint:CGPointMake(x, ch + degreeWidth)];
                }
            }
            
            if (i == self.labels.count - 1) {
                CGFloat scw = CGRectGetMaxX(lr);
                if (_lineChartStartAtYAxis) {
                    scw += (xl - pw/2);
                } else {
                    scw += xl;
                }
                self.scrollView.contentSize = CGSizeMake(scw, self.bounds.size.height);
                self.scrollView.scrollEnabled = self.scrollView.contentSize.width > self.scrollView.bounds.size.width;
            }
            [self.scrollView addSubview:xLabel];
        }
    }
    

    if (_lineChartStartAtYAxis && ![self isBar]) {
         self.scrollView.clipsToBounds = NO;
         self.clipsToBounds = !self.scrollView.clipsToBounds;
    }
    
    CAShapeLayer *yAxisLayer = [GHCTool layerWithPath:yAxisPath];
    yAxisLayer.strokeColor = self.yAxisColor.CGColor;
    [self.layer addSublayer:yAxisLayer];
    
    CAShapeLayer *xDegreeLayer = [GHCTool layerWithPath:xDegreePath];
    xDegreeLayer.strokeColor = self.xAxisColor.CGColor;
    [self.scrollView.layer addSublayer:xDegreeLayer];
    
    CAShapeLayer *xAxisLayer = [GHCTool layerWithPath:xAxisPath];
    xAxisLayer.strokeColor = self.xAxisColor.CGColor;
    [self.layer addSublayer:xAxisLayer];
    
    if ([self respondsToSelector:@selector(chartViewWillDrawValues)]) {
        [self chartViewWillDrawValues];
    }
   
}

- (void)drawValuesAtIndex:(NSUInteger)index xSpacing:(CGFloat)xSpacing ySpacing:(CGFloat)ySpacing {
   
    NSNumber *v = self.values[index];
    CGFloat fv = [v floatValue];
    CGFloat h = fv * ySpacing / self.perValue;
    CGFloat temp = 0.5;
    if (_lineChartStartAtYAxis) {
        temp = 0;
    }
    CGPoint point = CGPointMake((index + temp) * xSpacing, _chartContentHeight - h);
    
    if ([self respondsToSelector:@selector(drawAtIndex:point:chartHeight:)]) {
        [self drawAtIndex:index point:point chartHeight:_chartContentHeight];
    }
    
    if (self.showValues) {
        [self addLabelWithValue:v point:point atIndex:index];
    }
}

- (void)addLabelWithValue:(NSNumber *)value point:(CGPoint)point atIndex:(NSInteger)index {
    UILabel *label = UILabel.new;
    label.text = [NSString stringWithFormat:@"%@", value];
    label.font = [UIFont systemFontOfSize:11];
    label.textColor = self.valueColor;
    CGRect rect = {{0, 0}, [label.text sizeWithFont:label.font width:300]};
    label.frame = rect;
    
    CGFloat cy = point.y;
    if ([self isBar]) {
        cy -= rect.size.height/2;
    } else {
        int symbol = [[self valueForKeyPath:@"valuePosition"] intValue];
        if (symbol == 0) {
            CGFloat lv = index > 0? [self.values[index - 1] floatValue]: 0;
            CGFloat cv = value.floatValue;
            CGFloat nv = index < self.minCount - 1? [self.values[index + 1] floatValue]: 0;
            if (index == 0) {
                if (nv > cv) {
                    symbol = 1;
                } else {
                    symbol = -1;
                }
            } else if (index == self.minCount - 1) {
                if (lv > cv) {
                    symbol = 1;
                } else {
                    symbol = -1;
                }
            } else {
                if (lv > cv && nv > cv) {
                    symbol = 1;
                } else {
                    symbol = -1;
                }
            }
        }
        cy += symbol * rect.size.height/2;
        if (self.pointRadius > 0) {
            cy += symbol * self.pointRadius/2;
        }
    }
    
    
    label.center = CGPointMake(point.x, cy);
    
    [self.scrollView addSubview:label];
}

- (UILabel *)degreeLabelWithText:(NSString *)text font:(UIFont *)font {
    UILabel *label = UILabel.new;
    label.font = font;
    label.text = text;
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

- (void)setupXAxisNameWithChartHeight:(CGFloat)ch font:(UIFont *)font size:(CGSize)size {
    if (self.xAxisName.length == 0) {
        return;
    }
    UIView *view = UIView.new;
    view.backgroundColor = self.backgroundColor;
    CGRect vr = self.bounds;
    vr.origin.x = CGRectGetMaxX(_chartRect);
    vr.size.width = self.bounds.size.width - vr.origin.x;
    view.frame = vr;
    [self addSubview:view];
    
    UILabel *xNameLabel = [self degreeLabelWithText:self.xAxisName font:font];
    xNameLabel.textColor = self.xAxisLabelColor;
    [self addSubview:xNameLabel];
    CGRect r = {{CGRectGetMaxX(_chartRect), ch - size.height/2}, size};
    xNameLabel.frame = r;
}

- (CGFloat)getYAxisExcessLengthAndSetupYAxisNameWithWidth:(CGFloat)width font:(UIFont *)font {
    if (self.yAxisName.length > 0) {
        UILabel *yNameLabel = [self degreeLabelWithText:self.yAxisName font:font];
        yNameLabel.textColor = self.yAxisLabelColor;
        [self addSubview:yNameLabel];
        CGFloat lh = font.pointSize + 2;
        yNameLabel.frame = CGRectMake(0, 0, width, lh);
        yNameLabel.tag = kY_AxisLabelTag;
        if (self.yAxisExcessLength == 0) {
            return -1;
        }
        if (lh * 1.5 > self.yAxisExcessLength) {
            return lh * 1.5;
        }
    }
    return self.yAxisExcessLength;
}

- (BOOL)isBar {
    return [self isKindOfClass:NSClassFromString(@"GHBarChartView")];
}

- (BOOL)isLine {
    return [self isKindOfClass:NSClassFromString(@"GHLineChartView")];
}

- (void)reloadData {
    self.scrollView.contentOffset = CGPointZero;
    [super reloadData];
}

#pragma mark - setter
- (void)setStartAtYAxis:(BOOL)startAtYAxis {
    _startAtYAxis = startAtYAxis;
    if ([self isLine]) {
        _lineChartStartAtYAxis = startAtYAxis;
    }
}

- (void)setBarWidth:(CGFloat)barWidth {
    _barWidth = barWidth;
    if ([self isBar]) {
        _realBarWidth = barWidth;
    }
}

#pragma mark - GHAxisChartViewProtocol
- (CGFloat)yAxisBeginValue {
    return _yAxisBeginValue;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self isBar]) {
        return;
    }
    scrollView.clipsToBounds = scrollView.contentOffset.x > 0;
    self.clipsToBounds = !scrollView.clipsToBounds;
}

#pragma mark - lazy

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = UIScrollView.new;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
//        _scrollView.backgroundColor = UIColor.yellowColor;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
@end
