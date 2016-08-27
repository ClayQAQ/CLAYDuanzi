//
//  CLAYTabBar.m
//  项目四
//
//  Created by CLAY on 16/5/26.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYTabBar.h"
#import "CLAYPublishViewController.h"

@interface CLAYTabBar ()

@property (nonatomic, weak) UIButton *publishButton;

@end

@implementation CLAYTabBar

// init 和 initWithFrame 都会调用
-(instancetype)init{
    if ([super init]) {
        //设置tabbar的背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        //设置发布按钮
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        publishButton.size = publishButton.currentBackgroundImage.size;
        [publishButton addTarget:self action:@selector(publishVC) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishButton];
        self.publishButton = publishButton;
    }
    return self;
}

// 弹出个人发布界面
- (void)publishVC{
    UIViewController *vc = [[CLAYPublishViewController alloc] init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
}

//布局button
-(void)layoutSubviews{
    //让父类布局完
    [super layoutSubviews];
    CLAYLog(@"%@",NSStringFromCGPoint(self.center));
    self.publishButton.center = CGPointMake(kScreenWidth*0.5, self.height*0.5);
    NSInteger i = 0;
    CGFloat width = kScreenWidth/5;
    for (UIView *btn in self.subviews) {
        if ([btn isMemberOfClass:NSClassFromString(@"UITabBarButton")]) {
            CGFloat x = width*(i>1?(i+1):i);
            btn.frame = CGRectMake(x, 0, width, self.height);
            i++;
        }
    }



}

@end
