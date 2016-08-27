//
//  NSDate+CLAYExt.h
//  项目四
//
//  Created by CLAY on 16/7/7.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CLAYExt)

/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;

@end
