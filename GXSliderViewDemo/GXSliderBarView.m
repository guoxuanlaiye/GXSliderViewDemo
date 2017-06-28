//
//  GXSliderBarView.m
//  GXSliderViewDemo
//
//  Created by cofco on 2017/6/27.
//  Copyright © 2017年 cofco. All rights reserved.
//



#import "GXSliderBarView.h"
#import "UIView+SliderBarFrame.h"

@implementation GXSliderBarConfig
+ (instancetype)createConfig {
    return [[self alloc]init];
}
- (CGFloat)indicatorViewHeight {
    return 2.0f;
}
- (UIFont *)itemTitleFont {
    return [UIFont systemFontOfSize:17.0];
}
- (UIColor *)itemNormalColor {
    return [UIColor blackColor];
}
- (UIColor *)itemSelectColor {
    return [UIColor redColor];
}
@end

@interface GXSliderBarView ()
{
    UIButton * _lastButton;  // 记录上一下点击的button
}
@property (nonatomic, strong) UIScrollView * contentScrollView;         // button容器视图
@property (nonatomic, strong) NSMutableArray <UIButton *> * itemsBtns;  // 存在创建的button
@property (nonatomic, strong) GXSliderBarConfig * config;               // 每个按钮的配置描述
@property (nonatomic, strong) UIView * indicatorView;                   // 按钮下面的横线
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation GXSliderBarView
+ (instancetype)createBarWithFrame:(CGRect)frame {
    GXSliderBarView * barView = [[GXSliderBarView alloc]initWithFrame:frame];
    return barView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
    }
    return self;
}
#pragma mark - Lazy 
- (GXSliderBarConfig *)config {
    if (!_config) {
        _config = [GXSliderBarConfig createConfig];
    }
    return _config;
}
- (NSMutableArray<UIButton *> *)itemsBtns {
    if (!_itemsBtns) {
        _itemsBtns = [NSMutableArray array];
    }
    return _itemsBtns;
}
- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-self.config.indicatorViewHeight, 0, self.config.indicatorViewHeight)];
        _indicatorView.backgroundColor = [UIColor redColor];
        [self.contentScrollView addSubview:_indicatorView];
    }
    return _indicatorView;
}
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc]init];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_contentScrollView];
    }
    return _contentScrollView;
}
#pragma mark - 设置选中的按钮
- (void)setSelectedItem:(NSInteger)selectedItem {
    if (self.itemsBtns.count == 0 || selectedItem < 0 || selectedItem > self.itemsBtns.count) {
        return;
    }
    _selectedItem = selectedItem;
    UIButton * btn = self.itemsBtns[_selectedItem-1];
    [self itemClick:btn];
    
}
- (void)setItems:(NSArray<NSString *> *)items {
    _items = items;
    
    [self.itemsBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemsBtns = nil;
    
    for (NSString * name in items) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = self.itemsBtns.count;
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setTitleColor:self.config.itemNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.config.itemSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font = self.config.itemTitleFont;
        [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
        [self.contentScrollView addSubview:btn];
        [self.itemsBtns addObject:btn];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
// 点击选项按钮
- (void)itemClick:(UIButton *)button {
    
    _selectedIndex = button.tag;
    _lastButton.selected = NO;
    button.selected = YES;
    _lastButton = button;
    
    // 切换按钮下面的横线
    [UIView animateWithDuration:0.3 animations:^{
        self.indicatorView.width   = button.width;
        self.indicatorView.centerX = button.centerX;
    }];
    CGFloat offsetX = button.centerX - self.contentScrollView.width * 0.5;
    // 设置左边界
    if (offsetX < 0) {
        offsetX = 0;
    }
    // 设置右边界
    if (offsetX > self.contentScrollView.contentSize.width - self.contentScrollView.width) {
        offsetX = self.contentScrollView.contentSize.width - self.contentScrollView.width;
    }
    [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentScrollView.frame = self.bounds;
    
    CGFloat totalWidths = 0.0;
    for (UIButton * btn in self.itemsBtns) {
        [btn sizeToFit];
        totalWidths += btn.width;
    }
    
    CGFloat itemMargin = (self.width - totalWidths)/(self.itemsBtns.count + 1);
    if (itemMargin < 20) {  // 选项多时是负值，直接给固定的间隔
        itemMargin = 20;
    }
    
    CGFloat lastX = itemMargin;
    for (UIButton * btn in self.itemsBtns) {
        [btn sizeToFit];
        btn.y = 0.0;
        btn.x = lastX;
        lastX += btn.width + itemMargin;
        
    }
    self.contentScrollView.contentSize = CGSizeMake(lastX, 0);
    
    if (self.itemsBtns.count == 0) {
        return;
    }
    UIButton * tmpButton = self.itemsBtns[_selectedIndex];
    self.indicatorView.width   = tmpButton.width;
    self.indicatorView.height  = self.config.indicatorViewHeight;
    self.indicatorView.centerX = tmpButton.centerX;
    self.indicatorView.y       = self.height - self.indicatorView.height;
    
}
@end
