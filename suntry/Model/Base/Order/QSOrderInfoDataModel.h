//
//  QSOrderInfoDataModel.h
//  suntry
//
//  Created by ysmeng on 15/2/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

/**
 *  @author yangshengmeng, 15-02-26 11:02:30
 *
 *  @brief  生成订单时返回的数据模型
 *
 *  @since  1.0.0
 */
@interface QSOrderInfoDataModel : QSBaseModel

@property (nonatomic,copy) NSString *orderTitle;//!<订单标题
@property (nonatomic,copy) NSString *bill_id;   //!<财务使用的ID
@property (nonatomic,copy) NSString *order_id;  //!<订单ID
@property (nonatomic,copy) NSString *bill_num;  //!<账务使用的订单编码
@property (nonatomic,copy) NSString *order_num; //!<订单编码

@end
