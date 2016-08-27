//
//  CLAYTextField.m
//  项目四
//
//  Created by CLAY on 16/5/31.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYTextField.h"
#import <objc/runtime.h>

static NSString * const CLAYPlaceholderColorKeyPath = @"_placeholderLabel.textColor";
@implementation CLAYTextField

-(void)awakeFromNib{
    //test
//    [self testRuntime];
    //设置光标颜色
    self.tintColor = [UIColor whiteColor];
    //设置初始颜色
    [self resignFirstResponder];
}


//失去第一响应者时
-(BOOL)resignFirstResponder{
    //KVC改变placeholder颜色
    [self setValue:[UIColor grayColor] forKeyPath:CLAYPlaceholderColorKeyPath];
    return [super resignFirstResponder];
}

//成为第一响应者时
-(BOOL)becomeFirstResponder{
    [self setValue:self.textColor forKeyPath:CLAYPlaceholderColorKeyPath];
    return [super becomeFirstResponder];
}


//寻找可能的成员变量
- (void)testRuntime{
    unsigned int count;
    Ivar *ivars = class_copyIvarList([UITextField class], &count);
    for (NSInteger i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        CLAYLog(@"%s , %s",ivar_getName(ivar),ivar_getTypeEncoding(ivar));
    }
    free(ivars);
}






@end
