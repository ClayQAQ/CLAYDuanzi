//
//  CLAYCommentViewController.m
//  项目四
//
//  Created by CLAY on 16/8/22.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYCommentViewController.h"
#import "CLAYDuanzi.h"
#import "CLAYDuanZiCell.h"
#import "CLAYCommentCell.h"
#import "CLAYComment.h"
#import "CLAYUser.h"
#import "CLAYSectionHeaderView.h"
#import <MJExtension.h>
#import <AFNetworking.h>
#import <MJRefresh.h>

@interface CLAYCommentViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *latestComments;

/** 保存帖子的top_cmt */
@property (nonatomic, strong) CLAYComment *saved_top_cmt;

/** 保存当前的页码 */
@property (nonatomic, assign) NSInteger page;

/** 管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end


static NSString * const CLAYCommentCellID = @"CLAYCommentCellID";

@implementation CLAYCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self basicConfig];
    [self setupTableHeaderView];
    [self setupRefresh];
}

/**
 *  basicConfig
 */
- (void)basicConfig{
    self.navigationItem.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" hightlightedImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // cell的高度设置
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 背景色
    self.tableView.backgroundColor = [UIColor clearColor];
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CLAYCommentCell class]) bundle:nil] forCellReuseIdentifier:CLAYCommentCellID];
    // 去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 内边距
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44 + 10, 0);

}


/**
 *  创建表视图的头视图
 */
- (void)setupTableHeaderView{
    // 创建header
    UIView *header = [[UIView alloc] init];
    // 添加cell
    CLAYDuanZiCell *cell = [CLAYDuanZiCell cell];
    cell.duanzi = self.model;
    cell.size = CGSizeMake(kScreenWidth, self.model.cellHeight);
    [header addSubview:cell];
    // header的高度
    header.height = self.model.cellHeight + 10;
    // 设置header
    self.tableView.tableHeaderView = header;

}

/**
 *  添加表视图的刷新控件
 */
- (void)setupRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    //一开始就加载(执行方法)
    [self.tableView.mj_header beginRefreshing];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    //一开始隐藏
    self.tableView.mj_footer.hidden = YES;
}

// AFN 唯一manager
- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}


//通知的方法
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 键盘显示\隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 修改底部约束
    self.bottomSpace.constant = kScreenHeight - frame.origin.y;
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}


/**
 *  下拉刷新(加载)评论
 */
- (void)loadNewComments{
    //取消以往的操作
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.model.ID;
    params[@"hot"] = @"1";
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //防崩溃处理
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [self.tableView.mj_header endRefreshing];
            return;
        }
        // 最热评论
        self.hotComments = [CLAYComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        // 最新评论
        self.latestComments = [CLAYComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        // 页码
        self.page = 1;
        // 刷新数据
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { // 全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}


/**
 *  上拉加载更多评论
 */
- (void)loadMoreComments{
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];

    // 页码
    NSInteger page = self.page + 1;
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.model.ID;
    params[@"page"] = @(page);
    CLAYComment *cmt = [self.latestComments lastObject];
    params[@"lastcid"] = cmt.ID;
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //防崩溃处理
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            self.tableView.mj_footer.hidden = YES;
            return;
        }
        // 最新评论
        NSArray *moreComments = [CLAYComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:moreComments];

        // 页码 (+1了,记录到全局)
        self.page = page;

        // 刷新数据
        [self.tableView reloadData];

        // 结束刷新状态
        [self.tableView.mj_footer endRefreshing];

        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { // 全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

//控制器销毁时
-(void)dealloc{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 销毁session和Block(tasks)
    [self.manager invalidateSessionCancelingTasks:YES];
}




/**
 * 返回第section组的所有评论数组
 */
- (NSArray *)commentsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.hotComments.count ? self.hotComments : self.latestComments;
    }
    return self.latestComments;
}

/**
 * 返回indexPath对应的model模型
 */
- (CLAYComment *)commentInIndexPath:(NSIndexPath *)indexPath
{
    return [self commentsInSection:indexPath.section][indexPath.row];
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;

    if (hotCount) return 2; // 有"最热评论" + "最新评论" 2组
    if (latestCount) return 1; // 有"最新评论" 1 组
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;

    // 隐藏尾部控件
    tableView.mj_footer.hidden = (latestCount == 0);

    if (section == 0) {
        return hotCount ? hotCount : latestCount;
    }

    // 非第0组
    return latestCount;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 先从缓存池中找header
    CLAYSectionHeaderView *header = [CLAYSectionHeaderView headerViewWithTableView:tableView];

    // 设置label的数据
    NSInteger hotCount = self.hotComments.count;
    if (section == 0) {
        header.title = hotCount ? @"最热评论" : @"最新评论";
    } else {
        header.title = @"最新评论";
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLAYCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CLAYCommentCellID];

    cell.model = [self commentInIndexPath:indexPath];

    return cell;
}


#pragma mark - <UITableViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 隐藏键盘
    [self.view endEditing:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    } else {
        // 被点击的cell
        CLAYCommentCell *cell = (CLAYCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
        // 出现一个第一响应者
        [cell becomeFirstResponder];

        // 显示MenuController
        UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
        UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
        menu.menuItems = @[ding, replay, report];
        CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width, cell.height * 0.5);
        [menu setTargetRect:rect inView:cell];
        [menu setMenuVisible:YES animated:YES];
    }
}

#pragma mark - MenuItem处理
- (void)ding:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    CLAYLog(@"%@",indexPath);
    CLAYLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}

- (void)replay:(UIMenuController *)menu
{
    CLAYLogFunc;
}

- (void)report:(UIMenuController *)menu
{
    CLAYLogFunc;
}


@end
