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
@property (nonatomic,copy) NSString *seller_id; //!<进帐ID
@property (nonatomic,copy) NSString *partner_id;//!<合同商户ID
@property (nonatomic,copy) NSString *des;       //!<订单描述
@property (nonatomic,copy) NSString *payPrice;  //!<真正支付金额
@property (nonatomic,copy) NSString *notify_url;//!<支付宝支付结果服务端回调地址

///支付的回调block
@property (nonatomic,copy) void(^alixpayCallBack)(NSString *alixPayCode,NSString *alixPayInfo);
@property (nonatomic,copy) NSString *priPKCS8Key;//!<私钥

/**
 *  @author yangshengmeng, 15-02-26 14:02:56
 *
 *  @brief  服务端返回的信息
 *
 *  @since  1.0.0
 */
@property (nonatomic,copy) NSString *bill_id;   //!<财务使用的ID
@property (nonatomic,copy) NSString *order_id;  //!<订单ID
@property (nonatomic,copy) NSString *bill_num;  //!<账务使用的订单编码
@property (nonatomic,copy) NSString *order_num; //!<订单编码

@property (nonatomic,copy) NSString *diet_num;  //!<订单的菜品数量

@end
