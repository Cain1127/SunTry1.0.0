//
//  QSPFoodPackageItemGridView.h
//  suntry
//
//  Created by CoolTea on 15/2/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSPFoodPackageItemGridView : UIView

/**
 *  创建初始化菜品单品View
 *
 *  @param foodData 菜品初始化需要的数据
 *
 *  @return 菜品九宫格子View
 */
- (instancetype)initGridViewWithData:(id)foodData;

/**
 *  获取此菜品选择是否被选择
 *
 *  @return YES：选中状态  NO：未选中
 */
- (BOOL)getSelectState;

/**
 *  返回该View显示的菜品
 *
 *  @return 菜品数据
 */
- (id)getFoodData;

@end
