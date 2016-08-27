//
//  RecommendViewController.m
//  项目四
//
//  Created by CLAY on 16/5/27.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "FriendRecommendViewController.h"
#import "RecommendTypeModel.h"
#import "RecommendUserModel.h"
#import "RecommendTypeCell.h"
#import "RecommendUserCell.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJRefresh.h>

#define CLAYSelectedType _types[_typeTableView.indexPathForSelectedRow.row]

@interface FriendRecommendViewController ()
/** 左侧栏类型表视图 */
@property (weak, nonatomic) IBOutlet UITableView *typeTableView;
/** 右侧栏用户表视图 */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
/** 保存typeModel的数组 */
@property (nonatomic, strong) NSMutableArray *types;
/** AFN的请求manager */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
/** 记录当前的params */
@property (nonatomic, strong) NSMutableDictionary *params;

@end


//reuseIndentifier
static NSString * const TypeCellID = @"type";
static NSString * const UserCellID = @"user";

/**
 *  model数据处理枚举
 */
typedef enum {
    CLAYModelHandleStyleType,
    CLAYModelHandleStyleUser
} CLAYModelHandleStyle;

@implementation FriendRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题
    self.navigationItem.title = @"推荐关注";
    //设置表视图
    [self configTableView];
    //给右侧_userTableView 添加刷新控件
    [self installRefresh];
    //开始的加载左栏所有类型数据
    [self loadTypeData];

}

#pragma mark - 设置表视图
- (void)configTableView{
    //注册单元格
    [_typeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RecommendTypeCell class]) bundle:nil] forCellReuseIdentifier:TypeCellID];
    [_userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RecommendUserCell class]) bundle:nil] forCellReuseIdentifier:UserCellID];
    //表视图颜色
    _typeTableView.backgroundColor = CLAYRGBColor(244, 244, 244);
    _userTableView.backgroundColor = [UIColor clearColor];
    //设置单元格高度
    _userTableView.rowHeight = 70;
    //手动设置表视图偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
    _typeTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _userTableView.contentInset = _typeTableView.contentInset;

}

#pragma mark - 网络请求方法简化
/**
 *  AFHTTPSessionManager 保证唯一
 */
- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        return [AFHTTPSessionManager manager];
    }else{
        return _manager;
    }
}

/**
 *  数据处理
 */
