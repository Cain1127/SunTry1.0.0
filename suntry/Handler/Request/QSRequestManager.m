//
//  QSRequestManager.m
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSRequestManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "QSDataMappingManager.h"

#import <CommonCrypto/CommonDigest.h>

///内部宏定义：自操作线程关键字
#define QUEUE_REQUEST_OPERATION "com.77tng.car.request"

@interface QSRequestManager ()

///网络请求管理器
@property (nonatomic,retain) AFHTTPRequestOperationManager *httpRequestManager;

///请求任务池：放置的对象为QSRequestTaskDataModel对象或它的子类
@property (nonatomic,retain) NSMutableArray *taskPool;

///请求任务处理使用的自定义线程
@property (nonatomic, strong) dispatch_queue_t requestOperationQueue;

@end

@implementation QSRequestManager

#pragma mark - ===============对象方法区域===============
//*****************************************************
//*****************************************************
//
//                      网络请求对象方法区域
//
//*****************************************************
//*****************************************************

#pragma mark - 返回网络请求的单例
/**
 *  @author yangshengmeng, 15-01-22 09:01:30
 *
 *  @brief  返回请求管理器的单例
 *
 *  @return 返回网格请求单例对象
 *
 *  @since  1.0.0
 */
+ (instancetype)shareRequestManager
{
    
    static QSRequestManager *requestManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        ///对象初始化
        requestManager = [[QSRequestManager alloc] init];
        
        ///成员变量、属性、其他初始化
        [requestManager initRequestManagerProperty];
        
    });
    
    return requestManager;
    
}

#pragma mark - 网络请求相关的属性/变量等初始化
///网络请求相关的属性/变量等初始化
- (void)initRequestManagerProperty
{
    
    ///网络请求管理器初始化
    self.httpRequestManager = [AFHTTPRequestOperationManager manager];
    self.httpRequestManager.responseSerializer.acceptableContentTypes = [self.httpRequestManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    ///任务池初始化
    self.taskPool = [[NSMutableArray alloc] init];
    
    ///请求任务操作线程初始化
    self.requestOperationQueue = dispatch_queue_create(QUEUE_REQUEST_OPERATION, DISPATCH_QUEUE_CONCURRENT);
    
    ///添加任务池观察
    [self addObserver:self forKeyPath:@"taskPool" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
}

#pragma mark - 任务池的添加/删除/返回
///添加一个网络请求任务
- (void)addRequestTaskToPool:(QSRequestTaskDataModel *)taskModel
{
    
    ///判断任务是否有效
    if (nil == taskModel) {
        
        return;
        
    }
    
    dispatch_barrier_async(self.requestOperationQueue, ^{
        
        ///查询原来是否已存在消息
        int i = 0;
        for (i = 0; i < _taskPool.count; i++) {
            
            QSRequestTaskDataModel *tempTaskModel = _taskPool[i];
            
            ///参数标识
            BOOL isParamsSame = tempTaskModel.requestParams == taskModel.requestParams;
            
            ///如果原来已有对应的消息，则不再添加
            if (isParamsSame &&
                (tempTaskModel.requestType == taskModel.requestType) &&
                ([tempTaskModel.requestURL isEqualToString:taskModel.requestURL]) &&
                (tempTaskModel.requestCallBack == taskModel.requestCallBack) &&
                ([tempTaskModel.dataMappingClass isEqualToString:taskModel.dataMappingClass])) {
                
                return;
                
            }
            
        }
        
        ///没有重复的，添加
        [[self mutableArrayValueForKey:@"taskPool"] addObject:taskModel];
        
    });
    
}

///从任务池中删除第一个任务
- (void)removeFirstObjectFromTaskPool
{
    
    ///如果任务池已为空，则不再删除
    if (0 >= [self.taskPool count]) {
        
        return;
        
    }
    
    ///在指定线程中删除元素
    dispatch_barrier_async(self.requestOperationQueue, ^{
        
        [[self mutableArrayValueForKey:@"taskPool"] removeObjectAtIndex:0];
        
    });
    
}

///获取第一个请求任务
- (QSRequestTaskDataModel *)getFirstObjectFromTaskPool
{
    
    if (0 >= [self.taskPool count]) {
        
        return nil;
        
    }
    
    NSArray *tempArray = [self getRequestTaskPool];
    
    return tempArray[0];
    
}

///返回当前所有的任务请求队列
- (NSArray *)getRequestTaskPool
{
    
    __block NSArray *tempArray = nil;
    
    dispatch_sync(self.requestOperationQueue, ^{
        
        tempArray = [NSArray arrayWithArray:_taskPool];
        
    });
    
    return tempArray;
    
}

#pragma mark - 任务池观察者回调
///任务池观察者回调：当任务池有数据变动时，此方法捕抓
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    ///观察是否清空
    if (0 >= [self.taskPool count]) {
        
        return;
        
    }
    
    ///如若还有请求任务，取第一个任务执行
    QSRequestTaskDataModel *requestTask = self.taskPool[0];
    if (requestTask.isCurrentRequest) {
        
        NSLog(@"====================当前网络请求请任务正在处理中==========");
        
    } else {
        
        requestTask.isCurrentRequest = YES;
        [self startRequestDataWithRequestTaskModel:requestTask];
        
    }
    
}

#pragma mark - http请求数据
///开始请求数据
- (void)startRequestDataWithRequestTaskModel:(QSRequestTaskDataModel *)taskModel
{
    
    ///根据请求任务中的请求类型，使用不同的请求
    if (rRequestHttpRequestTypeGet == taskModel.httpRequestType) {
        
        [self.httpRequestManager GET:taskModel.requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            ///转码
            NSString *tempString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
            
            [self handleRequestSuccess:responseObject andRespondData:[tempString dataUsingEncoding:NSUTF8StringEncoding] andTaskModel:taskModel];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            ///请求失败时处理失败回调
            [self handleRequestFail:error andFailCallBack:taskModel.requestCallBack];
            
        }];
        
        return;
        
    }
    
    ///POST请求
    if (rRequestHttpRequestTypePost == taskModel.httpRequestType) {
        
        ///请求参数
        NSDictionary *postParams = taskModel.requestParams ? [self postUserInfoParams:taskModel.requestParams] : [self postUserInfoParams];
        NSLog(@"================请求参数======================");
        NSLog(@"请求地址：%@     参数：%@",postParams,taskModel.requestURL);
        NSLog(@"================请求参数======================");
        [self.httpRequestManager POST:taskModel.requestURL parameters:postParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            ///转码
            NSString *tempString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
            
            ///请求成功
            [self handleRequestSuccess:responseObject andRespondData:[tempString dataUsingEncoding:NSUTF8StringEncoding] andTaskModel:taskModel];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            ///请求失败
            [self handleRequestFail:error andFailCallBack:taskModel.requestCallBack];
            
        }];
        
        return;
        
    }
    
}

