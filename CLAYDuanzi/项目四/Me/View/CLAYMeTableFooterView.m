//
//  CLAYMeTableFooterView.m
//  项目四
//
//  Created by CLAY on 16/8/26.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYMeTableFooterView.h"
#import "CLAYSquare.h"
#import "CLAYSquareButton.h"
#import "CLAYWebViewController.h"
#import <MJExtension.h>
#import <AFNetworking.h>


@implementation CLAYMeTableFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        // 参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";

        // 发送请求
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            NSArray *squares= [CLAYSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            [self createSquares:squares];

            //在此处重新添加一次tableFooterView, 解决了拖动到最底部cell会自动回弹的问题 (原本使用网络数据前的tableFooterView)
            UITableView *tableView = (UITableView *)self.superview;
            tableView.tableFooterView = self;

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        }];


    }
    return self;
}

/**
 *  创建九宫格方块
 */
- (void)createSquares:(NSArray *)sqaures{
    // 一行最多4列
    int maxCols = 4;

    // 宽度和高度
    CGFloat buttonW = kScreenWidth / maxCols;
    CGFloat buttonH = buttonW;

    for (int i = 0; i<sqaures.count; i++) {
        // 创建按钮
        CLAYSquareButton *button = [CLAYSquareButton buttonWithType:UIButtonTypeCustom];
        // 监听点击
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        // 传递模型
        button.model = sqaures[i];
        [self addSubview:button];
        // 计算frame
        int col = i % maxCols;
        int row = i / maxCols;

        button.x = col * buttonW;
        button.y = row * buttonH;
        button.width = buttonW;
        button.height = buttonH;

        //        self.height = CGRectGetMaxY(button.frame);   //也可以设置
    }


    NSUInteger rows = (sqaures.count + maxCols - 1) / maxCols;

    // 计算footer的高度
    self.height = rows * buttonH;
    
    // 重绘
    [self setNeedsDisplay];

}

//点击方法
- (void)buttonClick:(CLAYSquareButton *)button
{
    if (![button.model.url hasPrefix:@"http"]) return;

    CLAYWebViewController *web = [[CLAYWebViewController alloc] init];
    web.url = button.model.url;
    web.title = button.model.name;

    // 取出当前的导航控制器
    UITabBarController *tabBarVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)tabBarVc.selectedViewController;
    [nav pushViewController:web animated:YES];
}


////设置背景图片
//- (void)drawRect:(CGRect)rect
//{
//    [[UIImage imageNamed:@"mainCellBackground"] drawInRect:rect];
//}


@end
