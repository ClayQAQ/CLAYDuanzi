//
//  CLAYPublishViewController.m
//  项目四
//
//  Created by CLAY on 16/7/28.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYPublishViewController.h"
#import "CLAYVerticalButton.h"
#import "LoginAndRegisterController.h"
#import <POP.h>

@interface CLAYPublishViewController ()

@end

static CGFloat const CLAYAnimationDelay = 0.1;

@implementation CLAYPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 让控制器的view不能被点击
    self.view.userInteractionEnabled = NO;

    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];

    // 中间的6个按钮
    int maxCols = 3;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartY = (kScreenHeight - 2 * buttonH) * 0.5;
    CGFloat buttonStartX = 20;
    CGFloat xMargin = (kScreenWidth - 2 * buttonStartX - maxCols * buttonW) / (maxCols - 1);
    for (int i = 0; i<images.count; i++) {
        CLAYVerticalButton *button = [[CLAYVerticalButton alloc] init];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        // 设置内容
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];

        // 计算X\Y
        int row = i / maxCols;
        int col = i % maxCols;
        CGFloat buttonX = buttonStartX + col * (xMargin + buttonW);
        CGFloat buttonEndY = buttonStartY + row * buttonH;
        CGFloat buttonBeginY = buttonEndY - kScreenHeight;

        // 按钮动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBeginY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        anim.springBounciness = 10;
        anim.springSpeed = 10;
        anim.beginTime = CACurrentMediaTime() + CLAYAnimationDelay * i;
        [button pop_addAnimation:anim forKey:nil];
    }

    // 添加标语
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    sloganView.centerX = 0.5 * kScreenWidth;
    sloganView.y = -50;
    [self.view addSubview:sloganView];

    // 标语动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    CGFloat centerX = kScreenWidth * 0.5;
    CGFloat centerEndY = kScreenHeight * 0.2;
//    CGFloat centerBeginY = centerEndY - kScreenHeight;
//    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerBeginY)];
//    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, 400)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    anim.beginTime = CACurrentMediaTime() + images.count * CLAYAnimationDelay;
    anim.springBounciness = 10;
    anim.springSpeed = 10;
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        // 标语动画执行完毕, 恢复点击事件
        self.view.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:anim forKey:nil];

}


- (void)buttonClick:(UIButton *)button
{
    [self cancelWithCompletionBlock:^{
        LoginAndRegisterController *vc = [[LoginAndRegisterController alloc] init];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
    }];
}



- (IBAction)cancel {
    [self cancelWithCompletionBlock:nil];

}

/**
 * 先执行退出动画, 动画完毕后执行completionBlock
 */
- (void)cancelWithCompletionBlock:(void (^)())completionBlock
{
    // 让控制器的view不能被点击
    self.view.userInteractionEnabled = NO;

    int beginIndex = 2;

    for (int i = beginIndex; i<self.view.subviews.count; i++) {
        UIView *subview = self.view.subviews[i];

        // 基本动画
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY = subview.centerY + kScreenHeight;
        // 动画的执行节奏(一开始很慢, 后面很快)
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subview.centerX, centerY)];
        anim.beginTime = CACurrentMediaTime() + (i - beginIndex) * CLAYAnimationDelay;
        [subview pop_addAnimation:anim forKey:nil];

        // 监听最后一个动画
        if (i == self.view.subviews.count - 1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                [self dismissViewControllerAnimated:NO completion:nil];

                // 执行传进来的completionBlock参数
                !completionBlock ? : completionBlock();
            }];
        }
    }
}



//触摸空白处时退出发布界面
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelWithCompletionBlock:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
