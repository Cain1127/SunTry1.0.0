//
//  QSAppDelegate.m
//  suntry
//
//  Created by ysmeng on 15/2/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAppDelegate.h"
#import "QSTabBarViewController.h"
#import "QSMapManager.h"
#import "QSRequestManager.h"
#import "QSDistrictReturnData.h"
#import "QSDistrictDataModel.h"
#import "QSSelectDataModel.h"
#import "QSSelectReturnData.h"
#import "CommonHeader.h"

#import <AlipaySDK/AlipaySDK.h>

#import "QSUserLoginReturnData.h"

@implementation QSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    QSTabBarViewController *main=[[QSTabBarViewController alloc]init];
    [self.window setRootViewController:main];
    [self.window makeKeyAndVisible];
    
    ///检查版本
    [self checkAppVersion];
    
    ///定位请求信息
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        ///获取用户地理位置
        QSMapManager *manager=[[QSMapManager alloc]init];
        
        ///定位用户经纬度回调
        [manager startUserLocation:^(BOOL isLocalSuccess, double longitude, double latitude) {
            
            if (isLocalSuccess) {
                
                NSLog(@"==============用户经纬度回调成功================");
                NSLog(@"%f,%f",latitude,longitude);
                
            }
            
        }];
        
        ///反地理编码回调用户地理位置
        [manager getUserLocation:^(BOOL isLocalSuccess, NSString *placename) {
            
            if (isLocalSuccess) {
                
                NSLog(@"=============用户地标回调成功====================");
                NSLog(@"%@",placename);
                
            }
            
        }];
        
    });
    
    ///判断是否已有用户信息:如果已有信息，则自动登录
    [self autoLogin];
    
    ///区请求信息
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        ///获取配置信息标记
        NSString *isSave = [[NSUserDefaults standardUserDefaults] valueForKey:@"is_loading_district"];
        
        //所有区信息
        if (!(1 == [isSave intValue])) {
            
            [self downloadDistrictInfo];
            
        }
        
        NSString *isSaveSelect = [[NSUserDefaults standardUserDefaults] valueForKey:@"is_loading_select"];
        if (!(1 == [isSaveSelect intValue])) {
            //天河区搜索信息
            [self downloadSelectInfo];
        }
        
    });
    
    return YES;
}

#pragma mark - 自动登录
- (void)autoLogin
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        ///获取本地登录信息
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_count"];
        NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
        
        if (nil == userName || [userName length] < 1) {
            
            return;
            
        }
        
        if (nil == pwd || [pwd length] < 2) {
            
            return;
            
        }
        
        ///封装登录参数
        NSDictionary *params = @{@"account" : userName,@"psw" : pwd,@"type" : @"1"};
        
        [QSRequestManager requestDataWithType:rRequestTypeLogin andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///判断是否登录成功
            if (rRequestResultTypeSuccess == resultStatus) {
                
                ///转换模型
                QSUserLoginReturnData *tempModel = resultData;
                
                ///保存到本地
                [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"user_count"];
                [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:@"pwd"];
                [[NSUserDefaults standardUserDefaults] setObject:tempModel.userInfo.userID forKey:@"user_id"];
                
                ///修改登录状态
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"is_login"];
                
                ///同步数据
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                ///把用信息coding在本地
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/user_info"];
                
                ///把地址信息coding在本地
                NSData *tempData = [NSKeyedArchiver archivedDataWithRootObject:tempModel.userInfo];
                [tempData writeToFile:path atomically:YES];
                
            } else {
                
                ///修改登录状态
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"is_login"];
                
                ///同步数据
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
        }];
        
    });
    
}

#pragma mark - 请求区信息
///请求区信息
- (void)downloadDistrictInfo
{
    
    [QSRequestManager requestDataWithType:rRequestTypeDistrict andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///模型转换
            QSDistrictReturnData *tempModel = resultData;
            
            ///保存数据
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/districtData"];
            
            ///首先转成data
            NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:tempModel];
            BOOL isSave = [saveData writeToFile:path atomically:YES];
            
            if (isSave) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"is_loading_district"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            } else {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"is_loading_district"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
            for (int i = 0; i < [tempModel.districtList count]; i++) {
                
                QSDistrictDataModel *districtModel = tempModel.districtList[i];
                
                
                NSLog(@"================区信息================");
                NSLog(@"ID : %@     显示名 : %@",districtModel.districtID,districtModel.val);
                NSLog(@"================区信息================");
                
            }
            
        } else {
            
            NSLog(@"================区信息请求失败================");
            NSLog(@"error : %@",errorInfo);
            NSLog(@"================区信息请求失败================");
            
        }
        
    }];
    
}

