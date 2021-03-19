//
//  NSString+GHSimpleCharts.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/18.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "NSString+GHSimpleCharts.h"




@implementation NSString (GHSimpleCharts)

- (CGSize)sizeWithFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                  options:NSStringDrawingUsesLineFragmentOrigin |
                NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading
                
                               attributes:@{NSFontAttributeName : font}
                
                                  context:nil].size;
    
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

@end
