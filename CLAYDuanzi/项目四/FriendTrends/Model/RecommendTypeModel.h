//
//  RecommendTypeModel.h
//  项目四
//
//  Created by CLAY on 16/5/29.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendTypeModel : NSObject

/** id */
@property (nonatomic, assign) NSInteger typerID;
/** name */
@property (nonatomic, copy) NSString *name;


/** 此type的服务器中userModel总个数 */
@property (nonatomic, assign) NSInteger totalCount;

/** 数组,保存RecommendTypeModel对应的众多UserModel */
@property (nonatomic, strong) NSMutableArray *users;

/** 当前页数,自己记录 */
@property (nonatomic, assign) NSInteger currentPage;

@end
