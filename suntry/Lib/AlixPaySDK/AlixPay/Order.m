//
//  Order.m
//  suntry
//
//  Created by ysmeng on 15/2/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "Order.h"

@implementation Order

/**
 *  @author yangshengmeng, 15-02-26 14:02:16
 *
 *  @brief  重写description，拼装为订单字符串
 *
 *  @return 返回订单字符串
 *
 *  @since  1.0.0
 */
- (NSString *)description {
    
	NSMutableString * discription = [NSMutableString string];
    
    ///合作商户ID
    if (self.partner) {
        
        [discription appendFormat:@"partner=\"%@\"", self.partner];
        
    }
	
    ///商户进帐账号ID
    if (self.seller) {
        
        [discription appendFormat:@"&seller_id=\"%@\"", self.seller];
        
    }
    
    ///交易订单编码
	if (self.tradeNO) {
        
        [discription appendFormat:@"&out_trade_no=\"%@\"", self.tradeNO];
        
    }
    
    ///订单标题
	if (self.productName) {
        [discription appendFormat:@"&subject=\"%@\"", self.productName];
    }
	
    ///订单的描述
	if (self.productDescription) {
        
        [discription appendFormat:@"&body=\"%@\"", self.productDescription];
        
    }
    
    ///订单的交易金额
	if (self.amount) {
        
        [discription appendFormat:@"&total_fee=\"%@\"", self.amount];
        
    }
    
    ///支付成功后的回调地址
    if (self.notifyURL) {
        
        [discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL];
        
    }
	
    if (self.service) {
        
        [discription appendFormat:@"&service=\"%@\"",self.service];//mobile.securitypay.pay
        
    }
    
    if (self.paymentType) {
        
        [discription appendFormat:@"&payment_type=\"%@\"",self.paymentType];//1
        
    }
    
    if (self.inputCharset) {
        
        [discription appendFormat:@"&_input_charset=\"%@\"",self.inputCharset];//utf-8
        
    }
    
    if (self.itBPay) {
        
        [discription appendFormat:@"&it_b_pay=\"%@\"",self.itBPay];//30m
        
    }
    
    if (self.showUrl) {
        
        [discription appendFormat:@"&show_url=\"%@\"",self.showUrl];//m.alipay.com
        
    }
    
    if (self.rsaDate) {
        
        [discription appendFormat:@"&sign_date=\"%@\"",self.rsaDate];
        
    }
    
    if (self.appID) {
        
        [discription appendFormat:@"&app_id=\"%@\"",self.appID];
        
    }
    
	for (NSString * key in [self.extraParams allKeys]) {
        
		[discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
        
	}
    
	return discription;
    
}


@end
