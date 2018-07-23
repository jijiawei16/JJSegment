//
//  JJSegment.m
//  JJSegment
//
//  Created by 16 on 2018/7/23.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "JJSegment.h"
#import "JJSegmentTitle.h"

#define sw self.frame.size.width
#define sh self.frame.size.height
#define weak(obj)   __weak typeof(obj) weakSelf = obj
#define strong(obj) __strong typeof(weakSelf) obj = weakSelf
@interface JJSegment ()<UIScrollViewDelegate>

// 存放标题
@property (nonatomic , strong) UIScrollView *titleScr;
// 存放展示视图
@property (nonatomic , strong) UIScrollView *showScr;
// 存放标题数组
@property (nonatomic , strong) NSMutableArray <JJSegmentTitle*>*titlesAry;
// 当前选中的标题
@property (nonatomic , strong) JJSegmentTitle *current;
// 下一个标题
@property (nonatomic , strong) JJSegmentTitle *next;
// 当前标题底部分割线
@property (nonatomic , strong) UIView *bottom;
// 当前标题底部分割线frame
@property (nonatomic , assign) CGRect bottomFrame;
// 标题数组
@property (nonatomic , strong) NSArray *titleAry;
@end
@implementation JJSegment
{
    CGFloat title_w;
    CGFloat title_h;
}
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles showTabs:(NSArray<UIView*> *)showTabs maxCount:(CGFloat)maxCount
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self jj_creatTitles:titles showTabs:showTabs maxCount:maxCount];
    }
    return self;
}
// 添加视图
- (void)jj_creatTitles:(NSArray *)titles showTabs:(NSArray *)showtabs maxCount:(CGFloat)maxCount
{
    // 初始化数据
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = title_w = self.frame.size.width/maxCount;
    CGFloat h = title_h = 50;
    
    self.titleAry = titles;
    self.isShowBottom = YES;
    self.blowUpNum = 1.0;
    self.titleScr.frame = CGRectMake(0, 0, sw, title_h);
    self.showScr.frame = CGRectMake(0, title_h, sw, sh-title_h);
    [self addSubview:self.titleScr];
    if (showtabs.count != 0) {
        [self addSubview:self.showScr];// 如果没传展示视图则不添加该视图
        for (NSInteger i = 0; i<showtabs.count; i++) {
            [_showScr addSubview:showtabs[i]];
        }
        _showScr.contentSize = CGSizeMake(sw*showtabs.count, 0);
    }
    
    // 添加标题
    for (NSInteger i = 0; i < titles.count; i++) {
        
        x = w*i;
        JJSegmentTitle *title = ({
            JJSegmentTitle *label = [[JJSegmentTitle alloc] initWithFrame:CGRectMake(x, y, w, h)];
            label.text = [NSString stringWithFormat:@"%@",titles[i]];
            UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jj_titleClick:)];
            click.numberOfTapsRequired = 1;
            [label addGestureRecognizer:click];
            label.maxScale = _blowUpNum;
            label.tag = i+16;
            label;
        });
        
        if (i == 0) {
            
            _current = title;
            _current.textColor = _selectColor?_selectColor:[UIColor redColor];
            [_titleScr addSubview:self.bottom];
            CGSize size = [self jj_sizeWithText:title.text andMaxSize:CGSizeMake(title_w, title_h) andFont:[UIFont systemFontOfSize:20]];
            _bottom.frame = CGRectMake((title_w-size.width)/2, title_h-2, size.width, 2);
            _bottom.frame = CGRectMake(i*(sw/titles.count), title_h-2, sw/titles.count, 2);// 不等于文字长度
            _bottomFrame = _bottom.frame;
        };
        [_titleScr addSubview:title];
        [self.titlesAry addObject:title];
        _titleScr.contentSize = CGSizeMake(title.frame.origin.x+title.frame.size.width, 0);
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, sw, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    
    // 添加展示视图
    weak(self);
    [showtabs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        strong(self);
        UIView *view = obj;
        [self.showScr addSubview:view];
        self.showScr.contentSize = CGSizeMake(view.frame.origin.x+view.frame.size.width, 0);
    }];
}

#pragma mark 标题按钮点击方法
- (void)jj_titleClick:(UITapGestureRecognizer *)sender
{
    JJSegmentTitle *title = (JJSegmentTitle *)sender.view;
    if ([title.text isEqualToString:_current.text]) return;
    _next.scale = 0.0;
    _current.scale = 0.0;
    _current.textColor = _nomalColor?_nomalColor:[UIColor blackColor];
    _current = title;
    _current.textColor = _selectColor?_selectColor:[UIColor redColor];
    
    // 动画效果
    [UIView animateWithDuration:0.2 animations:^{
        
        self->_current.scale = 1.0;
        [self reloadBottom];
        self->_showScr.contentOffset = CGPointMake((self.current.tag-16)*sw, 0);
    }];
    // 代理方法
    if ([self.delegate respondsToSelector:@selector(JJSegmentDidScrollIndex:)]) {
        [self.delegate JJSegmentDidScrollIndex:_current.tag-16];
    }
}

