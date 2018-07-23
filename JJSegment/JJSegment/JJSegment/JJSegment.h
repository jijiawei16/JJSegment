//
//  JJSegment.h
//  JJSegment
//
//  Created by 16 on 2018/7/23.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JJSegmentDelegate <NSObject>

/**
 *  index : 点击了哪一个标题
 */
- (void)JJSegmentDidScrollIndex:(NSInteger)index;
@end

@interface JJSegment : UIView

///代理
@property (nonatomic , weak) id<JJSegmentDelegate>delegate;
///选中标题放大的倍数,默认是1
@property (nonatomic , assign) CGFloat blowUpNum;
///标题字体大小
@property (nonatomic , assign) CGFloat titleFont;
///标题默认颜色
@property (nonatomic , strong) UIColor *nomalColor;
///标题选中颜色
@property (nonatomic , strong) UIColor *selectColor;
///底部分割线是否显示
@property (nonatomic , assign) BOOL isShowBottom;
///底部分割线的颜色
@property (nonatomic , strong) UIColor *bottomColor;
///底部分割线是否和文字等宽
@property (nonatomic , assign) BOOL aequilate;


/*
 * titles : 传标题数组（NSString类型）
 * showTabs : 传展示视图控件数组（UIView类型）,如果传nil则表示不添加展示视图
 * maxCount : 一行展示最多个数
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles showTabs:(NSArray<UIView*> *)showTabs maxCount:(CGFloat)maxCount;
@end

