//
//  JJSegmentTitle.m
//  封装一些小控件
//
//  Created by 16 on 2018/3/17.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "JJSegmentTitle.h"

@implementation JJSegmentTitle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:20];
        self.userInteractionEnabled = YES;
        self.scale = 0.0;
        self.maxScale = 1.0;
    }
    return self;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale; // [0.0 - 1.0]
    
    /*
     *  颜色渐变,在这里修改label展示颜色，默认是红色
     */
//    self.textColor = [UIColor colorWithRed:scale green:scale blue:scale alpha:1.0];
    
    // 大小渐变
    CGFloat minWHScale = 1.0;
    CGFloat whScale = minWHScale + scale * (_maxScale - minWHScale);
    self.transform = CGAffineTransformMakeScale(whScale, whScale);
}
@end
