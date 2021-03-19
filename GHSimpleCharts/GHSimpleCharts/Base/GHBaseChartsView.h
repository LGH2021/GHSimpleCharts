//
//  GHBaseChartsView.h
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/18.
//  Copyright © 2021 LGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHChartsInfoView.h"


NS_ASSUME_NONNULL_BEGIN

@interface GHBaseChartsView : UIView

@property (copy, nonatomic) NSArray *labels;
@property (copy, nonatomic) NSArray *values;

@property (assign, nonatomic, readonly) CGFloat total;
@property (assign, nonatomic, readonly) NSUInteger minCount;
@property (assign, nonatomic, readonly) CGFloat maxValue;
@property (assign, nonatomic, readonly) CGFloat perValue;
@property (assign, nonatomic, readonly) NSUInteger valueNum;

/// 是否显示值，默认YES
@property (assign, nonatomic) BOOL showValues;


@property (nullable, copy, nonatomic) NSString *title;

/// 动画时长
@property (assign, nonatomic) NSTimeInterval animateDuration;
- (void)draws;
- (void)initialize NS_REQUIRES_SUPER;
- (void)reloadData NS_REQUIRES_SUPER;
@end



NS_ASSUME_NONNULL_END


