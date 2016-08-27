//
//  NewViewController.m
//  项目四
//
//  Created by CLAY on 16/5/26.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "NewViewController.h"

@interface NewViewController ()

@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CLAYLogFunc;
    //设置导航栏标题图
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    //设置UIBarButtonItem  直接继承父类的.
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" hightlightedImage:@"MainTagSubIconClick" target:self action:@selector(leftAction)];


}


#pragma mark - 按钮方法
//- (void)leftAction{    //直接继承父类的.
//    CLAYLogFunc;
//}



@end
