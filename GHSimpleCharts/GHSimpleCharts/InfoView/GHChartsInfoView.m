//
//  GHChartsInfoView.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/18.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "GHChartsInfoView.h"
#import "NSString+GHSimpleCharts.h"

GHChartsInfoViewKey const GHChartsInfoViewTitle = @"GHChartsInfoViewTitle";
GHChartsInfoViewKey const GHChartsInfoViewTitleFont = @"GHChartsInfoViewTitleFont";
GHChartsInfoViewKey const GHChartsInfoViewTitleColor = @"GHChartsInfoViewTitleColor";
GHChartsInfoViewKey const GHChartsInfoViewDetail = @"GHChartsInfoViewContentName";
GHChartsInfoViewKey const GHChartsInfoViewDetailFont = @"GHChartsInfoViewContentFont";
GHChartsInfoViewKey const GHChartsInfoViewDetailColor = @"GHChartsInfoViewContentColor";
GHChartsInfoViewKey const GHChartsInfoViewMaxWidth = @"GHChartsInfoViewMaxWidth";
GHChartsInfoViewKey const GHChartsInfoViewContentInsets = @"GHChartsInfoViewMaxContentInsets";
GHChartsInfoViewKey const GHChartsInfoViewBackgroundColor = @"GHChartsInfoViewBackgroundColor";
GHChartsInfoViewKey const GHChartsInfoViewDotTypeName = @"GHChartsInfoViewDotTypeName";
GHChartsInfoViewKey const GHChartsInfoViewDotBackgroundColor = @"GHChartsInfoViewDotBackgroundColor";
@interface GHChartsInfoView ()
{
    NSMutableDictionary *_attrD;
    CGFloat _maxWidth;
}

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIView *dotView;
@end

@implementation GHChartsInfoView

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _attrD = @{
        GHChartsInfoViewTitle: @"",
        GHChartsInfoViewTitleFont: [UIFont systemFontOfSize:15],
        GHChartsInfoViewTitleColor: UIColor.darkGrayColor,
        GHChartsInfoViewDetail: @"",
        GHChartsInfoViewDetailFont: [UIFont systemFontOfSize:15],
        GHChartsInfoViewDetailColor: UIColor.darkGrayColor,
        GHChartsInfoViewContentInsets: [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)],
        GHChartsInfoViewBackgroundColor: [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8],
        GHChartsInfoViewDotTypeName: @(GHChartsInfoViewDotTypeRound)
    }.mutableCopy;
    
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
}

- (void)setAttrDict:(NSDictionary<GHChartsInfoViewKey,id> *)attrDict {
    _attrDict = attrDict;
    [_attrD addEntriesFromDictionary:attrDict];
    
    NSString *title = _attrD[GHChartsInfoViewTitle];
    UIFont *titleFont = _attrD[GHChartsInfoViewTitleFont];
    
    NSString *content = _attrD[GHChartsInfoViewDetail];
    UIFont *contentFont = _attrD[GHChartsInfoViewDetailFont];
    
    CGFloat width = [_attrD[GHChartsInfoViewMaxWidth] floatValue];
    
    self.titleLabel.text = title;
    self.titleLabel.font = titleFont;
    self.titleLabel.textColor = _attrD[GHChartsInfoViewTitleColor];
    
    self.contentLabel.text = content;
    self.contentLabel.font = contentFont;
    self.contentLabel.textColor = _attrD[GHChartsInfoViewDetailColor];
    
    UIEdgeInsets insets = [_attrD[GHChartsInfoViewContentInsets] UIEdgeInsetsValue];
    CGFloat insetH = insets.left + insets.right;
    
    CGFloat titleLabelMaxY = insets.top;
    
    if (title && ![title isEqualToString:@""]) {
        CGRect titleFrame = {CGPointMake(insets.top, insets.left), [title sizeWithFont:titleFont width:width - insetH]};
        self.titleLabel.frame = titleFrame;
        titleLabelMaxY = CGRectGetMaxY(titleFrame) + 10;
    } else {
        self.titleLabel.frame = CGRectZero;
    }
    
    CGFloat dotMaxX = insets.left;
    
    GHChartsInfoViewDotType type = (GHChartsInfoViewDotType)[_attrD[GHChartsInfoViewDotTypeName] integerValue];
    if (type == GHChartsInfoViewDotTypeNone) {
       self.dotView.frame = CGRectZero;
    } else {
        
        CGFloat dotWidth = self.contentLabel.font.pointSize * .8;
        CGFloat lineHeight = [@"我" sizeWithFont:self.contentLabel.font width:100].height; //i + (i - 1)/5 + 1;
        CGRect dotFrame = CGRectMake(insets.left, titleLabelMaxY + (lineHeight - dotWidth)/2, dotWidth, dotWidth);
        self.dotView.frame = dotFrame;
        dotMaxX = CGRectGetMaxX(dotFrame) + 7;
        
        switch (type) {
            case GHChartsInfoViewDotTypeNone:
                
                break;
                
            case GHChartsInfoViewDotTypeRound:
                self.dotView.layer.cornerRadius = dotWidth/2;
                break;
                
            case GHChartsInfoViewDotTypeSquare:
                self.dotView.layer.cornerRadius = 0;
                break;
                
            case GHChartsInfoViewDotTypeRoundSquare:
                self.dotView.layer.cornerRadius = 3;
                break;
                
            default:
                break;
        }
    }
    
    CGRect contentFrame = {CGPointMake(dotMaxX, titleLabelMaxY), [content sizeWithFont:contentFont width:width - dotMaxX - insets.right]};
    
    self.contentLabel.frame = contentFrame;
    
    CGRect selfFrame = self.frame;
    selfFrame.size = CGSizeMake(MAX(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMaxX(self.contentLabel.frame)) + insets.right, CGRectGetMaxY(contentFrame) + insets.bottom);
    self.frame = selfFrame;
    self.backgroundColor = _attrD[GHChartsInfoViewBackgroundColor];
    self.dotView.backgroundColor = _attrD[GHChartsInfoViewDotBackgroundColor];
    self.layer.borderColor = self.dotView.backgroundColor.CGColor;
}

#pragma mark - lazy
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [self defaultLabel];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [self defaultLabel];
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UIView *)dotView {
    if (!_dotView) {
        _dotView = UIView.alloc.init;
        [self addSubview:_dotView];
    }
    return _dotView;
}

- (UILabel *)defaultLabel {
    UILabel *label = UILabel.alloc.init;
    label.numberOfLines = 0;
    return label;
}
@end
