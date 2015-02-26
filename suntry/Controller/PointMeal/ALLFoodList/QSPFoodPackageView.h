//
//  QSPFoodPackageView.h
//  suntry
//  套餐弹出View
//  Created by CoolTea on 15/2/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QSPFoodPackageViewDelegate<NSObject>

- (void)submitWithData:(id)data;

@end

@interface QSPFoodPackageView : UIView

@property(nonatomic,assign) id<QSPFoodPackageViewDelegate> delegate;

/**
 *  创建初始化套餐弹出界面
 *
 *  @return 套餐选择弹出界面
 */
+ (instancetype)getPackageView;

/**
 *  显示套餐选择弹出界面
 */
- (void)showPackageView;

/**
 *  隐藏套餐选择弹出界面
 */
- (void)hidePackageView;

/**
 *  设置套餐数据
 *
 *  @param data 套餐的数据
 */
- (void)updateFoodData:(id)data;


/**
 *  获取当前套餐选择数据
 *
 *  @return 套餐选择数据
 */
- (id)getSelectFoodData;


@end
