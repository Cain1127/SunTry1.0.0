//
//  QSWSettingCell.h
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QSWSettingItem;
@interface QSWSettingCell : UITableViewCell

@property (strong, nonatomic) QSWSettingItem *item;
@property (nonatomic, strong) NSIndexPath *indexPath;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
