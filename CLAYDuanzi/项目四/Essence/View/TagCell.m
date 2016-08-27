//
//  TagCell.m
//  项目四
//
//  Created by CLAY on 16/5/30.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "TagCell.h"
#import "TagModel.h"
#import <UIImageView+WebCache.h>

@interface TagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageListImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;

@end

@implementation TagCell

-(void)setTagModel:(TagModel *)tagModel{
    if (_tagModel != tagModel) {
        _tagModel = tagModel;
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];

    [self.imageListImageView sd_setImageWithURL:[NSURL URLWithString:_tagModel.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.themeNameLabel.text = _tagModel.theme_name;
    if (_tagModel.sub_number < 10000) {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%li人订阅",(long)_tagModel.sub_number];
    }else{
        self.subNumberLabel.text = [NSString stringWithFormat:@"%.1lf万人订阅",_tagModel.sub_number/10000.0];
    }


}


//设置边界和分隔线
-(void)setFrame:(CGRect)frame{
    frame.origin.x = 5;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 1;

    [super setFrame:frame];
}

@end