///处理请求成功时的回调
- (void)handleRequestSuccess:(id)responseObject andRespondData:(NSData *)respondData andTaskModel:(QSRequestTaskDataModel *)taskModel
{
    
    ///重新持有任务模型
    __block QSRequestTaskDataModel *tempTaskModel = taskModel;
    
    ///先获取响应结果
    BOOL isServerRespondSuccess = [[responseObject valueForKey:@"type"] boolValue];
    
    if (isServerRespondSuccess) {
        
        ///解析数据
        [QSDataMappingManager analyzeDataWithData:respondData andMappingClass:tempTaskModel.dataMappingClass andMappingCallBack:^(BOOL mappingStatus, id mappingResult) {
            
            ///判断解析结果
            if (mappingStatus && mappingResult && taskModel.requestCallBack) {
                
                tempTaskModel.requestCallBack(rRequestResultTypeSuccess,mappingResult,nil,nil);
                
                [self removeFirstObjectFromTaskPool];
                
            } else {
                
                ///数据解析失败回调
                tempTaskModel.requestCallBack(rRequestResultTypeDataAnalyzeFail,nil,@"数据解析失败",@"1000");
                [self removeFirstObjectFromTaskPool];
                
            }
            
        }];
        
        
        
    } else {
        
        ///解析数据
        [QSDataMappingManager analyzeDataWithData:respondData andMappingClass:@"QSHeaderDataModel" andMappingCallBack:^(BOOL mappingStatus, id mappingResult) {
            
            ///判断解析结果
            if (mappingStatus && mappingResult && taskModel.requestCallBack) {
                
                tempTaskModel.requestCallBack(rRequestResultTypeFail,mappingResult,nil,nil);
                [self removeFirstObjectFromTaskPool];
                
            } else {
                
                ///数据解析失败回调
                tempTaskModel.requestCallBack(rRequestResultTypeDataAnalyzeFail,nil,@"数据解析失败",@"1000");
                [self removeFirstObjectFromTaskPool];
                
            }
            
        }];
        
    }
    
}

///处理请求失败时的回调
- (void)handleRequestFail:(NSError *)error andFailCallBack:(void(^)(REQUEST_RESULT_STATUS resultStatus,id resultData,NSString *errorInfo,NSString *errorCode))callBack
{
    
    if (callBack) {
        
        ///回调
        callBack(rRequestResultTypeBadNetworking,nil,[error.userInfo valueForKey:NSLocalizedDescriptionKey],[NSString stringWithFormat:@"%@%d",error.domain,(int)error.code]);
        
    }
    
    ///开启下一次的请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self removeFirstObjectFromTaskPool];
        
    });
    
}

