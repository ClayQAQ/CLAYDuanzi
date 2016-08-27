//
//  RecommedTypeCell.m
//  项目四
//
//  Created by CLAY on 16/5/29.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "RecommendTypeCell.h"

@interface RecommendTypeCell()

@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;

@end

@implementation RecommendTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectedIndicator.backgroundColor = CLAYRGBColor(219, 21, 26);
    //设置textLabel
    self.textLabel.font = [UIFont systemFontOfSize:16];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}

//textLabel挡住了中间部分的自定义分割线
-(void)layoutSubviews{
    [super layoutSubviews];

    self.textLabel.y = 1;
    self.textLabel.height = self.height-2;
}

//cell的显示/选中/取消选中, 都会调用此方法,只有选中时selected参数为YES. (CLAYLogFunc;验证)
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectedIndicator.hidden = !selected;
    self.textLabel.textColor = selected?self.selectedIndicator.backgroundColor:CLAYRGBColor(78, 78, 78);
    self.backgroundColor = selected?[UIColor whiteColor]:[UIColor clearColor];

}

@end
