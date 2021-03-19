//
//  GHAxisChartViewProtocol.h
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/25.
//  Copyright © 2021 LGH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GHAxisChartViewProtocol <NSObject>
@optional
- (CGFloat)yAxisBeginValue;
- (void)drawAtIndex:(NSUInteger)index point:(CGPoint)point chartHeight:(CGFloat)ch;
- (void)chartViewWillDrawValues;
@end

NS_ASSUME_NONNULL_END
