//
//  FriendTrendsViewController.m
//  项目四
//
//  Created by CLAY on 16/5/26.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "FriendTrendsViewController.h"
#import "FriendRecommendViewController.h"
#import "LoginAndRegisterController.h"

@interface FriendTrendsViewController ()

@end

@implementation FriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CLAYLogFunc;
    //设置标题
    self.navigationItem.title = @"我的关注";
    //设置UIBarButtonItem
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" hightlightedImage:@"friendsRecommentIcon-click" target:self action:@selector(leftAction)];
}


#pragma mark - 按钮方法
- (void)leftAction{
    CLAYLogFunc;
    FriendRecommendViewController *vc = [[FriendRecommendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}

//登录注册按钮
- (IBAction)loginOrRegister {
    LoginAndRegisterController *vc = [[LoginAndRegisterController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
