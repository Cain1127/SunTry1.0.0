//
//  QSOrderDetailDataModel.h
//  suntry
//
//  Created by CoolTea on 15/2/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"
#import "QSOrderDetailGoodsDataModel.h"

@interface QSOrderDetailDataModel : QSBaseModel

@property (nonatomic,copy) NSString *order_id;      //!<订单ID
@property (nonatomic,copy) NSString *order_num;     //!<订单唯一编号
@property (nonatomic,copy) NSString *bill_id;       //!<账单id
@property (nonatomic,copy) NSString *order_status;  //!<订单状态 '-1'=>'删除','0'=>'未确认','1'=>'确认','3'=>'送达','4'=>'取消'
@property (nonatomic,copy) NSString *total_money;   //!<订单全部金额
@property (nonatomic,copy) NSString *add_time;      //!<提交订单时间
@property (nonatomic,copy) NSString *order_name;    //!<订单的人名字
@property (nonatomic,copy) NSString *order_address; //!<订单的人地址
@property (nonatomic,copy) NSString *order_phone;   //!<订单的人手机号码
@property (nonatomic,copy) NSString *order_desc;    //!<订单的人留的描述
@property (nonatomic,copy) NSString *order_payment; //!<支付方式 3，余额支付；1在线支付，2餐到付款 ,5 储蓄卡购买的支付类型
@property (nonatomic,copy) NSString *diet_num;      //!<菜品数量
@property (nonatomic,copy) NSString *is_pay;        //!<是否已经支付 支付状态。。 0未支付，1支付成功
@property (nonatomic,copy) NSString *verification;   //!<验证码
@property (nonatomic,copy) NSString *order_shippingState;   //!<配送状态

@property (nonatomic,copy) NSArray  *goods_list;    //!<菜品数据列表
//@property (nonatomic,copy) NSArray  *counpon_list;    //!<优惠数据列表  //TODO: 优惠券数据需和接口数据完成后对接


@end
