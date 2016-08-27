//
//  BaseNavigationController.m
//  项目四
//
//  Created by CLAY on 16/5/26.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

+(void)initialize{
    //设置导航栏背景图片
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //设置按钮tintColor
    self.navigationBar.tintColor = [UIColor blackColor];
    //设置所有title的字体大小
    NSDictionary *attr = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:19]};
    self.navigationBar.titleTextAttributes = attr;

}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    //设置返回按钮
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [viewController.navigationItem.backBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];

    if (self.viewControllers.count > 0) {
        //隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }

    //push会伴随vC的viewDidLoad调用 (控制器的view懒加载),保证返回按钮的可修改性
    [super pushViewController:viewController animated:animated];
}


@end
