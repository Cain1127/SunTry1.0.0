//
//  QSUserCouponTableViewCell.h
//  suntry
//
//  Created by ysmeng on 15/2/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author yangshengmeng, 15-02-16 14:02:45
 *
 *  @brief  我的优惠券列表信息展示cell
 *
 *  @since  1.0.0
 */
@class QSCouponInfoDataModel;
@interface QSUserCouponTableViewCell : UITableViewCell

/**
 *  @author         yangshengmeng, 15-02-16 14:02:18
 *
 *  @brief          根据列表优惠券模型，更新优惠券信息
 *
 *  @param model    数据模型
 *
 *  @since          1.0.0
 */
- (void)updateUserCouponInfoCellUI:(QSCouponInfoDataModel *)model;

@end
