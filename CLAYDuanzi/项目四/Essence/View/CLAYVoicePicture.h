//
//  CLAYVoicePicture.h
//  项目四
//
//  Created by CLAY on 16/8/16.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLAYDuanzi;

@interface CLAYVoicePicture : UIView

/** model */
@property (nonatomic, strong) CLAYDuanzi *model;

+ (instancetype)voicePicture;

@end
