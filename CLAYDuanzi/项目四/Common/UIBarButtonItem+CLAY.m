//
//  UIBarButtonItem+CLAY.m
//  项目四
//
//  Created by CLAY on 16/5/27.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "UIBarButtonItem+CLAY.h"

@implementation UIBarButtonItem (CLAY)


+(UIBarButtonItem *)itemWithImage:(NSString *)image hightlightedImage:(NSString *)highImage target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

@end
