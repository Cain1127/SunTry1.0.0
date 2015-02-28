//
//  QSWUserSettingViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWUserSettingViewController.h"
#import "QSWSettingCell.h"
#import "QSWSettingItem.h"
#import "QSWSettingGroup.h"
#import "QSWSettingArrowItem.h"
#import "DeviceSizeHeader.h"
#import "QSWTheSuntryView.h"
#import "QSWServiceTermViewController.h"

#import "MBProgressHUD.h"

@interface QSWUserSettingViewController ()

@property (nonatomic,retain) MBProgressHUD *hud;//!<内部使用的HUD

@end

@implementation QSWUserSettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    ///自定义返回按钮
    UIBarButtonItem *turnBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(turnBackAction)];
    turnBackButton.tintColor = [UIColor whiteColor];
    
    ///设置返回按钮的颜色
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = turnBackButton;
    
    ///标题
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"帐户设置"];
    self.navigationItem.titleView = navTitle;
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    
}

-(void)setupGroup0
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWSettingArrowItem *item = [QSWSettingArrowItem itemWithIcon:nil title:@"服务条款" destVcClass:[QSWServiceTermViewController class]];
    group.items = @[item];
    
}

-(void)setupGroup1
{
    
    QSWSettingGroup *group = [self addGroup];
    QSWSettingArrowItem *item = [QSWSettingArrowItem itemWithIcon:nil title:@"检查更新" destVcClass:nil];
    group.items = @[item];
    
}

-(void)setupGroup2
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWSettingArrowItem *item = [QSWSettingArrowItem itemWithIcon:nil title:@"关于香哉" destVcClass:[QSWTheSuntryView class]];
    group.items = @[item];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 1) {
        
        [self checkAppVersion];
        
    } else {
    
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    }
    
}

#pragma mark - 返回事件
- (void)turnBackAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 检测版本更新
- (void)checkAppVersion
{
    
    ///显示HUD
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ///获取本地版本
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    ///获取appStore上的最新版本
    NSURLRequest *tempRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUEST_ROOT_URL,REQUEST_VERSION_URL]]];
    NSData *versionData = [NSURLConnection sendSynchronousRequest:tempRequest
                                                returningResponse:nil error:nil];
    
    ///判断请求返回的数据
    if (nil == versionData || 0 >= [versionData length]) {
        
        return;
        
    }
    
    NSDictionary *originalDict = [NSJSONSerialization JSONObjectWithData:versionData options:NSJSONReadingMutableLeaves error:nil];
    
    ///判断是否获取版本信息成功
    if (nil == originalDict || 0>= [originalDict count]) {
        
        return;
        
    }
    
    NSDictionary *versionInfoDcit = [originalDict valueForKey:@"msg"];
    
    ///判断版本信息字典是否有效
    if (nil == versionInfoDcit || 0 >= [versionInfoDcit count]) {
        
        return;
        
    }
    
    NSString *appStoreVersion = [[versionInfoDcit valueForKey:@"iosversion"] substringFromIndex:1];
    
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
        
        ///隐藏HUD
        [self.hud hide:YES];
        
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:nil message:@"当前版本已是最新版本。" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [aler show];
        
        ///显示1秒后消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [aler dismissWithClickedButtonIndex:0 animated:YES];
            
        });
        
        return;
        
    }
    
    ///有新版本，则提示是否更新
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
    
    ///隐藏HUD
    [self.hud hide:YES];
    
    ///弹出说明框
    [self presentViewController:alertVC animated:YES completion:^{}];
    
}

@end
