//
//  MainTabBarController.m
//  项目四
//
//  Created by CLAY on 16/5/26.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "MainTabBarController.h"
#import "EssenceViewController.h"
#import "NewViewController.h"
#import "FriendTrendsViewController.h"
#import "MeViewController.h"
#import "BaseNavigationController.h"
#import "CLAYTabBar.h"


@interface MainTabBarController ()

@end

@implementation MainTabBarController

//复写一次性方法
+(void)initialize{

    NSDictionary *normalDic = @{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]};
    NSDictionary *selectedDic = @{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]};
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:normalDic forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedDic forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置子控制器及对应tabBar按钮
    [self basicConfig];
    //设置自定义tabBar
    [self setValue:[[CLAYTabBar alloc]init] forKey:@"tabBar"];
}



//设置子控制器及对应tabBar按钮
- (void)basicConfig{
    [self installChildVC:[[EssenceViewController alloc] init] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    [self installChildVC:[[NewViewController alloc] init] title:@"最新" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    [self installChildVC:[[FriendTrendsViewController alloc] init] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    [self installChildVC:[[MeViewController alloc] initWithStyle:UITableViewStyleGrouped] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
}

//设置子控制器方法
- (void)installChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{

    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:image] selectedImage:[UIImage imageNamed:selectedImage]];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];

}






@end
