//
//  UIColor+GHSimpleCharts.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/18.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "UIColor+GHSimpleCharts.h"


@implementation UIColor (GHSimpleCharts)

UIColor * UIColorRGB(int r, int g, int b) {
    return UIColorRGBA(r, g, b, 1);
}

UIColor * UIColorRGBA(int r, int g, int b, float a) {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

+ (UIColor *)randomColor {
    return UIColorRGB(arc4random()%256, arc4random()%256, arc4random()%256);
}
@end
