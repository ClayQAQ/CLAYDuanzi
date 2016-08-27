//
//  UIImage+CLAYCircleExtension.m
//  项目四
//
//  Created by CLAY on 16/8/26.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "UIImage+CLAYCircleExtension.h"

@implementation UIImage (CLAYCircleExtension)


-(UIImage *)circleImage{

    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);

    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

@end
