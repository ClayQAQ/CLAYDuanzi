//
//  CLAYSettingViewController.m
//  项目四
//
//  Created by CLAY on 16/8/27.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYSettingViewController.h"
#import <SVProgressHUD.h>
#import <SDImageCache.h>

@interface CLAYSettingViewController ()

@end

@implementation CLAYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = CLAYRGBColor(223, 223, 223);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    CGFloat size = [SDImageCache sharedImageCache].getSize / 1000.0 / 1000;
    cell.textLabel.text = [NSString stringWithFormat:@"清除缓存    (%.2lfM)",size];
    
    return cell;
}


#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[SDImageCache sharedImageCache] clearDisk];
    //提醒
    [SVProgressHUD showSuccessWithStatus:@"清除缓存成功!"];
    [SVProgressHUD performSelector:@selector(dismiss) withObject:nil afterDelay:1];
    [self.tableView reloadData];
}


@end
