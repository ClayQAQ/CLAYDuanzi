//
//  UIImageView+CLAYProfileCircleImageView.m
//  项目四
//
//  Created by CLAY on 16/8/26.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "UIImageView+CLAYProfileCircleImageView.h"
#import "UIImage+CLAYCircleExtension.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (CLAYProfileCircleImageView)

-(void)circleProfile:(NSString *)urlString{
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image circleImage]:placeholder;
    }];
}

@end
