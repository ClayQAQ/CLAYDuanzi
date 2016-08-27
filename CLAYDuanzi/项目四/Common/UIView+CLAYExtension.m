//
//  UIView+CLAYExtension.m
//  微博
//
//  Created by CLAY on 16/5/25.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "UIView+CLAYExtension.h"

@implementation UIView (CLAYExtension)

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(void)setRight:(CGFloat)right{
    CGFloat diff = right - (self.frame.origin.x + self.frame.size.width);
    CGRect frame = self.frame;
//    frame.origin.x = self.frame.origin.x + diff;
    frame.origin.x += diff;
    self.frame = frame;
}

-(void)setBottom:(CGFloat)bottom{
    CGFloat diff = bottom - (self.frame.origin.y + self.frame.size.height);
    CGRect frame = self.frame;
    frame.origin.y += diff;
    self.frame = frame;
}

-(void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

-(CGFloat)right{
    return self.frame.origin.x + self.frame.size.width;
}

-(CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height;
}

-(CGSize)size{
    return self.frame.size;
}

-(CGFloat)centerX{
    return self.center.x;
}

-(CGFloat)centerY{
    return self.center.y;
}

- (BOOL)isShowingOnKeyWindow
{
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

    // 以主窗口左上角为坐标原点, 计算self的矩形框 (nil默认keyWindow)
    CGRect newFrame = [self.superview convertRect:self.frame toView:nil];
    CGRect winBounds = keyWindow.bounds;

    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);

    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}


@end
