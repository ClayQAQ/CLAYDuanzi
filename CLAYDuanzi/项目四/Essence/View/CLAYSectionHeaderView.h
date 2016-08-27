//
//  CLAYSectionHeaderView.h
//  项目四
//
//  Created by CLAY on 16/8/25.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLAYSectionHeaderView : UITableViewHeaderFooterView

/** 标题文字 */
@property (nonatomic, strong) NSString *title;


+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@end
