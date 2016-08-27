//
//  CLAYVerticalButton.m
//  项目四
//
//  Created by CLAY on 16/5/31.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYVerticalButton.h"

@implementation CLAYVerticalButton


- (void)config{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}

-(void)awakeFromNib{
    [self config];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    //设置图片frame
    self.imageView.frame = CGRectMake(0, 0, self.width, self.width);
    //设置titleLabel位置
    self.titleLabel.frame = CGRectMake(0, self.width, self.width, self.height - self.width);
}

@end
