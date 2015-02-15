//
//  QSWSettingCell.h
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QSWSettingItem;
@class QSWTextFieldItem;

@interface QSWSettingCell : UITableViewCell

@property (strong, nonatomic) QSWSettingItem *item;         //!<cell的模型
@property (nonatomic, strong) NSIndexPath *indexPath;       //!<tabbleView每行cell的序号
+ (instancetype)cellWithTableView:(UITableView *)tableView; //!<处始化cell的方法

@end
