//
//  GHBarChartView.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/25.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "GHBarChartView.h"
#import "GHAxisChartViewProtocol.h"
#import "GHCTool.h"
@interface GHBarChartView () <GHAxisChartViewProtocol>
{
    UIImage *_tImage;
    UIImage *_bIamge;
}

@property (strong, nonatomic) UIBezierPath *barBGPath;
@property (strong, nonatomic) CAShapeLayer *barBGLayer;

@end

@implementation GHBarChartView
- (void)initialize {
    [super initialize];
    self.barTintColors = UIColor.cyanColor;
    self.barWidth = 10;
}

#pragma mark - override
- (void)drawAtIndex:(NSUInteger)index point:(CGPoint)point chartHeight:(CGFloat)ch {
    
    if (self.barTintImage) {
        CGRect rect = CGRectZero;
        CGFloat height = (int)(ch - [self yAxisBeginValue]);
        CGFloat width = (int)self.barTintImage.size.width * height / self.barTintImage.size.height;
        rect.size = CGSizeMake(width, height);
        
        UIImage *img = [self tintImageWithSize:rect.size];
        
        if (self.barBackgroundImage) {
            UIImage *img2 = [self backgroundImageWithSize:rect.size];
            UIImageView *bgImgView = [[UIImageView alloc] initWithImage:img2];
            bgImgView.frame = rect;
            bgImgView.center = CGPointMake(point.x, ch - height/2);
            [self.scrollView addSubview:bgImgView];
        }
        
        height = ch - point.y;
        rect.size.height = height;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
        imageView.contentMode = UIViewContentModeBottom;
        imageView.frame = rect;
        imageView.clipsToBounds = YES;
        [self.scrollView addSubview:imageView];
        imageView.center = CGPointMake(point.x, ch - height/2);
        
        if (self.animateDuration > 0) {
            CGRect r1 = imageView.frame;
            CGRect r0 = imageView.frame;
            r0.origin.y += r0.size.height;
            r0.size.height = 0;
            imageView.frame = r0;
            
            [UIView animateWithDuration:self.animateDuration animations:^{
                imageView.frame = r1;
            }];
        }
    } else {
        if (self.barBackgroundColor) {
            if (index == 0) {
                self.barBGLayer.lineWidth = self.barWidth;
                [self.scrollView.layer addSublayer:self.barBGLayer];
                self.barBGPath = UIBezierPath.bezierPath;
            }
            [self.barBGPath moveToPoint:CGPointMake(point.x, ch)];
            [self.barBGPath addLineToPoint:(CGPoint){point.x, [self yAxisBeginValue]}];
        }
        
        UIBezierPath *barPath = UIBezierPath.bezierPath;
        [barPath moveToPoint:CGPointMake(point.x, ch)];
        [barPath addLineToPoint:point];
           
        UIColor *color = nil;
        if ([self.barTintColors isKindOfClass:UIColor.class]) {
            color = self.barTintColors;
        } else if ([self.barTintColors isKindOfClass:NSArray.class]) {
            color = self.barTintColors[index%[self.barTintColors count]];
        }
        CAShapeLayer *layer = [GHCTool layerWithPath:barPath];
        layer.strokeColor = color.CGColor;
        layer.lineWidth = self.barWidth;
    
        if (self.animateDuration) {
            layer.strokeEnd = 0;
            [layer addAnimation:[GHCTool animationWithKeyPath:@"strokeEnd" from:@0 to:@1 duration:self.animateDuration] forKey:@""];
        }
        [self.scrollView.layer addSublayer:layer];
    }
}

- (void)reloadData {
    _tImage = nil;
    _bIamge = nil;
    [super reloadData];
}

- (void)chartViewWillDrawValues {
    if (self.barBackgroundColor) {
        self.barBGLayer.path = self.barBGPath.CGPath;
    }
}

#pragma mark - lazy
- (UIImage *)tintImageWithSize:(CGSize)size {
    if (!_tImage) {
        _tImage = [self image:self.barTintImage drawWithSize:size];
    }
    return _tImage;
}

- (UIImage *)backgroundImageWithSize:(CGSize)size {
    if (!_bIamge) {
        _bIamge = [self image:self.barBackgroundImage drawWithSize:size];
    }
    return _bIamge;
}

- (CAShapeLayer *)barBGLayer {
    if (!_barBGLayer) {
        _barBGLayer = CAShapeLayer.layer;
        _barBGLayer.fillColor = UIColor.clearColor.CGColor;
        _barBGLayer.strokeColor = self.barBackgroundColor.CGColor;
    }
    return _barBGLayer;
}

- (UIImage *)image:(UIImage *)image drawWithSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    [image drawInRect:(CGRect){CGPointZero, size}];
    UIImage *nImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return nImage;
}
@end
