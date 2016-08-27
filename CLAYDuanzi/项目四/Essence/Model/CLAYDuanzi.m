//
//  CLAYDuanzi.m
//  项目四
//
//  Created by CLAY on 16/7/7.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYDuanzi.h"
#import <MJExtension.h>

@implementation CLAYDuanzi{
    CGFloat _cellHeight;
}

- (NSString *)create_time{

    //日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //设置日期格式
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //段子的创建时间
    NSDate *create = [fmt dateFromString:_create_time];

    if (create.isThisYear) { //今年
        if (create.isToday) {
            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];

            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%li小时前", cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%li分钟前", cmps.minute];
            } else {
                return @"刚刚";
            }
        } else if (create.isYesterday) {
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        } else {
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
    } else { //非今年
        return _create_time;
    }


}


//单元格高度属性,每个model只计算一次
- (CGFloat)cellHeight{

    if (!_cellHeight) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 10*4;
        CGSize container = CGSizeMake(width, MAXFLOAT);
        CGFloat textHeight = [self.text boundingRectWithSize:container options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}context:nil].size.height;
        _cellHeight = textHeight + 35 + 38 + 10*4;
        _pictureF = CGRectMake(10, textHeight + 35 + 10*3, width, self.height);

        //防止服务器数据返回0崩溃
        if (self.width == 0 || self.height ==0) return 0;

        // 适应后的新图片高度
        CGFloat height = width * self.height / self.width;

        if (self.type == CLAYEssenceTypePicture) {  // 图片模块

            if (self.height > 1000) {
                self.bigPicture = YES;
                CGFloat newPictureH = 400;
                _pictureF = CGRectMake(10, textHeight + 35 +10*3, width, newPictureH);
                _cellHeight += 10 + newPictureH;
            } else {
                _pictureF = CGRectMake(10,textHeight + 35 +10*3 , width, height);
                _cellHeight += 10 + height;
            }
        }else if (self.type == CLAYEssenceTypeVoice){ // 声音模块
            
            _voiceF = CGRectMake(10, textHeight + 35 +10*3, width, height);
            _cellHeight += 10 + height;
        } else if (self.type == CLAYEssenceTypeVideo){ // 视频模块
            _videoF = CGRectMake(10, textHeight + 35 +10*3, width, height);
            _cellHeight += 10 + height;
        }
    }
    
    return _cellHeight;

}





/*
     @"small_image" : @"image0",
     @"large_image" : @"image1",
    @"middle_image" : @"image2"
*/

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"image0"]) {
        _small_image = value;
    } else if ([key isEqualToString:@"image1"]){
        _large_image = value;
    } else if ([key isEqualToString:@"image2"]){
        _middle_image = value;
    }else if ([key isEqualToString:@"id"]){
        _ID = value;
    }
    
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"small_image" : @"image0",
             @"large_image" : @"image1",
             @"middle_image" : @"image2",
             @"ID" : @"id",
             @"top_cmt" : @"top_cmt[0]" //,
             //             @"qzone_uid" : @"top_cmt[0].user.qzone_uid"
             };
}




@end
