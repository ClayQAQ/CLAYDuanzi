//
//  CLAYComment.h
//  项目四
//
//  Created by CLAY on 16/8/21.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <Foundation/Foundation.h>


@class CLAYUser;
@interface CLAYComment : NSObject

/** id */
@property (nonatomic, copy) NSString *ID;
/** 音频文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 音频文件的路径 */
@property (nonatomic, copy) NSString *voiceuri;
/** 评论的文字内容 */
@property (nonatomic, copy) NSString *content;
/** 被点赞的数量 */
@property (nonatomic, assign) NSInteger like_count;
/** 用户 */
@property (nonatomic, strong) CLAYUser *user;

@end
