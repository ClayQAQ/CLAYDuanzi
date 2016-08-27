//
//  CLAYComment.m
//  项目四
//
//  Created by CLAY on 16/8/21.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYComment.h"
#import "CLAYUser.h"
#import <MJExtension.h>

@implementation CLAYComment

//-(CLAYUser *)user{
//    return [[CLAYUser alloc] init];
//}
//
//-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    if ([key isEqualToString:@"user"]) {
//        [self.user setValuesForKeysWithDictionary:value];
//    } else if ([key isEqualToString:@"id"]){
//        self.ID = value;
//    }
//}


+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end
