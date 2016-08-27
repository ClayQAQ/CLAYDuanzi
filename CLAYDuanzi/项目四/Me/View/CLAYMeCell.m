//
//  CLAYMeCell.m
//  项目四
//
//  Created by CLAY on 16/8/26.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYMeCell.h"

@implementation CLAYMeCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"mainCellBackground"];
        self.backgroundView = bgView;

        self.textLabel.textColor = CLAYRGBColor(69, 69, 69);
        self.textLabel.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //避免改变第二组的排布
    if (self.imageView.image == nil) return;

    self.imageView.width = 30;
    self.imageView.height = self.imageView.width;
    self.imageView.centerY = self.contentView.height * 0.5;

    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + 10;
}


@end
