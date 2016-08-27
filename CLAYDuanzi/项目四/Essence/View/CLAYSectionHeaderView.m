//
//  CLAYSectionHeaderView.m
//  项目四
//
//  Created by CLAY on 16/8/25.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYSectionHeaderView.h"

@interface CLAYSectionHeaderView ()
/** label */
@property (nonatomic, weak) UILabel *label;
@end

@implementation CLAYSectionHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"header";
    CLAYSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) { // 缓存池中没有, 自己创建
        header = [[CLAYSectionHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = CLAYRGBColor(223, 223, 223);
        // 创建label
        UILabel *label = [[UILabel alloc] init];
        label.textColor = CLAYRGBColor(67, 67, 67);
        label.width = 200;
        label.x = 10;
        label.font = [UIFont boldSystemFontOfSize:16];
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];

    self.label.text = title;
}


@end
