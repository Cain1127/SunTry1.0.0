//
//  QScheckAppVersionViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWCheckAppVersionViewController.h"
#import "CommonHeader.h"

@interface QSWCheckAppVersionViewController ()

@end

@implementation QSWCheckAppVersionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    ///标题
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"检查更新"];
    self.navigationItem.titleView = navTitle;
    
    ///自定义返回按钮
    UIBarButtonItem *turnBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(turnBackAction)];
    turnBackButton.tintColor = [UIColor whiteColor];
    
    ///设置返回按钮的颜色
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = turnBackButton;
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    ///检查版本
    [self checkAppVersion];
    
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
            [self presentViewController:alertVC animated:YES completion:^{}];
            
        });
        
    });
    
}

#pragma mark - 返回事件
- (void)turnBackAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
