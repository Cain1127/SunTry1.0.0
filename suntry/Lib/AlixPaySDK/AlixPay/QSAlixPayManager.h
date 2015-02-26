//
//  QSAlixPayManager.h
//  Eating
//
//  Created by ysmeng on 14/12/2.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSOrderInfoDataModel.h"

//支付端抽象接口
@protocol QSAlixPayMethodDelegate <NSObject>

//可选方法
@optional

/**
 *  @author         yangshengmeng, 14-12-14 15:12:03
 *
 *                  通过支付宝进行支付，前提是提交一个有效的支付宝参数模型
 *
 *  @param params   订单数据：key-orderForm  回调block：key-callBack
 *
 *                  支付宝支付回调参数说明
 *                  9000---订单支付成功
 *                  8000---正在处理中
 *                  4000---订单支付失败
 *                  6001---用户中途取消
 *                  6002---网络连接出错
 *
 *  @since          2.0
 */
- (void)startAlixPay:(QSOrderInfoDataModel *)alixpayModel;

@end

@interface QSAlixPayManager : NSObject <QSAlixPayMethodDelegate>

///单例访问
+ (instancetype)shareAlixPayManager;

@end
