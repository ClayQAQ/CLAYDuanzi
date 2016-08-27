//
//  RcommedUserModel.h
//  项目四
//
//  Created by CLAY on 16/5/29.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendUserModel : NSObject
/** 头像url */
@property (nonatomic, copy) NSString *header;
/** 粉丝数 */
@property (nonatomic, assign) NSInteger fans_count;
/** 用户名 */
@property (nonatomic, copy) NSString *screen_name;

@end
