//
//  CLAYPushGuide.m
//  项目四
//
//  Created by CLAY on 16/6/1.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYPushGuide.h"

@implementation CLAYPushGuide

//移除推送引导
- (IBAction)disappear {
    [self removeFromSuperview];
}

//类方法快速创建对象
+ (instancetype)pushGuide{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

//显示推送引导
+ (void)show{
    //打印infoDictionary得知
    NSString *key = @"CFBundleShortVersionString";
    //取得当前app的版本号(string)
    NSString *bundleVersion = [NSBundle mainBundle].infoDictionary[key];
    //取得沙盒(本地)曾保存的版本号
    NSString *sandboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    //判断是否是新版本第一次启动
    if (![bundleVersion isEqualToString:sandboxVersion]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CLAYPushGuide *guide = [self pushGuide];
        guide.frame = window.bounds;
        [window addSubview:guide];
        [[NSUserDefaults standardUserDefaults] setObject:bundleVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

@end
