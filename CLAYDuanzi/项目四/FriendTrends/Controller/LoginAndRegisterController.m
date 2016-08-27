//
//  LoginAndRegisterController.m
//  项目四
//
//  Created by CLAY on 16/5/31.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "LoginAndRegisterController.h"

@interface LoginAndRegisterController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstrain;

@end

@implementation LoginAndRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置bgImageView在最下层
    [self.view insertSubview:self.bgImageView atIndex:0];
}

//设置状态栏style
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

//返回上一级控制器
- (IBAction)back {
    [self.view resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)loginOrRegister:(UIButton *)sender {
    //先退出键盘
    [self.view endEditing:YES];
    if (self.leftConstrain.constant == 0) {
        self.leftConstrain.constant = -self.view.width;
        sender.selected = YES;
    }else{
        self.leftConstrain.constant = 0;
        sender.selected = NO;
    }
    //设置约束改变动画
    [UIView animateWithDuration:0.3 animations:^{
        //立即刷新layout
        [self.view layoutIfNeeded];
    }];

}




@end
