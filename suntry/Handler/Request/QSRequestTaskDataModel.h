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
    
    rRequestTypeDefault = 998,  //!<默认无效请求
    rRequestTypeDistrict = 999, //!<地区选择
    rRequestTypeSelect =1000,  //!<选择查询
    rRequestTypeAspecial =1001, //!<每日特价菜品
    rRequestTypeRandom      =1036,   //!<随机菜品
    rRequestTypeAllGoods    =1050,   //!<所有菜品
    rRequestTypeMaxLimited      //!<最大值限制
    
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
