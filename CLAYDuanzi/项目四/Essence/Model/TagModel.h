//
//  TagModel.h
//  项目四
//
//  Created by CLAY on 16/5/30.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagModel : NSObject

/** 图片urlString */
@property (nonatomic, copy) NSString *image_list;
/** 名字 */
@property (nonatomic, copy) NSString *theme_name;
/** 订阅数 */
@property (nonatomic, assign) NSInteger sub_number;

@end