#pragma mark - POST请求参数封装
- (NSDictionary *)getPostParamsWithRequestType:(REQUEST_TYPE)requestType
{
    
    ///返回默认的参数
    return [self postUserInfoParams];
    
}

///配置用户信息的post请求参数
- (NSDictionary *)postUserInfoParams
{
    
    ///获取用户ID
    NSString *userID = @"1";
    
    ///判断是否已登录
    NSString *isLogin = [[NSUserDefaults standardUserDefaults] valueForKey:@"is_login"];
    if ([isLogin intValue] == 1) {
        
        userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
        
    }
    
    return [self packPostParamsWithBody:@{@"device" : @"iOS",@"user_id" : userID}];
    
}

///配置用户信息，有其他参数的post请求参数
- (NSDictionary *)postUserInfoParams:(NSDictionary *)params
{
    
    NSMutableDictionary *tempParams = [params mutableCopy];
    [tempParams setObject:@"iOS" forKey:@"device"];
    
    ///获取用户ID
    NSString *userID = @"1";
    
    ///判断是否已登录
    NSString *isLogin = [[NSUserDefaults standardUserDefaults] valueForKey:@"is_login"];
    if ([isLogin intValue] == 1) {
        
        userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
        
    }
    
    [tempParams setObject:userID forKey:@"user_id"];
    return [self packPostParamsWithBody:tempParams];
    
}

///按给定的body参数，封装请求参数
- (NSDictionary *)packPostParamsWithBody:(NSDictionary *)bodyParams
{
    
    /**
     *  k: 加密后的字符串
     *  d:传递的数据
     *  t:访问接口的时间
     */
    
    ///时间戳
    NSString *t = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    ///参数体
    NSString *d;
    if ([NSJSONSerialization isValidJSONObject:bodyParams]) {
        
        NSError *error;
        NSData *bodyParamsData = [NSJSONSerialization dataWithJSONObject:bodyParams options:NSJSONWritingPrettyPrinted error:&error];
        d = [[NSString alloc] initWithData:bodyParamsData encoding:NSUTF8StringEncoding];
        
    }
    
    ///加密串封装
    NSString *k_key = [t stringByAppendingString:@"mmzybydxwdjcl"];
    NSString *k_temp = [d stringByAppendingString:k_key];
    NSString *k = [self paramsMD5Encryption:k_temp];
    
    ///参数
    NSMutableDictionary *resultTempDictionary = [[NSMutableDictionary alloc]init];
    [resultTempDictionary setValue:k forKey:@"k"];
    [resultTempDictionary setValue:d forKey:@"d"];
    [resultTempDictionary setValue:t forKey:@"t"];
    
    ///返回一个不可变参数列
    return [NSDictionary dictionaryWithDictionary:resultTempDictionary];
    
}

