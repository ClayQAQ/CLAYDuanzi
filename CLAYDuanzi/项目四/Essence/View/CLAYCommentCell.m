//
//  CLAYCommentCell.m
//  项目四
//
//  Created by CLAY on 16/8/22.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYCommentCell.h"
#import "CLAYComment.h"
#import "CLAYUser.h"
#import <UIImageView+WebCache.h>

@interface CLAYCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likecountLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;

@end

@implementation CLAYCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
}

-(void)setModel:(CLAYComment *)model{
    _model = model;

    [self.profileImageView circleProfile:model.user.profile_image];
    self.sexImageView.image = [model.user.sex isEqualToString:@"m"]?[UIImage imageNamed:@"Profile_manIcon"] : [UIImage imageNamed:@"Profile_womanIcon"];
    self.userNameLabel.text = model.user.username;
    self.likecountLabel.text = [NSString stringWithFormat:@"%li",model.like_count];
    self.contentLabel.text = model.content;
    if (model.voiceuri.length) {
        self.voiceBtn.hidden = NO;
        self.voiceBtn.titleLabel.text = [NSString stringWithFormat:@"%li''",model.voicetime];
    }else{
        self.voiceBtn.hidden = YES;
    }
}


#warning Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
-(void)setFrame:(CGRect)frame{
    frame.origin.x = 10;
    frame.size.width -= 2 * 10;
    [super setFrame:frame];
}

#pragma mark - menuController 配置
- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return NO;
}

@end
