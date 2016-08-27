//
//  CLAYUser.h
//  项目四
//
//  Created by CLAY on 16/8/21.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLAYUser : NSObject

/** 用户名 */
@property (nonatomic, copy) NSString *username;
/** 性别 */
@property (nonatomic, copy) NSString *sex;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;

@end