///街道查询信息请求
- (void)downloadSelectInfo
{
    
    ///街道搜索信息请求参数
    NSDictionary *dict = @{@"id" : @"3", @"key" : @"",@"status":@"0"};
    
    [QSRequestManager requestDataWithType:rRequestTypeSelect andParams:dict andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        ///判断是否请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///模型转换
            QSSelectReturnData *tempModel = resultData;
            
            ///保存数据
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/selectData"];
            
            ///首先转成data
            NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:tempModel];
            BOOL isSave = [saveData writeToFile:path atomically:YES];
            
            if (isSave) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"is_loading_select"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"========天河区数据保存成功=======");
                
            } else {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"is_loading_select"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"========天河区数据保存失败=======");
            }
            
            
            for (int i = 0; i < [tempModel.selectList count]; i++) {
                
                QSSelectDataModel *selectModel = tempModel.selectList[i];
                
                
                NSLog(@"================区信息================");
                NSLog(@"街道ID : %@     街道名 : %@   是否可配送 : %@",selectModel.streetID,selectModel.streetName,selectModel.isSend);
                NSLog(@"================区信息================");
                
            }
            
            
        } else {
            
            NSLog(@"================街道搜索信息请求失败================");
            NSLog(@"error : %@",errorInfo);
            NSLog(@"================街道搜索信息请求失败================");
            
        }
        
    }];
    
}

#pragma mark - 支付宝支付回调
///支付宝支付回调事件处理
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    ///如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            ///回调当前控制器
            NSLog(@"===============AlixPay=====================");
            NSLog(@"sefepay result = %@ safepay result = %@",[resultDic valueForKey:@"resultStatus"],resultDic);
            NSLog(@"===========================================");
            
            ///回调到当前的VC
            if (self.alixPayCallBack) {
                self.alixPayCallBack([resultDic valueForKey:@"resultStatus"],[resultDic valueForKey:@"memo"]);
            }
            
        }];
    }
    
    if ([url.host isEqualToString:@"platformapi"]){
        
        //支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            ///回调当前控制器
            NSLog(@"===============AlixPay=====================");
            NSLog(@"sefepay result = %@ safepay result = %@",[resultDic valueForKey:@"resultStatus"],resultDic);
            NSLog(@"===========================================");
            
#ifdef __SHOWALIXPAY_RESULT__
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"测试支付宝使用" message:[NSString stringWithFormat:@"信息：%@    错误编码：%@",[resultDic valueForKey:@"memo"],[resultDic valueForKey:@"resultStatus"]] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
#endif
            
            ///回调到当前的VC
            if (self.alixPayCallBack) {
                self.alixPayCallBack([resultDic valueForKey:@"resultStatus"],[resultDic valueForKey:@"memo"]);
            }
            
        }];
    }
    
    return YES;
}

#pragma mark - 检测版本更新
- (void)checkAppVersion
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ///获取本地版本
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
        
        ///获取appStore上的最新版本
        NSData *versionData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:QSGetAppStoreVersion]] returningResponse:nil error:nil];
        
        ///判断请求返回的数据
        if (nil == versionData || 0 >= [versionData length]) {
            
            return;
            
        }
        
        NSDictionary *originalDict = [NSJSONSerialization JSONObjectWithData:versionData options:NSJSONReadingMutableLeaves error:nil];
        
        ///判断是否获取版本信息成功
        if (nil == originalDict || 0>= [originalDict count]) {
            
            return;
            
        }
        
        NSDictionary *versionInfoDcit = [originalDict valueForKey:@"results"][0];
        
        ///判断版本信息字典是否有效
        if (nil == versionInfoDcit || 0 >= [versionInfoDcit count]) {
            
            return;
            
        }
        
        NSString *appStoreVersion = [versionInfoDcit valueForKey:@"version"];
        
        ///判断版本是否有效
        if (nil == appStoreVersion || 2 >= [appStoreVersion length]) {
            
            return;
            
        }
        
        ///对比版本信息
        NSMutableString *localVersion = [appVersion mutableCopy];
        NSMutableString *lastVersion = [appStoreVersion mutableCopy];
        
        ///替换小数点
        [localVersion replaceOccurrencesOfString:@"." withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, localVersion.length)];
        [lastVersion replaceOccurrencesOfString:@"." withString:@"" options:1 range:NSMakeRange(0, lastVersion.length)];
        
        ///判断版本大小
        int intLocalVersion = [localVersion intValue];
        int intLastVersion = [lastVersion intValue];
        
        if (intLastVersion <= intLocalVersion) {
            
            return;
            
        }
        
        ///有新版本，则提示是否更新
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"发现新版本 %@",appStoreVersion] preferredStyle:UIAlertControllerStyleAlert];
            
            ///确认事件
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"立即去更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com"]];
                
            }];
            
            ///取消事件
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                ///移聊提示
                [alertVC dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
            }];
            
            ///添加事件
            [alertVC addAction:confirmAction];
            [alertVC addAction:cancelAction];
            
            ///弹出说明框
            [self.window.rootViewController presentViewController:alertVC animated:YES completion:^{}];
            
        });
        
    });
    
}


@end
