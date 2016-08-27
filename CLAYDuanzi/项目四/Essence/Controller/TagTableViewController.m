//
//  TagTableViewController.m
//  项目四
//
//  Created by CLAY on 16/5/30.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "TagTableViewController.h"
#import "TagCell.h"
#import "TagModel.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>

@interface TagTableViewController ()

/** tagModel数组 */
@property (nonatomic, strong) NSMutableArray *tags;

@end


//reuseIdentifier
static NSString * const CLAYTagID = @"tag";

@implementation TagTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.title = @"推荐标签";
    //配置表视图
    [self configTableView];
    //填充model
    [self loadData];

}

#pragma mark - 配置表视图
- (void)configTableView{
    //即底层颜色
    self.tableView.backgroundColor = CLAYRGBColor(223, 223, 223);
    //单元格高度
    self.tableView.rowHeight = 70;
    //取消表视图分隔线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TagCell class]) bundle:nil] forCellReuseIdentifier:CLAYTagID];

}


#pragma mark - 网络加载与数据处理
- (void)loadData{
    //数据加载前的进度与mask
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    //AFN网络请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //创建_tags数组
        _tags = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            TagModel *tag = [[TagModel alloc] init];
            [tag setValuesForKeysWithDictionary:dic];
            [_tags addObject:tag];
        }
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _tags.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TagCell *cell = [tableView dequeueReusableCellWithIdentifier:CLAYTagID forIndexPath:indexPath];
    cell.tagModel = _tags[indexPath.row];
    return cell;
}

#pragma mark - <UITableViewDelegate>

@end
