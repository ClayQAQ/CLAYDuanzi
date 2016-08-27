//
//  RecommedUserCell.m
//  项目四
//
//  Created by CLAY on 16/5/29.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "RecommendUserCell.h"
#import <UIImageView+WebCache.h>
#import "RecommendUserModel.h"

@interface RecommendUserCell ()


@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@end


@implementation RecommendUserCell

-(void)awakeFromNib{
    [super awakeFromNib];
    //取消选择效果 (nib中也可设置)
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setUser:(RecommendUserModel *)user{
    //复用池或许有正好契合的, 如果不判断,还不如全写到set方法中.
    if (_user != user) {
        _user = user;
        [self setNeedsLayout];
    }

}

-(void)layoutSubviews{
    [super layoutSubviews];

    [self.userImageView circleProfile:_user.header];
    _userNameLabel.text = _user.screen_name;
    //简化下数据
    if (_user.fans_count < 10000) {
        _fansCountLabel.text = [NSString stringWithFormat:@"%li人关注",(long)_user.fans_count];
    }else{
        _fansCountLabel.text = [NSString stringWithFormat:@"%.2lf万人关注",_user.fans_count/10000.0];
    }
    
}

@end
