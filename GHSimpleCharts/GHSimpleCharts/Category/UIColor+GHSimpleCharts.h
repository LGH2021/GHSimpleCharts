//
//  UIColor+GHSimpleCharts.h
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/18.
//  Copyright © 2021 LGH. All rights reserved.
//



#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

CG_EXTERN UIColor * UIColorRGB(int r, int g, int b);
CG_EXTERN UIColor * UIColorRGBA(int r, int g, int b, float a);

@interface UIColor (GHSimpleCharts)
+ (UIColor *)randomColor;

@end

NS_ASSUME_NONNULL_END
