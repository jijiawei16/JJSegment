//
//  ViewController.m
//  JJSegment
//
//  Created by 16 on 2018/7/23.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "ViewController.h"
#import "JJSegment.h"

#define sw self.view.frame.size.width
@interface ViewController ()<JJSegmentDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titles = @[@"全部",@"推荐",@"图片",@"特色专题",@"论坛"];
    NSMutableArray *tabs = [NSMutableArray array];
    for (NSInteger i = 0; i<titles.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(sw*i, 0, sw, 300)];
        view.backgroundColor = [UIColor colorWithRed:i*0.2 green:i*0.2 blue:i*0.2 alpha:1];
        [tabs addObject:view];
    }
    JJSegment *segment = [[JJSegment alloc] initWithFrame:CGRectMake(0, 50, sw, 350) titles:titles showTabs:tabs maxCount:5];
    segment.delegate = self;
    segment.aequilate = YES;
    segment.blowUpNum = 1.1;
    segment.titleFont = 16;
    [self.view addSubview:segment];
}
- (void)JJSegmentDidScrollIndex:(NSInteger)index
{
    NSLog(@"点击了第%ld个",(long)index);
}


@end
