//
//  QSPOrderViewHadOrderCell.h
//  suntry
//
//  Created by CoolTea on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSPFoodCountControlView.h"

@protocol QSPOrderViewHadOrderCellDelegate<NSObject>

/**
 *  返回选择的菜品数据以及数量
 *
 *  @param count    数量
 *  @param foodData 菜品数据
 */
- (void)changedCount:(NSInteger)count withFoodData:(id)foodData;

@end

@interface QSPOrderViewHadOrderCell : UIView<SPFoodCountControlViewDelegate>

@property(nonatomic,assign) id<QSPOrderViewHadOrderCellDelegate> delegate;

- (instancetype)initOrderItemViewWithData:(id)foodData withCount:(NSInteger)count;

@end
