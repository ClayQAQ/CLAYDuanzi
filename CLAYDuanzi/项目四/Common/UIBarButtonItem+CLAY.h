//
//  UIBarButtonItem+CLAY.h
//  项目四
//
//  Created by CLAY on 16/5/27.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CLAY)

+ (UIBarButtonItem *)itemWithImage:(NSString *)image hightlightedImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
