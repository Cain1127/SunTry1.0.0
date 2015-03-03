//
//  QSRequestTaskDataModel.h
//  House
//
//  Created by ysmeng on 15/1/22.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

///当前网络请求返回的标识
typedef enum
{
    
    rRequestResultStatusDefault = 0,    //!<默认返回
    rRequestResultTypeSuccess,          //!<请求成功/解析成功
    rRequestResultTypeFail,             //!<服务端返回false
    rRequestResultTypeDataAnalyzeFail,  //!<请求成功/解析失败
    
    rRequestResultTypeError,            //!<请求类型错误
    rRequestResultTypeURLError,         //!<请求任务的URL有误
    rRequestResultTypeMappingClassError,//!<数据解析时，mapping错误
    
    rRequestResultTypeBadNetworking,    //!<当前网络不稳定
    
}REQUEST_RESULT_STATUS;

///网络请求类型
typedef enum
{
    
    rRequestTypeDefault = 998,                  //!<默认无效请求
    rRequestTypeDistrict = 999,                 //!<地区选择
    rRequestTypeSelect = 1000,                  //!<选择查询
    rRequestTypeAspecial = 1001,                //!<每日特价菜品
    rRequestTypeRandom = 1036,                  //!<随机菜品
    rRequestTypeAllGoods = 1050,                //!<所有菜品
    
    rRequestTypeCarPostion =1006,               //!<餐车地址
    
    rRequestTypeBanner = 1023,                  //!添加首页广告

    rRequestTypeLogin = 1002,                   //!<登录
    rRequestTypeReloadUserData = 1003,          //!<重新下载用户信息
    rRequestTypeRegister = 1102,                //!<注册
    
    rRequestTypeStoredCard = 1042,              //!<储值卡
    rRequestTypeAddOrder = 1043,                //!<添加订单
    rRequestTypeCommitOrderPayResult = 1044,    //!<确认订单支付结果
    rRequestTypeEditStoredCardPsw = 1045,       //!<储值卡支付密码修改
    rRequestTypeForgetStoredCardPsw = 1046,     //!<忘记储值卡密码后通过手机重置
    
    rRequestTypeUserSendAddressList = 1100,     //!<当前用户的送餐地址列表
    rRequestTypeAddSendAddress = 1101,          //!<添加送餐地址
    rRequestTypeDelSendAddress = 1055,          //!<删除送餐地址
    
    rRequestTypeUserCouponList = 1103,          //!<个人优惠券列表
    rRequestTypeUserGetCoupon = 1104,           //!<根据key获取优惠券
    rRequestTypeUserResetPassword = 1105,       //!<忘记密码
    rRequestTypeUserForgetPassword = 1106,      //!<重置密码
    rRequestTypeGetVertification = 1107,        //!<获取验证码
    
    rRequestTypePayJudgeBalanceData = 1143,     //!<储值卡支付
    rRequestTypeOrderListData = 1021,           //!<订单列表
    rRequestTypeOrderDetailData = 1122,         //!<订单详情
    
    rRequestTypeConfigInfoDataList = 1060,      //!<配置信息
    
    rRequestTypeMaxLimited = 99999              //!<最大值限制
    
}REQUEST_TYPE;

///网络请求类型
typedef enum
{
    
    rRequestHttpRequestTypeGet = 0, //!<Get请求
    rRequestHttpRequestTypePost     //!<Post请求
    
}REQUEST_HTTPREQUEST_TYPE;

/**
 *  @author yangshengmeng, 15-01-22 10:01:11
 *
 *  @brief  所有网络请求任务的数据模型
 *
 *  @since  1.0.0
 */
@interface QSRequestTaskDataModel : NSObject

@property (nonatomic,assign) BOOL isCurrentRequest;                     //!<当前请求任务的状态：YES-正在请求中
@property (nonatomic,assign) REQUEST_TYPE requestType;                  //!<请求类型
@property (nonatomic,assign) REQUEST_HTTPREQUEST_TYPE httpRequestType;  //!<http请求时的类型
@property (nonatomic,copy) NSString *requestURL;                        //!<请求地址
@property (nonatomic,copy) NSString *dataMappingClass;                  //!<数据解析对应的类名
@property (nonatomic,retain) NSDictionary *requestParams;               //!<附加的请求参数

@property (nonatomic,copy) void(^requestCallBack)(REQUEST_RESULT_STATUS resultStatus,id resultData,NSString *errorInfo,NSString *errorCode);                            //!<请求后的回调

@end