#pragma mark - MD5加密
///MD5加密请求参数
- (NSString *)paramsMD5Encryption:(NSString *)params
{
    
    const char *cStr = [params UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
}

#pragma mark - ===============类方法区域===============
//*****************************************************
//*****************************************************
//
//                      网络请求类方法区域
//
//*****************************************************
//*****************************************************

/**
 *  @author             yangshengmeng, 15-01-20 21:01:18
 *
 *  @brief              根据不同的请求类型，进行不同的请求，并返回对应的请求结果信息
 *
 *  @param requestType  请求类型
 *  @param callBack     请求结束时的回调
 *
 *  @since              1.0.0
 */
+ (void)requestDataWithType:(REQUEST_TYPE)requestType andCallBack:(void(^)(REQUEST_RESULT_STATUS resultStatus,id resultData,NSString *errorInfo,NSString *errorCode))callBack
{
    
    [self requestDataWithType:requestType andParams:nil andCallBack:callBack];
    
}

/**
 *  @author             yangshengmeng, 15-01-26 14:01:24
 *
 *  @brief              根据不同的请求类型和参数，进行网络请求
 *
 *  @param requestType  请求类型
 *  @param params       请求参数
 *  @param callBack     回调
 *
 *  @since              1.0.0
 */
+ (void)requestDataWithType:(REQUEST_TYPE)requestType andParams:(NSDictionary *)params andCallBack:(void(^)(REQUEST_RESULT_STATUS resultStatus,id resultData,NSString *errorInfo,NSString *errorCode))callBack
{
    
    ///判断类型是否准确
    if ((rRequestTypeDefault > requestType) || (rRequestTypeMaxLimited < requestType)) {
        
        if (callBack) {
            
            callBack(rRequestResultTypeError,nil,@"请求类型错误",nil);
            
        }
        
        return;
        
    }
    
    ///创建网络请求任务
    QSRequestTaskDataModel *requestTask = [[QSRequestTaskDataModel alloc] init];
    
    ///保存请求类型
    requestTask.requestType = requestType;
    
    ///保存回调
    if (callBack) {
        
        requestTask.requestCallBack = callBack;
        
    }
    
    ///获取请求地址
    NSString *requestURLString = [self getRequestURLWithRequestType:requestType];
    
    ///校验
    if ((nil == requestURLString) || (!([requestURLString hasPrefix:@"http://"]))) {
        
        if (callBack) {
            
            callBack(rRequestResultTypeURLError,nil,@"无法获取有效URL信息",nil);
            
        }
        
        return;
        
    }
    requestTask.requestURL = requestURLString;
    
    ///获取请求使用的数据解析对象名
    NSString *mappingClassName = [self getDataMappingObjectName:requestType];
    
    ///校验
    if ((nil == mappingClassName) ||
        (0 >= [mappingClassName length]) ||
        (!([NSClassFromString(mappingClassName) isSubclassOfClass:NSClassFromString(@"QSBaseModel")]))) {
        
        if (callBack) {
            
            callBack(rRequestResultTypeMappingClassError,nil,@"无效的mapping类",nil);
            
        }
        
        return;
        
    }
    
    requestTask.dataMappingClass = mappingClassName;
    
    ///返回请求类型
    requestTask.httpRequestType = [self getHttpRequestTypeWithType:requestType];
    requestTask.isCurrentRequest = NO;
    
    ///是否有请求参数
    if (params) {
        
        requestTask.requestParams = params;
        
    }
    
    ///添加请求任务
    [[self shareRequestManager] addRequestTaskToPool:requestTask];
    
}

#pragma mark - 返回不同请求的网络请求地址
///返回不同的请求类型的请求地址
+ (NSString *)getRequestURLWithRequestType:(REQUEST_TYPE)requestType
{
    
    NSDictionary *taskDictionary = [self getTaskInfoDictionaryWithRequsetType:requestType];
    
    ///校验
    if ((nil == taskDictionary) || (0 >= [taskDictionary count])) {
        
        return nil;
        
    }
    
    ///获取配置的类名
    NSString *urlString = [taskDictionary valueForKey:@"url"];
    
    return [NSString stringWithFormat:@"%@%@",REQUEST_ROOT_URL,urlString];
    
}

#pragma mark - 返回不同请求类型所使用的http请求类型
///返回不同请求类型所使用的http请求类型
+ (REQUEST_HTTPREQUEST_TYPE)getHttpRequestTypeWithType:(REQUEST_TYPE)taskType
{
    
    switch (taskType) {
            
            ///广州所有区的信息
        case rRequestTypeDistrict:
            
            return rRequestHttpRequestTypePost;
            
            break;
            
            ///街道查询的信息
          case rRequestTypeSelect:
            
            return rRequestHttpRequestTypePost;
            
            break;
            
            ///每日特价菜品的信息
          case rRequestTypeAspecial:
            
            return rRequestHttpRequestTypePost;
            
            break;
            
            ///注册的信息
        case rRequestTypeRegister:
            
            return rRequestHttpRequestTypePost;
            
            break;
            
            ///默认返回Post
        default:
            
            return rRequestHttpRequestTypePost;
            
            break;
    }
    
}

#pragma mark - 返回数据解析的类型
///返回每个请求类型的数据解析使用的类名
+ (NSString *)getDataMappingObjectName:(REQUEST_TYPE)requestType
{
    
    NSDictionary *taskDictionary = [self getTaskInfoDictionaryWithRequsetType:requestType];
    
    ///校验
    if ((nil == taskDictionary) || (0 >= [taskDictionary count])) {
        
        return nil;
        
    }
    
    ///获取配置的类名
    NSString *className = [taskDictionary valueForKey:@"class"];
    
    return className;
    
}

///返回给定类型的请求配置信息字典
+ (NSDictionary *)getTaskInfoDictionaryWithRequsetType:(REQUEST_TYPE)requestType
{
    
    NSDictionary *requestInfoDictionary = [self getRequestInfoDictionary];
    
    ///校验
    if ((nil == requestInfoDictionary) || (0 >= [requestInfoDictionary count])) {
        
        return nil;
        
    }
    
    ///请求关键字
    NSString *keyword = [NSString stringWithFormat:@"%d",requestType];
    
    ///获取配置的类名
    NSDictionary *taskDictionary = [requestInfoDictionary valueForKey:keyword];
    
    return taskDictionary;
    
}

#pragma mark - 返回网络请求的配置字典
///返回网络请求的配置字典
+ (NSDictionary *)getRequestInfoDictionary
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RequestInfo" ofType:@"plist"];
    
    return [NSDictionary dictionaryWithContentsOfFile:path];
    
}

@end
