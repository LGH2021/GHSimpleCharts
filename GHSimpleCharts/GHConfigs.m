//
//  GHConfigs.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/3/4.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "GHConfigs.h"

@implementation GHConfigs
+ (CGFloat)frameStartTop {
    UIEdgeInsets safeInsets = UIEdgeInsetsMake(20, 0, 0, 0);
    if (@available(iOS 11.0, *)) {
        safeInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
    }
    return safeInsets.top;
}

+ (NSDictionary *)chartViewDatas {
    int count = arc4random()%5 + 6;
    NSMutableArray *nameArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        [nameArray addObject:[NSString stringWithFormat:@"第%d个", i + 1]];
        [valueArray addObject:@(arc4random()%10000)];
    }
    return @{@"labels": nameArray, @"values": valueArray};
}

+ (CGRect)chartViewFrame {
    CGFloat y = [self frameStartTop] + 10 + 44;
    CGFloat x = 10;
    CGFloat width = UIScreen.mainScreen.bounds.size.width - x * 2;
    CGFloat height = ceil(width * .75);
    return (CGRect){{x, y}, {width, height}};
}
@end
