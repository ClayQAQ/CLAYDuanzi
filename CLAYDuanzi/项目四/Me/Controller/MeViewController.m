//
//  MeViewController.m
//  项目四
//
//  Created by CLAY on 16/5/26.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "MeViewController.h"
#import "CLAYMeCell.h"
#import "CLAYMeTableFooterView.h"
#import "CLAYSettingViewController.h"
#import "UIImage+CLAYCircleExtension.h"
#import "LoginAndRegisterController.h"

@interface MeViewController ()

@end


static NSString * const CLAYMeCellID = @"CLAYMeCellID";

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CLAYLogFunc;
    [self setupTableView];
    [self setupNav];
    self.view.backgroundColor = CLAYRGBColor(223, 223, 223);
}

/**
 *  配置导航栏
 */
- (void)setupNav{
    //设置标题
    self.navigationItem.title = @"我的";
    //设置UIBarButtonItem
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon"hightlightedImage:@"mine-setting-icon-click" target:self action:@selector(settingAction)];
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" hightlightedImage:@"mine-moon-icon-click" target:self action:@selector(moonAction)];
    self.navigationItem.rightBarButtonItems = @[settingItem,moonItem];
}


/**
 *  配置self.view (talbleView)
 */
- (void)setupTableView{
    // 设置背景色
    self.view.backgroundColor = CLAYRGBColor(223, 223, 223);

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CLAYMeCell class] forCellReuseIdentifier:CLAYMeCellID];

    // 调整section header/footer 高度
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;

    // 调整inset
    self.tableView.contentInset = UIEdgeInsetsMake(-15, 0, -10, 0);

    // 设置footerView (自定义控件内部,在数据下载完成后要重新设置一次)
    self.tableView.tableFooterView = [[CLAYMeTableFooterView alloc] init];
}

#pragma mark - 按钮方法
- (void)settingAction{
    CLAYSettingViewController *vc = [[CLAYSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.title = @"设置";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moonAction{
    CLAYLogFunc;
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLAYMeCell *cell = [tableView dequeueReusableCellWithIdentifier:CLAYMeCellID];

    if (indexPath.section == 0) {
        cell.imageView.image = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
        cell.textLabel.text = @"登录/注册";
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"本地视频";
    } else if (indexPath.section == 2) {
        cell.textLabel.text = @"离线下载";
    }

    return cell;
}


#pragma mark - <UITableViewDelegate>
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 10;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        LoginAndRegisterController *vc = [[LoginAndRegisterController alloc] init];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
    }
}

@end
