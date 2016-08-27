//
//  UIView+CLAYViewController.m
//  项目四
//
//  Created by CLAY on 16/8/27.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "UIView+CLAYViewController.h"

@implementation UIView (CLAYViewController)

-(UIViewController *)viewController{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}

@end
