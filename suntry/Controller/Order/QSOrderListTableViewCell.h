//
//  QSOrderListTableViewCell.h
//  suntry
//
//  Created by CoolTea on 15/2/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ORDER_LIST_CELL_HEIGHT      60.

@interface QSOrderListTableViewCell : UITableViewCell

- (void)updateFoodData:(id)data;

- (void)showTopLine:(BOOL)flag;

@end
