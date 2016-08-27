//
//  CLAYPictureView.m
//  项目四
//
//  Created by CLAY on 16/7/19.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYPictureView.h"
#import "CLAYEssenceShowPictureVC.h"
#import <UIImageView+WebCache.h>
#import <DALabeledCircularProgressView.h>

@interface CLAYPictureView ()
/** 内容图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** gif标志图 */
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
/** "点击查看全图"按钮 */
@property (weak, nonatomic) IBOutlet UIButton *seeWholeBtn;
/** 加载进度图片 */
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;


@end


@implementation CLAYPictureView

+(instancetype)pictureView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
    self.imageView.userInteractionEnabled =YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.imageView addGestureRecognizer:tap];
}

-(void)setModel:(CLAYDuanzi *)model{
    _model = model;
    //重置显示当前进度
    [self.progressView setProgress:self.model.pictureProgress animated:NO];
    //加载图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        self.model.pictureProgress = receivedSize * 1.0 / expectedSize;
        [self.progressView setProgress: self.model.pictureProgress animated:NO];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;

        //大图缩略图显示顶部
        if (self.model.isBigPicture) {

            // 开启图形上下文
            UIGraphicsBeginImageContextWithOptions(model.pictureF.size, YES, 0.0);
            // 将下载完的image对象绘制到图形上下文
            CGFloat width = model.pictureF.size.width;
            CGFloat height = width * image.size.height / image.size.width;
            [image drawInRect:CGRectMake(0, 0, width, height)];
            // 获得图片
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            // 结束图形上下文
            UIGraphicsEndImageContext();
        }
    }];
    //gif标志图处理
    NSString *extension = model.large_image.pathExtension;
    self.gifImageView.hidden = !([extension.lowercaseString isEqualToString:@"gif"]);
    //点击查看全图按钮 处理
    self.seeWholeBtn.hidden = !self.model.isBigPicture;

}

- (IBAction)tapAction{
    CLAYEssenceShowPictureVC *vc = [[CLAYEssenceShowPictureVC alloc] init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
    vc.model = self.model;
    
}

@end
