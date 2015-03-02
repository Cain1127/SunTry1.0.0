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
#import "QSWStoredCardViewController.h"
#import "QSWLoginPswViewController.h"
#import "QSWAddSendAdsViewController.h"
#import "QSWTextFieldItem.h"
#import "QSWLoginViewController.h"
#import "DeviceSizeHeader.h"
#import "ColorHeader.h"
#import "QSStoredCardDataModel.h"
#import "QSUserStoredCardReturnData.h"
#import "QSRequestManager.h"
#import "QSRequestTaskDataModel.h"
#import "QSUserStoredCardReturnData.h"
#import "MJRefresh.h"
#import "QSUserInfoDataModel.h"

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
    [self setupFooter];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem=backItem;
    backItem.title=@"";
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"我的"];
    self.navigationItem.titleView = navTitle;
    
}

///每一组cell
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

///脚部view
- (void)setupFooter
{
    
    ///按钮
    UIButton *footterButton = [[UIButton alloc] init];
    CGFloat footterButtonX = SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 2;
    CGFloat footterButtonY = 10;
    CGFloat footterButtonW = self.tableView.frame.size.width - 2 * footterButtonX;
    CGFloat footterButtonH = 44;
    footterButton.frame = CGRectMake(footterButtonX, footterButtonY, footterButtonW, footterButtonH);
    
    ///背景和文字
    footterButton.backgroundColor = [UIColor colorWithRed:247.0f / 255.0f green:243.0f / 255.0f blue:245.0f / 255.0f alpha:1.0f];
    [footterButton setTitle:@"   香哉客户服务热线:02037302282" forState:UIControlStateNormal];
    footterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [footterButton setTitleColor:COLOR_CHARACTERS_RED forState:UIControlStateNormal];
    footterButton.layer.cornerRadius = 6.0f;
    [footterButton addTarget:self action:@selector(makeCall:) forControlEvents:UIControlEventTouchUpInside];
    
    ///footer
    UIView *footer = [[UIView alloc] init];
    CGFloat footerH = footterButtonH + 20.0f;
    footer.frame = CGRectMake(0, 0, 0, footerH);
    self.tableView.tableFooterView = footer;
    [footer addSubview:footterButton];
    
}

#pragma mark - 打电话事件
- (void)makeCall:(NSString *)number
{
    
    ///电话弹出框
    __block UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"呼叫 %@",@"02037302282"] preferredStyle:UIAlertControllerStyleAlert];
    
    ///确认事件
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        ///打电话
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"02037302282"]]];
        
        ///隐藏确认框
        [alertVC dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    ///取消事件
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        ///移聊提示
        [alertVC dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }];
    
    ///添加事件
    [alertVC addAction:cancelAction];
    [alertVC addAction:confirmAction];
    
    ///弹出说明框
    [self presentViewController:alertVC animated:YES completion:^{}];
    
}


#pragma mark - 点击某一行事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///判断是否已经登录
    int isLogin = [[[NSUserDefaults standardUserDefaults] valueForKey:@"is_login"] intValue];
    
    if (1 == isLogin) {
        
        ///获取用户模型
        QSUserInfoDataModel *userModel = [QSUserInfoDataModel userDataModel];
        
        if (2 == indexPath.section) {
            
            if (userModel.isBoughtStoreCard) {
                
                QSWStoredCardViewController *storeCardVC = [[QSWStoredCardViewController alloc] init];
                storeCardVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:storeCardVC animated:YES];
                
            } else {
            
                QSWMyStoredCardViewController *myStoreCardVC = [[QSWMyStoredCardViewController alloc] init];
                myStoreCardVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myStoreCardVC animated:YES];
            
            }
            
        } else {
        
            [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        
        }
        
    } else {
    
        ///弹出登录框
        QSWLoginViewController *loginVC = [[QSWLoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    
    }

}

@end