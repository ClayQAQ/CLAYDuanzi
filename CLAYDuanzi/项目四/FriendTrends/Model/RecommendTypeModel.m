//
//  RecommendTypeModel.m
//  项目四
//
//  Created by CLAY on 16/5/29.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "RecommendTypeModel.h"

@implementation RecommendTypeModel


/**
 *  直接KVC填充model,若有不符必重写
 *
 *  @param value 网络请求的UndefinedKey的对应数值 / 这里value不会如KVC自动转化
 *  @param key   网络数据key
 */
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.typerID = [value integerValue];
    }
}


//懒加载,便于直接用
- (NSMutableArray *)users{
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}


@end
