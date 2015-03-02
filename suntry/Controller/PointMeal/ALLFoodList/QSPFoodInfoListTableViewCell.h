//
//  QSPFoodInfoListTableViewCell.h
//  suntry
//
//  Created by CoolTea on 15/2/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSPFoodCountControlView.h"

@protocol QSPFoodInfoListTableViewCellDelegate<NSObject>

/**
 *  返回选择的菜品数据以及数量
 *
 *  @param count    数量
 *  @param foodData 菜品数据
 */
- (void)changedCount:(NSInteger)count withFoodData:(id)foodData;

- (void)clickFoodImgIndex:(NSInteger)index withFoodData:(id)foodData;

@end

@interface QSPFoodInfoListTableViewCell : UITableViewCell<SPFoodCountControlViewDelegate>

@property(nonatomic,assign) id<QSPFoodInfoListTableViewCellDelegate> delegate;

- (void)updateFoodData:(id)data withIndex:(NSInteger)index;

- (id)getFoodData;

- (void)setSlelectedCount:(NSInteger)count;

@end
