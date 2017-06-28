//
//  ViewController.m
//  GXSliderViewDemo
//
//  Created by cofco on 2017/6/27.
//  Copyright © 2017年 cofco. All rights reserved.
//

#import "ViewController.h"
#import "GXSliderBarView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GXSliderBarView * sliderView = [GXSliderBarView createBarWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
    sliderView.items = [NSArray arrayWithObjects:@"热门",@"我的",@"天下",@"商业",@"北京",@"推荐",@"最美中国",@"视频",@"Fashion", nil];
    sliderView.selectedItem = 3;
    [self.view addSubview:sliderView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
