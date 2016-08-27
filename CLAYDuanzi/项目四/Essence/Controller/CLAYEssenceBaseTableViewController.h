//
//  CLAYDuanZiTableViewController.h
//  项目四
//
//  Created by CLAY on 16/7/2.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    CLAYEssenceTypeAll = 1,
    CLAYEssenceTypePicture = 10,
    CLAYEssenceTypeDuanZi = 29,
    CLAYEssenceTypeVoice = 31,
    CLAYEssenceTypeVideo = 41

}CLAYEssenceType;

@interface CLAYEssenceBaseTableViewController : UITableViewController

/** 请求数据类型 */
@property (nonatomic, assign) CLAYEssenceType type;

@end
