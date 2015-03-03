//
//  QSPFoodTypeTableViewCell.h
//  suntry
//
//  Created by CoolTea on 15/2/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define QSPFOOD_TYPE_TABLEVIEW_CELL_TITLE_FONT_SIZE     17.0f
#define FOOD_TYPE_TABLEVIEW_WIDTH                       88/375.*SIZE_DEVICE_WIDTH
#define FOODTYPE_TABLEVIEW_CELL_LINE_COLOR              [UIColor colorWithRed:206/255. green:208/255. blue:210/255. alpha:1]

@interface QSPFoodTypeTableViewCell : UITableViewCell

- (void)setFoodTypeName:(NSString*)title;

@end
