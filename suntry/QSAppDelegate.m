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

@implementation QSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    QSTabBarViewController *main=[[QSTabBarViewController alloc]init];
    [self.window setRootViewController:main];
    
    [self.window makeKeyAndVisible];
    
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
    //街道搜索信息请求参数
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


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
