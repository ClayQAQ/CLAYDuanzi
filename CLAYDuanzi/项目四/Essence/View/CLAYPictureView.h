//
//  CLAYPictureView.h
//  项目四
//
//  Created by CLAY on 16/7/19.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLAYDuanzi.h"

@interface CLAYPictureView : UIView

/** model数据 */
@property (nonatomic, strong) CLAYDuanzi *model;


+ (instancetype)pictureView;


@end
