//
//  QSAlixPayManager.m
//  Eating
//
//  Created by ysmeng on 14/12/2.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAlixPayManager.h"

#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "Order.h"

#import <objc/runtime.h>

///是否服务端签名控制宏
//#define __SERVER_SIGNED_ORDER__

@interface QSAlixPayManager ()

@end

static QSAlixPayManager *_alixPayManager = nil;
@implementation QSAlixPayManager

#pragma mark - 返回支付宝支付控制器
+ (instancetype)shareAlixPayManager
{

    if (nil == _alixPayManager) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            _alixPayManager = [[QSAlixPayManager alloc] init];
            
        });
        
    }
    
    return _alixPayManager;

}

//*********************************
//             运行时重定向方法
//*********************************
#pragma mark - 运行时重定向方法
//自身无法响应
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    
    NSMethodSignature *currentMethod = [super methodSignatureForSelector:aSelector];
    if ([NSStringFromSelector(aSelector) isEqualToString:@"startAlixPay:"]) {
        
        ///startAlixPay
        class_addMethod([self class], aSelector, (IMP)runtimeAlixPayIMP, "v@:QSOrderInfoDataModel");
        
    }
    
    return currentMethod;
    
}

//重定向
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    
    if ([self respondsToSelector:[anInvocation selector]]) {
        
        [anInvocation invokeWithTarget:self];
        
    } else {
        
        [super forwardInvocation:anInvocation];
        
    }
    
}

+ (BOOL)resolveInstanceMethod:(SEL)name
{
    
    return [super resolveInstanceMethod:name];
    
}

+ (BOOL)resolveClassMethod:(SEL)name
{
    
    return [super resolveClassMethod:name];
    
}

//**********************************
//             动态生成的接口原型
//**********************************
#pragma mark - 动态生成的接口原型
void runtimeAlixPayIMP(id _rec, SEL _cmd, QSOrderInfoDataModel *serverOrderModel)
{
    
#ifdef __SERVER_SIGNED_ORDER__
    NSString *signedString = serverOrderModel.signedRSAString;
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"SuntryAlixPayIdentifier";
    if (signedString != nil) {
        
        ///进入支付宝
        [[AlipaySDK defaultService] payOrder:signedString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            /**
             *
             *  支付返回信息说明：
             *                  memo：提示信息
             *                  resultStatus：操作返回的编码
             *                  result：支付结果，返回是一个字典
             *                          key:success value:false/true
             *
             *
             *  支付宝返回代码:
             *                  9000---订单支付成功
             *                  8000---正在处理中
             *                  4000---订单支付失败
             *                  6001---用户中途取消
             *                  6002---网络连接出错
             *
             */
            orderModel.alixpayCallBack([resultDic valueForKey:@"resultStatus"],[resultDic valueForKey:@"memo"]);
            
        }];
        
    }
#endif
    
#ifndef __SERVER_SIGNED_ORDER__
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    QSOrderInfoDataModel *orderModel = serverOrderModel;
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = orderModel.partner_id;
    order.seller = orderModel.seller_id;
    order.tradeNO = orderModel.order_num;       //订单编码（由商家自行制定）
    order.productName = orderModel.orderTitle;  //商品标题
    order.productDescription = orderModel.des;  //商品描述
    
    ///订单金额
    order.amount = orderModel.payPrice;
    order.notifyURL =  orderModel.notify_url; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"100m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"SuntryAlixPayIdentifier";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    NSString *priPKKey = [NSString stringWithString:serverOrderModel.priPKCS8Key];
    id <DataSigner> signer = CreateRSADataSigner(priPKKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            ///回调
            NSLog(@"========================支付结果======================\n%@",resultDic);
            if (serverOrderModel.alixpayCallBack) {
                
                serverOrderModel.alixpayCallBack([resultDic valueForKey:@"resultStatus"],[resultDic valueForKey:@"memo"]);
                
            }
            
        }];
        
    } else {
    
        if (serverOrderModel.alixpayCallBack) {
            
            serverOrderModel.alixpayCallBack(@"4000",@"订单有误，无法进入支付宝");
            
        }
    
    }
    
#endif
    
}

@end