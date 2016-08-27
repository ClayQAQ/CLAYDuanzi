//
//  CLAYVideoPicture.m
//  项目四
//
//  Created by CLAY on 16/8/16.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYVideoPicture.h"
#import "CLAYDuanzi.h"
#import "CLAYEssenceShowPictureVC.h"
#import <UIImageView+WebCache.h>

@interface CLAYVideoPicture ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;


@end

@implementation CLAYVideoPicture

+ (instancetype)videoPicture{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    // 给图片添加监听器
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

- (void)showPicture{
    CLAYEssenceShowPictureVC *vc = [[CLAYEssenceShowPictureVC alloc] init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
    vc.model = self.model;
}


-(void)setModel:(CLAYDuanzi *)model{
    _model = model;

    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.large_image]];
    self.playcountLabel.text = [NSString stringWithFormat:@"%li播放",model.playcount];
    NSInteger min = model.videotime / 60;
    NSInteger sec = model.videotime %60;
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02li:%02li",min,sec];

}

@end
