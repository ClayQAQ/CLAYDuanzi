//
//  CLAYDuanZiTableViewController.m
//  项目四
//
//  Created by CLAY on 16/7/2.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYEssenceBaseTableViewController.h"
#import "CLAYDuanZiCell.h"
#import "CLAYDuanzi.h"
#import "CLAYCommentViewController.h"
#import "EssenceViewController.h"
#import <AFNetworking.h>
#import <MJRefresh.h>

@interface CLAYEssenceBaseTableViewController ()

/** 段子models */
@property (nonatomic, strong) NSMutableArray *duanzis;
/** 记录最后一次的参数 */
@property (nonatomic, strong) NSDictionary *params;
/** 当前页码 */
@property (nonatomic, assign) NSInteger page;
/** 加载下一页所需参数 */
@property (nonatomic, copy) NSString *maxtime;
/** 记录tabBarVC上次的selectedIndex */
@property (nonatomic, assign) NSInteger lastSelectedIndex;

@end

static NSString *const CLAYDuanZiID = @"DuanZi";

/**
 * model处理方式枚举
 */
typedef enum {
    CLAYHandleStyleLoadNew,
    CLAYHandleStyleLoadMore

} CLAYModelHandleStyle;

@implementation CLAYEssenceBaseTableViewController

- (NSMutableArray *)duanzis{
    if (!_duanzis) {
        _duanzis = [NSMutableArray array];
    }
    return _duanzis;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //配置表视图
    [self setupTableView];
    //配置刷新控件
    [self setupRefresh];
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarClick) name:CLAYDidClickTabBarNotification object:nil];
}



/**
 *  配置表视图
 */
- (void)setupTableView{

    self.tableView.backgroundColor = CLAYRGBColor(223, 223, 223);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CLAYDuanZiCell class]) bundle:nil] forCellReuseIdentifier:CLAYDuanZiID];

    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;

}

/**
 *  配置刷新控件
 */
- (void)setupRefresh{

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDuanZi)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDuanZi)];

    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    //进来就开始下拉刷新一次
    [self.tableView.mj_header beginRefreshing];

}

//通知方法
- (void)tabBarClick{

    if (self.lastSelectedIndex == self.tabBarController.selectedIndex && [self.view isShowingOnKeyWindow]) {
        [self.tableView.mj_header beginRefreshing];
    }
    self.lastSelectedIndex = self.tabBarController.selectedIndex;

}


#pragma mark - 分类处理,适应"精华"和"新帖"两个模块
- (NSString *)a{

    return [self.parentViewController isMemberOfClass:[EssenceViewController class]] ? @"list" : @"newlist";
}

#pragma mark - 数据处理

/**
 *  填充model 并储存到数组self.duanzis
 */
- (void)modelHandleWithResponseObject:(id)responseObject forHandleStyle:(CLAYModelHandleStyle)style{
    if (style == CLAYHandleStyleLoadMore) {
        NSArray *ar = responseObject[@"list"];
        for (NSDictionary *dic in ar) {
            CLAYDuanzi *model = [[CLAYDuanzi alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.duanzis addObject:model];
        }
    } else if (style == CLAYHandleStyleLoadNew){
        NSArray *ar = responseObject[@"list"];
        NSMutableArray *newAr = [NSMutableArray array];
        for (NSDictionary *dic in ar) {
            CLAYDuanzi *model = [[CLAYDuanzi alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [newAr addObject:model];
        }
        self.duanzis = newAr;
    }


}


/**
 * 加载新的帖子数据
 */
- (void)loadNewDuanZi{

    [self.tableView.mj_footer endRefreshing];

    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    self.params = params;

    //发送请求
    [[[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (self.params != params) return;

        //存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];

        //数据处理
        [self modelHandleWithResponseObject:responseObject forHandleStyle:CLAYHandleStyleLoadNew];

        //刷新表格
        [self.tableView reloadData];

        //结束刷新
        [self.tableView.mj_header endRefreshing];

        //清空页码
        self.page = 0;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (self.params != params) return;

        //结束刷新
        [self.tableView.mj_header endRefreshing];
    }] resume];

}

- (void)loadMoreDuanZi{
    // 结束下拉
    [self.tableView.mj_header endRefreshing];

    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    NSInteger page = self.page + 1;
    params[@"page"] = @(page);
    params[@"maxtime"] = self.maxtime;
    self.params = params;

    //发送请求
    [[[AFHTTPSessionManager manager]GET:@"http://api.budejie.com/api/api_open.php"  parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (self.params != params) return;

        //存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];

        //数据处理
        [self modelHandleWithResponseObject:responseObject forHandleStyle:CLAYHandleStyleLoadMore];

        //刷新表格
        [self.tableView reloadData];

        //结束刷新
        [self.tableView.mj_footer endRefreshing];

        //设置页码
        self.page = page;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (self.params != params) return;

        // 结束刷新
        [self.tableView.mj_footer endRefreshing];

    }] resume];

}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.duanzis.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CLAYDuanZiCell *cell = [tableView dequeueReusableCellWithIdentifier:CLAYDuanZiID];
    cell.duanzi = self.duanzis[indexPath.row];
    return cell;
}



#pragma mark - Table view delegate
//每个单元格的高度,每次显示一个单元格都要运行一次
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_duanzis[indexPath.row] cellHeight];
}


//点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CLAYCommentViewController *commentVC = [[CLAYCommentViewController alloc] init];
    commentVC.model = self.duanzis[indexPath.row];
    [self.navigationController pushViewController:commentVC animated:YES];
}



@end
