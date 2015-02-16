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

@interface QSMyinfoViewController ()

///当前用户的储值卡信息
@property (nonatomic,retain) QSUserStoredCardReturnData *storeCarDataModel;

@end

@implementation QSMyinfoViewController

#pragma mark - UI搭建
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self getStoredCardList];
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
    [self setupGroup4];
    [self setupFooter];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem=backItem;
    backItem.title=@"";
    
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
    [footterButton setTitle:@"   香哉客户服务热线:4006780022" forState:UIControlStateNormal];
    footterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [footterButton setTitleColor:COLOR_CHARACTERS_RED forState:UIControlStateNormal];
    footterButton.layer.cornerRadius = 6.0f;
    
    ///footer
    UIView *footer = [[UIView alloc] init];
    CGFloat footerH = footterButtonH + 20;
    footer.frame = CGRectMake(0, 0, 0, footerH);
    self.tableView.tableFooterView = footer;
    [footer addSubview:footterButton];
    
}


#pragma mark - 点击某一行事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section >= 4) {
        
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        
    }
    
    ///判断是否已经登录
    int isLogin = [[[NSUserDefaults standardUserDefaults] valueForKey:@"is_login"] intValue];
    
    if (1 == isLogin) {
        
        if (2 == indexPath.section) {
            
            if ([self.storeCarDataModel.storedCardListData.storedCardList count] > 0) {
                
                QSWStoredCardViewController *storeCardVC = [[QSWStoredCardViewController alloc] init];
                [self.navigationController pushViewController:storeCardVC animated:YES];
                
            } else {
            
                QSWMyStoredCardViewController *myStoreCardVC = [[QSWMyStoredCardViewController alloc] init];
                [self.navigationController pushViewController:myStoreCardVC animated:YES];
            
            }
            
        } else {
        
            [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        
        }
        
    } else {
    
        ///弹出登录框
        QSWLoginViewController *loginVC = [[QSWLoginViewController alloc] init];
        loginVC.loginSuccessCallBack = ^(BOOL flag){
        
            if (flag) {
                
                [self getStoredCardList];
                
            }
        
        };
        [self.navigationController pushViewController:loginVC animated:YES];
    
    }

}

#pragma mark --获取网络数据
-(void)getStoredCardList
{
    
    ///判断是否已登录
    NSString *isLogin = [[NSUserDefaults standardUserDefaults] valueForKey:@"is_login"];
    if (!([isLogin intValue] == 1)) {
        
        return;
        
    }
    
    //每日特价信息请求参数
    NSDictionary *dict = @{@"type" : @"", @"key" : @"",@"flag":@"income"};
    
    [QSRequestManager requestDataWithType:rRequestTypeStoredCard andParams:dict andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            //模型转换
            QSUserStoredCardReturnData *tempModel = resultData;
            
            ///暂存储值卡模型
            self.storeCarDataModel = tempModel;
            
        } else {
            
            NSLog(@"================储值卡信息下载失败================");
            NSLog(@"error : %@",errorInfo);
            NSLog(@"================储值卡信息下载失败================");
            
        }
        
    }];
    
}


@end