- (NSMutableArray *)arrayWithResponseObject:(id)responseObject modelHandleStyle:(CLAYModelHandleStyle)style {
    NSMutableArray *models = [NSMutableArray array];
    NSArray *listArray = responseObject[@"list"];
    if (style == CLAYModelHandleStyleType) {
        for (NSDictionary *dic in listArray) {
            //必须在循环中不断创建局部model对象, 因为数组记录的是地址.
            RecommendTypeModel *model = [[RecommendTypeModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [models addObject:model];
        }
        return models;
    }else if (style == CLAYModelHandleStyleUser){
        //处理totalCount
        [CLAYSelectedType setTotalCount:[responseObject[@"total"] integerValue]];
        CLAYLog(@"totalCount :  %li",[CLAYSelectedType totalCount]);
        CLAYLog(@"response: %@",responseObject);
        //填充RecommendUserModel
        for (NSDictionary *dic in listArray) {
            RecommendUserModel *model = [[RecommendUserModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [models addObject:model];
        }
        return models;
    }else return nil;
}


#pragma mark - 加载左栏type数据
/**
 *  加载左栏type表视图数据
 */
- (void)loadTypeData{
    //覆盖等待视图HUD
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    //加载数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"category" forKey:@"a"];
    [params setValue:@"subscribe" forKey:@"c"];
    NSURLSessionDataTask *task = [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        //加载提示,成功开始加载会开始调用此Block
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        //填充RecommendTypeModel
        _types = [self arrayWithResponseObject:responseObject modelHandleStyle:CLAYModelHandleStyleType];
        //刷新表视图
        [_typeTableView reloadData];
        //左栏表视图,开始选中第一个
        [_typeTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        //加载第一个type的user数据
        [_userTableView.mj_header beginRefreshing];
        //HUD消失
        [SVProgressHUD dismiss];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //HUD提醒用户
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
    [task resume];

}

#pragma mark - 给_userTableView添加"刷新控件"

- (void)installRefresh{
    _userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    _userTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
}


/**
 *  检测并设置footer状态
 */
- (void)checkFooterState{
    RecommendTypeModel *type = CLAYSelectedType;
    //设置底部的上拉刷新控件状态
    if (type.users.count == type.totalCount) {
        //加载完毕,取消上拉方法,提示noMoreData,并取消上拉. 避免不断调用-loadMoreUsers,不断请求服务器返回nil.
        [_userTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        //还能加载
        [_userTableView.mj_footer endRefreshing];
    }
}

/**
 *  首次下拉加载
 */
- (void)loadNewUsers{
    RecommendTypeModel *type = CLAYSelectedType;
    //只加载最新的一页的数据
    type.currentPage = 1;
    //配置网络请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(type.typerID);
    params[@"page"] = @(type.currentPage);
    //记录最后一个params
    self.params = params;
    
    [[self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //不是当前的(狂点的,最后一个type)则不刷新,只存储(不浪费请求)
        if (self.params != params) {
            //储存数据 (覆盖)
            type.users = [self arrayWithResponseObject:responseObject modelHandleStyle:CLAYModelHandleStyleUser];
            return ;
        }

        type.users = [self arrayWithResponseObject:responseObject modelHandleStyle:CLAYModelHandleStyleUser];
        //网络下载是异步, 必须在这个下载成功Block中即异步线程的末尾reloadData,在外面没用!
        [_userTableView reloadData];
        //结束下拉刷新,如果快速连选两个type,此处会导致后者header提前返回(因为共用)
        [_userTableView.mj_header endRefreshing];
        //设置底部的上拉刷新控件状态
        [self checkFooterState];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //这个Block不是当前的则不执行
        if (self.params != params) return;
        
        [SVProgressHUD showErrorWithStatus:@"用户加载失败"];
        [_userTableView.mj_footer endRefreshing];
        
    }] resume];

}

/**
 *  上拉加载更多
 */
- (void)loadMoreUsers{
    RecommendTypeModel *type = CLAYSelectedType;
    //配置网络请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(type.typerID);
    params[@"page"] = @(++type.currentPage);
    self.params = params;
    [[self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.params != params) {
            type.users = [self arrayWithResponseObject:responseObject modelHandleStyle:CLAYModelHandleStyleUser];
            return ;
        }
        //添加数据
        [type.users addObjectsFromArray:[self arrayWithResponseObject:responseObject modelHandleStyle:CLAYModelHandleStyleUser]];
         //刷新表视图
        [_userTableView reloadData];
        //加载更多后,调整尾视图footer的状态
        [self checkFooterState];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        [SVProgressHUD showErrorWithStatus:@"用户加载失败"];
        [_userTableView.mj_footer endRefreshing];
    }] resume];


}


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _typeTableView) return _types.count;

    NSInteger count = [CLAYSelectedType users].count;
    //_userTableView有数据,footer显示.
    _userTableView.mj_footer.hidden = (count == 0);
    //设置底部的上拉刷新控件状态
    [self checkFooterState];
    return count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _typeTableView) {
        RecommendTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:TypeCellID];
        cell.textLabel.text = [_types[indexPath.row] name];
        return cell;
    }else{
        RecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCellID];
        cell.user = [CLAYSelectedType users][indexPath.row];
        return cell;
    }
}


#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //立即结束上一次的刷新(如果有的话),否则会导致else的beginRefreshing无效.
    [_userTableView.mj_header endRefreshing];

    if ([_types[indexPath.row] users].count) {
        [_userTableView reloadData];
    }else {
        //避免_userTableView数据残留,先立即刷新即显示空白
        [_userTableView reloadData];
        //进入刷新状态并请求数据
        [_userTableView.mj_header beginRefreshing];
    }
}



#pragma mark - 控制器销毁处理
-(void)dealloc{
    CLAYLog(@"推荐关注被销毁");
    [self.manager.operationQueue cancelAllOperations];
}


@end