#pragma mark scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat scr_x = scrollView.contentOffset.x;
    int num = scr_x/sw;
    if (scr_x == 0) {
        num = 0;
    }
    _current.textColor = _nomalColor?_nomalColor:[UIColor blackColor];
    _current =  _titlesAry[num];
    _current.textColor = _selectColor?_selectColor:[UIColor redColor];
    
    // 动画效果
    [UIView animateWithDuration:0.1 animations:^{
        
        if (self->_current.frame.origin.x+self->_current.frame.size.width-sw > self->_titleScr.contentOffset.x) {
            self->_titleScr.contentOffset = CGPointMake(self->_current.frame.origin.x+self->_current.frame.size.width-sw, 0);
        }else if (self->_current.frame.origin.x < self->_titleScr.contentOffset.x){
            self->_titleScr.contentOffset = CGPointMake(self->_current.frame.origin.x, 0);
        }
        [self reloadBottom];
        self->_bottomFrame = self->_bottom.frame;
    }];
    // 代理方法
    if ([self.delegate respondsToSelector:@selector(JJSegmentDidScrollIndex:)]) {
        [self.delegate JJSegmentDidScrollIndex:_current.tag-16];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width-sw) return;
    if (scrollView.contentOffset.x < (_current.tag-16)*sw) {
        
        CGFloat change = (_current.tag-16)*sw-scrollView.contentOffset.x;
        _next = _titlesAry[_current.tag-17];
        _next.scale = change/sw;
        _current.scale = 1- (change/sw);
        CGRect frame = _bottomFrame;
        frame.origin.x = _bottomFrame.origin.x-(title_w/2)*(change/sw);
        frame.size.width = _bottomFrame.size.width+(title_w/2)*(change/sw);
    }else if(scrollView.contentOffset.x > (_current.tag-16)*sw){
        CGFloat change = scrollView.contentOffset.x-(_current.tag-16)*sw;
        _next = _titlesAry[_current.tag-15];
        _next.scale = change/sw;
        _current.scale = 1- (change/sw);
        CGRect frame = _bottomFrame;
        frame.size.width = _bottomFrame.size.width+(title_w/2)*(change/sw);
    }else {
        _next.scale = 0.0;
        _current.scale = 1.0;
    }
}
#pragma mark 懒加载
- (UIScrollView *)titleScr
{
    if (_titleScr == nil) {
        _titleScr = [[UIScrollView alloc] init];
        _titleScr.showsVerticalScrollIndicator = NO;
        _titleScr.showsHorizontalScrollIndicator = NO;
    }
    return _titleScr;
}
- (UIScrollView *)showScr
{
    if (_showScr == nil) {
        _showScr = [[UIScrollView alloc] init];
        _showScr.delegate = self;
        _showScr.showsHorizontalScrollIndicator = NO;
        _showScr.showsVerticalScrollIndicator = NO;
        _showScr.pagingEnabled = YES;
    }
    return _showScr;
}
- (UIView *)bottom
{
    if (_bottom == nil) {
        _bottom = [[UIView alloc] init];
        _bottom.backgroundColor = [UIColor redColor];
    }
    return _bottom;
}
- (NSMutableArray<JJSegmentTitle *> *)titlesAry
{
    if (_titlesAry == nil) {
        _titlesAry = [NSMutableArray array];
    }
    return _titlesAry;
}
#pragma mark 设置其他属性
- (void)setBlowUpNum:(CGFloat)blowUpNum
{
    _blowUpNum = blowUpNum;
    _current.maxScale = _blowUpNum;
    _current.scale = 1.0;
    weak(self);
    [_titlesAry enumerateObjectsUsingBlock:^(JJSegmentTitle * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        strong(self);
        obj.maxScale = self.blowUpNum;
    }];
}
- (void)setIsShowBottom:(BOOL)isShowBottom
{
    if (!isShowBottom) [_bottom removeFromSuperview];
}
- (void)setBottomColor:(UIColor *)bottomColor
{
    _bottom.backgroundColor = bottomColor;
}
- (void)setAequilate:(BOOL)aequilate
{
    _aequilate = aequilate;
    [self reloadBottom];
}
- (void)setTitleFont:(CGFloat)titleFont
{
    _titleFont = titleFont;
    [self.titlesAry enumerateObjectsUsingBlock:^(JJSegmentTitle * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.font = [UIFont systemFontOfSize:titleFont];
    }];
}
- (void)setNomalColor:(UIColor *)nomalColor
{
    _nomalColor = nomalColor;
    [self.titlesAry enumerateObjectsUsingBlock:^(JJSegmentTitle * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.textColor = nomalColor;
    }];
}
- (void)setSelectColor:(UIColor *)selectColor
{
    _selectColor = selectColor;
    self.current.textColor = selectColor;
}
#pragma mark 刷新底部分割线尺寸
- (void)reloadBottom
{
    if (self.aequilate) {
        CGFloat width = [self jj_sizeWithText:self.current.text andMaxSize:CGSizeMake(self->title_w, self->title_h) andFont:[UIFont systemFontOfSize:_titleFont?_titleFont:16]].width*(_blowUpNum?_blowUpNum:1.0);
        self.bottom.frame = CGRectMake((self.current.tag-16)*self->title_w+(self->title_w-width)/2, self->title_h-2, width, 2);
    }else {
        self->_bottom.frame = CGRectMake((self.current.tag-16)*(sw/self.titleAry.count), self->title_h-2, sw/self.titleAry.count, 2);
    }
    self->_bottomFrame = self->_bottom.frame;
}
#pragma mark 计算文字宽度
-(CGSize)jj_sizeWithText:(NSString *)text andMaxSize:(CGSize)maxSize andFont:(UIFont *)font
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}
@end

