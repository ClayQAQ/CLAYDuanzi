//
//  CLAYEssenceShowPictureVC.m
//  项目四
//
//  Created by CLAY on 16/7/25.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYEssenceShowPictureVC.h"
#import "CLAYDuanzi.h"
#import <UIImageView+WebCache.h>
#import <DALabeledCircularProgressView.h>
#import <SVProgressHUD.h>

@interface CLAYEssenceShowPictureVC ()

/** 滑动视图 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/** picture */
@property (nonatomic, weak) UIImageView *imageView;
/** 进度指示器 */
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;

@end

@implementation CLAYEssenceShowPictureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置触屏返回手势
    [self setupGesture];
    //配置图片
    [self setupPictureView];
}


/**
 *  设置触屏返回手势
 */
- (void)setupGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [self.scrollView addGestureRecognizer:tap];
}



/**
 *  配置图片
 */
- (void)setupPictureView{
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
}

//setModel
-(void)setModel:(CLAYDuanzi *)model{
    _model = model;

    [self.progressView setProgress:self.model.pictureProgress animated:NO];

    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.model.pictureProgress = receivedSize * 1.0 / expectedSize;
        [self.progressView setProgress: self.model.pictureProgress animated:NO];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
    //确定图片的frame
    [self setupPictureFrame];
}


/**
 *  确定图片的frame
 */
- (void)setupPictureFrame{
    CGFloat pictureW = kScreenWidth;
    CGFloat pictureH = pictureW * self.model.height / self.model.width;
    if (pictureH > kScreenHeight) {
        self.imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, pictureH);
    } else {
        self.imageView.size = CGSizeMake(pictureW, pictureH);
        self.imageView.centerY = kScreenHeight * 0.5;

    }
}


//返回按钮
- (IBAction)back {
    [self dismissViewControllerAnimated:NO completion:nil];
}

//保存图片
- (IBAction)savePicture {
    if (!self.imageView.image) {
        [SVProgressHUD showErrorWithStatus:@"图片未下载完毕!"];
        return;
    }
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败!"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
        [SVProgressHUD performSelector:@selector(dismiss) withObject:nil afterDelay:1];
    }
}

//xib无法取消状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
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
