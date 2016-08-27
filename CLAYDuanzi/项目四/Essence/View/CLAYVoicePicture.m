//
//  CLAYVoicePicture.m
//  项目四
//
//  Created by CLAY on 16/8/16.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYVoicePicture.h"
#import "CLAYDuanzi.h"
#import "CLAYEssenceShowPictureVC.h"
#import <UIImageView+WebCache.h>

@interface CLAYVoicePicture ()

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;

@end

@implementation CLAYVoicePicture

+ (instancetype)voicePicture
{
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
    vc.model = self.model; //放在viewDidLoad后面
}

- (void)setModel:(CLAYDuanzi *)model{
    _model = model;

    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.large_image]];
    self.playcountLabel.text = [NSString stringWithFormat:@"%li播放",model.playcount];
    NSInteger min = model.voicetime / 60;
    NSInteger sec = model.voicetime %60;
    self.voicetimeLabel.text = [NSString stringWithFormat:@"%02li:%02li",min,sec];
}



@end
