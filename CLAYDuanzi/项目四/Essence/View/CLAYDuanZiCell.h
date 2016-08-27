//
//  CLAYDuanZiCell.h
//  项目四
//
//  Created by CLAY on 16/7/7.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLAYDuanzi.h"

@interface CLAYDuanZiCell : UITableViewCell

/** model */
@property (nonatomic, strong) CLAYDuanzi *duanzi;

+ (instancetype)cell;

@end
