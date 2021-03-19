//
//  GHChartsInfoView.h
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/18.
//  Copyright © 2021 LGH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString * GHChartsInfoViewKey NS_EXTENSIBLE_STRING_ENUM;
UIKIT_EXTERN GHChartsInfoViewKey const _Nonnull GHChartsInfoViewTitle;
UIKIT_EXTERN GHChartsInfoViewKey const _Nonnull GHChartsInfoViewTitleFont;
UIKIT_EXTERN GHChartsInfoViewKey const _Nonnull GHChartsInfoViewTitleColor;
UIKIT_EXTERN GHChartsInfoViewKey const _Nonnull GHChartsInfoViewDetail;
UIKIT_EXTERN GHChartsInfoViewKey const _Nonnull GHChartsInfoViewDetailFont;
UIKIT_EXTERN GHChartsInfoViewKey const _Nonnull GHChartsInfoViewDetailColor;
UIKIT_EXTERN GHChartsInfoViewKey const _Nonnull GHChartsInfoViewMaxWidth;
UIKIT_EXTERN GHChartsInfoViewKey const _Nonnull GHChartsInfoViewContentInsets;
UIKIT_EXTERN GHChartsInfoViewKey const _Nonnull GHChartsInfoViewBackgroundColor;
UIKIT_EXTERN GHChartsInfoViewKey const _Nonnull GHChartsInfoViewDotBackgroundColor;
UIKIT_EXTERN GHChartsInfoViewKey const _Nonnull GHChartsInfoViewDotTypeName;// 和枚举名冲突，故后面加了name

typedef NS_ENUM(NSInteger, GHChartsInfoViewDotType) {
    GHChartsInfoViewDotTypeNone = 0,
    GHChartsInfoViewDotTypeRound,
    GHChartsInfoViewDotTypeSquare,
    GHChartsInfoViewDotTypeRoundSquare
};

NS_ASSUME_NONNULL_BEGIN

@interface GHChartsInfoView : UIView
@property (copy, nonatomic) NSDictionary <GHChartsInfoViewKey, id> *attrDict;
@end

NS_ASSUME_NONNULL_END
