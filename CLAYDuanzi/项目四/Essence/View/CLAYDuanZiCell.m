//
//  CLAYDuanZiCell.m
//  项目四
//
//  Created by CLAY on 16/7/7.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYDuanZiCell.h"
#import "CLAYPictureView.h"
#import "CLAYVoicePicture.h"
#import "CLAYVideoPicture.h"
#import <UIImageView+WebCache.h>

@interface CLAYDuanZiCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profile_image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *create_time;
@property (weak, nonatomic) IBOutlet UIButton *ding;
@property (weak, nonatomic) IBOutlet UIButton *cai;
@property (weak, nonatomic) IBOutlet UIButton *repost;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIImageView *sina_v;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;

/** 图片 */
@property (nonatomic, weak) CLAYPictureView *pictureView;
/** 声音图片 */
@property (nonatomic, weak) CLAYVoicePicture *voicePicture;
/** 视频图片 */
@property (nonatomic, weak) CLAYVideoPicture *videoPicture;


@end

@implementation CLAYDuanZiCell

+(instancetype)cell{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    //设置cell背景图
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    //取消选中效果
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    //圆角头像
//    self.profile_image.layer.cornerRadius = self.profile_image.width * 0.5;
//    self.profile_image.layer.masksToBounds = YES;

}



/**
 *  懒加载 pictureView
 */
- (CLAYPictureView *)pictureView{
    if (!_pictureView) {
        CLAYPictureView *imageView = [CLAYPictureView pictureView];
        [self.contentView addSubview:imageView];
        _pictureView = imageView;
    }
    return _pictureView;
}

/**
 *  懒加载 voicePicture
 */
- (CLAYVoicePicture *)voicePicture{
    if (!_voicePicture) {
        CLAYVoicePicture *voicePicture = [CLAYVoicePicture voicePicture];
        [self.contentView addSubview:voicePicture];
        _voicePicture = voicePicture;
    }
    return _voicePicture;
}

/**
 *  懒加载 videoPicture
 */
- (CLAYVideoPicture *)videoPicture{
    if (!_videoPicture) {
        CLAYVideoPicture *videoPicture = [CLAYVideoPicture videoPicture];
        [self.contentView addSubview:videoPicture];
        _videoPicture = videoPicture;
    }
    return _videoPicture;
}





//数据的设置,与数据的应用
-(void)setDuanzi:(CLAYDuanzi *)duanzi{
    _duanzi = duanzi;

    self.name.text = duanzi.name;
    
    [self.profile_image circleProfile:duanzi.profile_image];

    self.create_time.text = duanzi.create_time;
    //设置按钮Title计数
    [self setButtonTitle:self.ding withCount:self.duanzi.ding placeholder:@"顶"];
    [self setButtonTitle:self.cai withCount:self.duanzi.cai placeholder:@"踩"];
    [self setButtonTitle:self.repost withCount:self.duanzi.repost placeholder:@"转发"];
    [self setButtonTitle:self.comment withCount:self.duanzi.comment placeholder:@"评论"];
    //V标志覆盖个假数据
    self.duanzi.sina_v = arc4random_uniform(10)%2;
    self.sina_v.hidden = !self.duanzi.isSina_v;
    //显示内容文字
    self.contentTextLabel.text = self.duanzi.text;
    //清空frame,即隐藏图片,防止重用
    self.pictureView.frame = CGRectZero;

    if (self.duanzi.type == CLAYEssenceTypePicture) {  // 图片
        self.pictureView.frame = self.duanzi.pictureF;
        self.pictureView.hidden = NO;
        self.voicePicture.hidden = YES;
        self.videoPicture.hidden = YES;
        self.pictureView.model = self.duanzi;
    } else if (self.duanzi.type == CLAYEssenceTypeVoice){ //声音
        self.voicePicture.frame = self.duanzi.voiceF;
        self.pictureView.hidden = YES;
        self.voicePicture.hidden = NO;
        self.videoPicture.hidden = YES;
        self.voicePicture.model = self.duanzi;
    } else if (self.duanzi.type == CLAYEssenceTypeVideo){ //视频

        self.videoPicture.frame = self.duanzi.videoF;
        self.videoPicture.hidden = NO;
        self.pictureView.hidden = YES;
        self.voicePicture.hidden = YES;

        self.videoPicture.model = self.duanzi;
    } else if (self.duanzi.type == CLAYEssenceTypeDuanZi){   // 段子
        self.pictureView.hidden = YES;
        self.voicePicture.hidden = YES;
        self.videoPicture.hidden = YES;
    } 

}


/**
 *  设置处理按钮title
 */
- (void)setButtonTitle:(UIButton *)btn withCount:(NSInteger)count placeholder:(NSString *)placeholder{
    if (count >= 10000) {
        [btn setTitle:[NSString stringWithFormat:@"%lf万",count / 10000.0] forState:UIControlStateNormal];
    } else if (count > 0) {
        [btn setTitle:[NSString stringWithFormat:@"%li",count] forState:UIControlStateNormal];
    } else {
        [btn setTitle:placeholder forState:UIControlStateNormal];
    }
}

//设置cell间隙
-(void)setFrame:(CGRect)frame{

    frame.origin.x = 10;
    frame.size.width -= 20;
    frame.size.height -= 10;
    frame.origin.y += 10; //只算第一个的 之后不看了 直接堆叠高度

    [super setFrame:frame];
}

@end
