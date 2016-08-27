//
//  NSDate+CLAYExt.m
//  项目四
//
//  Created by CLAY on 16/7/7.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "NSDate+CLAYExt.h"

@implementation NSDate (CLAYExt)

- (NSDateComponents *)deltaFrom:(NSDate *)from
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

    return [calendar components:unit fromDate:from toDate:self options:0];
}

- (BOOL)isThisYear{

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];

    return nowYear == selfYear;
}

- (BOOL)isToday{

    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];

    return [nowString isEqualToString:selfString];
}

- (BOOL)isYesterday{

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self toDate:[NSDate date] options:0];

    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}


@end
