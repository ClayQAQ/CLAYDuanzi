//
//  EssenceViewController.m
//  项目四
//
//  Created by CLAY on 16/5/26.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "EssenceViewController.h"
#import "TagTableViewController.h"
#import "CLAYEssenceBaseTableViewController.h"


@interface EssenceViewController () <UIScrollViewDelegate>

/** indicator */
@property (nonatomic, weak) UIView *indicator;
/** 记录当前btn */
@property (nonatomic, weak) UIButton *currentBtn;
/** 底层滑动视图 */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 分类标签 */
@property (nonatomic, weak) UIView *titlesView;

@end


@implementation EssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CLAYLogFunc;
    //创建子控制器
    [self setupChildViewControllers];
    //初始化导航栏
    [self setupNav];
    //设置底部scrollView
    [self setupScrollView];
    //设置标签栏
    [self setupTitleView];

}


#pragma mark - 创建子控制器
- (void)setupChildViewControllers{
    CLAYEssenceBaseTableViewController *all = [[CLAYEssenceBaseTableViewController alloc] init];
    all.type = CLAYEssenceTypeAll;
    [self addChildViewController:all];
    CLAYEssenceBaseTableViewController *video = [[CLAYEssenceBaseTableViewController alloc] init];
    video.type = CLAYEssenceTypeVideo;
    [self addChildViewController:video];
    CLAYEssenceBaseTableViewController *voice = [[CLAYEssenceBaseTableViewController alloc] init];
    voice.type = CLAYEssenceTypeVoice;
    [self addChildViewController:voice];
    CLAYEssenceBaseTableViewController *pic = [[CLAYEssenceBaseTableViewController alloc] init];
    pic.type = CLAYEssenceTypePicture;
    [self addChildViewController:pic];
    CLAYEssenceBaseTableViewController *duanzi = [[CLAYEssenceBaseTableViewController alloc] init];
    duanzi.type = CLAYEssenceTypeDuanZi;
    [self addChildViewController:duanzi];
}


#pragma mark - 初始化导航栏
- (void)setupNav{
    //设置标题图片
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    //设置UIBarButtonItem
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" hightlightedImage:@"MainTagSubIconClick" target:self action:@selector(leftAction)];
}

/**
 *  导航栏按钮方法
 */
- (void)leftAction{
    TagTableViewController *vc = [[TagTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 设置标签栏
- (void)setupTitleView{
    //创建标签栏底视图
    UIView *titlesView = [[UIView alloc] init];
    titlesView.frame = CGRectMake(0, 64, self.view.width, 35);
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:titlesView];
    titlesView.tag = -1;
    self.titlesView = titlesView;
    //创建底部指示器
    UIView *indicator = [[UIView alloc] init];
    indicator.backgroundColor = CLAYRGBColor(219, 21, 26);
    indicator.height = 2;
    indicator.y = titlesView.height - indicator.height;
    [titlesView addSubview:indicator];
    indicator.tag = -1;
    self.indicator = indicator;
    //创建标签按钮
    NSArray *titles = @[@"全部", @"视频", @"声音", @"图片", @"搞笑段子"];
    CGFloat btnWidth = titlesView.width / titles.count;
    CGFloat btnHeight = titlesView.height - 2;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(i * btnWidth, 0, btnWidth, btnHeight);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:btn];
        if (i == 0) {
            self.currentBtn = btn;
            //立即布局(titleLabel)
            [btn layoutIfNeeded];
            self.indicator.width = btn.titleLabel.width;
            self.indicator.centerX = btn.centerX;
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn setTitleColor:CLAYRGBColor(219, 21, 26) forState:UIControlStateNormal];
        }
    }


}

/**
 *  标签按钮点击方法
 */
- (void)titleBtnAction:(UIButton *)btn{
    if (self.currentBtn != btn) {
        [UIView animateWithDuration:0.25 animations:^{
            //还原旧的
            self.currentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.currentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            //改变新的
            self.indicator.width = btn.titleLabel.width;
            self.indicator.centerX = btn.centerX;
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn setTitleColor:CLAYRGBColor(219, 21, 26) forState:UIControlStateNormal];
        }];
        self.currentBtn = btn;

        //滚动底层滑动视图
//        self.scrollView.contentOffset = CGPointMake(btn.tag * self.scrollView.width, 0);
        CGPoint offset = self.scrollView.contentOffset;
        offset.x = btn.tag * self.scrollView.width;
        [self.scrollView setContentOffset:offset animated:YES];

    }
}


#pragma mark - 设置底部scrollView
- (void)setupScrollView{
    //不自动偏移
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(scrollView.width * self.childViewControllers.count, 0);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;

    //设置首次的tableViewController的tableView
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


/**
 *  底部scrollView协议
 */

//直接改变时contentOffset时会调用
// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    if (self.childViewControllers) {
        UITableViewController *vc = self.childViewControllers[index];
        vc.tableView.contentInset = UIEdgeInsetsMake(99, 0, 49, 0);
        //至少给定frame.origin.x
        vc.view.x = scrollView.contentOffset.x;
        //控制器默认y=20
        vc.view.y = 0;
        vc.view.height = scrollView.height;
        vc.tableView.scrollIndicatorInsets = vc.tableView.contentInset;
        [self.scrollView addSubview:vc.view];
        //经验证,虽然执行addSubview ,但同样的视图只会添加一次.
        CLAYLog(@"~~: %li",self.scrollView.subviews.count);
    }

}

//scrollView手指滑动结束时调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //虽然调用btn方法,并且setContentOffset: animated: ,但是不会再调用上面的监听协议,所以为了加载视图,得手动调用上面的协议方法!!
    [self scrollViewDidEndScrollingAnimation:scrollView];

    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    //父视图self.titlesView.tag = -1
    //下面方法只是为了让标题移动效果
    UIButton *btn = [self.titlesView viewWithTag:index];
    [self titleBtnAction:btn];
}






@end
