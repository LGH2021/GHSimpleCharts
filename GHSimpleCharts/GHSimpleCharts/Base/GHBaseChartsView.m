//
//  GHBaseChartsView.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/18.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "GHBaseChartsView.h"

@interface GHBaseChartsView ()
{
    NSUInteger _minCount;
    CGFloat _total;
    CGFloat _max;
    CGFloat _avgValue;
    CGFloat _yNum;
}
@end

@implementation GHBaseChartsView

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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self draws];
    });
    self.showValues = YES;
}

- (void)draws {}

- (void)setValues:(NSArray *)values {
    _values = values;
    _minCount = 0;
    _total = 0;
    _max = 0;
}

- (void)setLabels:(NSArray *)labels {
    _labels = labels;
    _minCount = 0;
    _total = 0;
    _max = 0;
}

- (NSUInteger)minCount {
    if (_minCount == 0) {
        _minCount = MIN(self.values.count, self.labels.count);
    }
    return _minCount;
}

- (CGFloat)maxValue {
    if (_max == 0) {
        [self setupMaxAndTotal];
    }
    return _max;
}

- (CGFloat)total {
    if (_total == 0) {
        [self setupMaxAndTotal];
    }
    return _total;
}

- (void)setupMaxAndTotal {
   for (int i = 0; i < self.minCount; i++) {
        CGFloat v = [self.values[i] floatValue];
        _total += v;
        if (v > _max) {
            _max = v;
        }
    }
}

- (CGFloat)perValue {
    if (_avgValue == 0) {
        CGFloat v = self.maxValue / 5;
        _yNum = 5;
        NSArray *arr = @[@0.2, @1, @2, @5, @10, @20, @50, @100, @200, @300, @500, @800, @1000, @2000, @3000, @5000, @8000, @10000, @11000, @12000, @15000, @20000];
            
        BOOL has = NO;
        for (int i = 0; i < arr.count; i++) {
            CGFloat vl = [arr[i] floatValue];
            if (v <= vl) {
                v = vl;
                has = YES;
                break;
            }
        }
        
        if (!has) {
            NSInteger cv = ceil(v);
            v = cv + 5000 - cv%5000;
        }
        
        if (v * 4 >= self.maxValue) {
            _yNum = 4;
        }
        
        _avgValue = v;
        _valueNum = _yNum;
    }
    return _avgValue;
}

- (void)reloadData {
    _avgValue = 0;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self draws];
}
@end
