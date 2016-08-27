//
//  CLAYVideoPicture.h
//  项目四
//
//  Created by CLAY on 16/8/16.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLAYDuanzi;
@interface CLAYVideoPicture : UIView

/** model */
@property (nonatomic, strong) CLAYDuanzi *model;

+ (instancetype)videoPicture;

@end
