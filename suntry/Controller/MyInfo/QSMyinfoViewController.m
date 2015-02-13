//
//  QSMyinfoViewController.m
//  SunTry
//
//  Created by 王树朋 on 15/1/31.
//  Copyright (c) 2015年 wangshupeng. All rights reserved.
//

#import "QSMyinfoViewController.h"
#import "QSMapManager.h"
#import "QSMapNavigationViewController.h"
#import "QSWSettingGroup.h"
#import "QSWSettingCell.h"
#import "QSWSettingItem.h"
#import "QSWSettingArrowItem.h"
#import "QSWMySendAdsViewController.h"
#import "QSWMyCouponViewController.h"
#import "QSWUserSettingViewController.h"
#import "QSWMyStoredCardViewController.h"
#import "QSWLoginPswViewController.h"
#import "QSWAddSendAdsViewController.h"
#import "QSWTextFieldItem.h"
#import "QSWLoginViewController.h"

@interface QSMyinfoViewController ()

@end

@implementation QSMyinfoViewController

#pragma mark - UI搭建
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
    [self setupGroup4];
    [self setupGroup5];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem=backItem;
    backItem.title=@"";
    
}

-(void)setupGroup0
{
  
    QSWSettingGroup *group = [self addGroup];
    QSWSettingArrowItem *item = [QSWSettingArrowItem itemWithIcon:@"myinfo_sendads_normal" title:@"我的送餐地址" destVcClass:[QSWMySendAdsViewController class]];
    group.items = @[item];
    
}

-(void)setupGroup1
{

    QSWSettingGroup *group = [self addGroup];
    
    QSWSettingArrowItem *item = [QSWSettingArrowItem itemWithIcon:@"myinfo_coupon_normal" title:@"我的优惠券" destVcClass:[QSWMyCouponViewController class]];
    group.items = @[item];
    
}

-(void)setupGroup2
{
    
    QSWSettingGroup *group = [self addGroup];
    QSWSettingArrowItem *item = [QSWSettingArrowItem itemWithIcon:@"myinfo_storagecard_normal" title:@"我的储值卡" destVcClass:[QSWMyStoredCardViewController class]];
    group.items = @[item];

}

-(void)setupGroup3
{

    QSWSettingGroup *group = [self addGroup];
    
    QSWSettingArrowItem *item = [QSWSettingArrowItem itemWithIcon:@"myinfo_loginpsw_normal" title:@"登录密码" destVcClass:[QSWLoginPswViewController class]];
    group.items = @[item];
    
}

-(void)setupGroup4
{

    QSWSettingGroup *group = [self addGroup];
    QSWSettingArrowItem *item = [QSWSettingArrowItem itemWithIcon:@"myinfo_setting_normal" title:@"帐号设置" destVcClass:[QSWUserSettingViewController class]];
    group.items = @[item];

}

-(void)setupGroup5
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWSettingItem *item = [QSWSettingItem item];
    item.title=@"   香哉客户服务热线:4006780022";
    group.items = @[item];
    
}

#pragma mark - 点击某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row >= 4) {
        
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        
    }
    
    ///判断是否已经登录
    int isLogin = [[[NSUserDefaults standardUserDefaults] valueForKey:@"is_login"] intValue];
    
    if (1 == isLogin) {
        
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        
    } else {
    
        ///弹出登录框
        QSWLoginViewController *loginVC = [[QSWLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    
    }

}

@end
