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
@implementation QSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor whiteColor];
    
    QSTabBarViewController *main=[[QSTabBarViewController alloc]init];
    [self.window setRootViewController:main];
    
    [self.window makeKeyAndVisible];
    
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
    
    return YES;
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
