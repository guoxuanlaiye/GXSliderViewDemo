//
//  GXSliderBarView.h
//  GXSliderViewDemo
//
//  Created by cofco on 2017/6/27.
//  Copyright © 2017年 cofco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXSliderBarConfig : NSObject
+ (instancetype)createConfig;
@property (nonatomic, strong) UIColor * itemNormalColor;
@property (nonatomic, strong) UIColor * itemSelectColor;
@property (nonatomic, strong) UIFont  * itemTitleFont;
@property (nonatomic, assign) CGFloat indicatorViewHeight;

@end

@interface GXSliderBarView : UIView
+ (instancetype)createBarWithFrame:(CGRect)frame;

@property (nonatomic, copy) NSArray<NSString *> * items;
@property (nonatomic, assign) NSInteger selectedItem;

@end
