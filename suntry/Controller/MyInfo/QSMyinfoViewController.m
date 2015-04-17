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

#define kCallAlertViewTag 111

///关联ios7电话
//static char titleLabelKey;//!<标题key

@interface QSMyinfoViewController ()

@property (nonatomic, copy) NSString *phoneNumber;                  //!<电话号码

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
    [footterButton addTarget:self action:@selector(customButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    ///footer
    UIView *footer = [[UIView alloc] init];
    CGFloat footerH = footterButtonH + 20.0f;
    footer.frame = CGRectMake(0, 0, 0, footerH);
    self.tableView.tableFooterView = footer;
    [footer addSubview:footterButton];
    
}

#pragma mark - 客服热线
///客服热线
- (void)customButtonClick:(id)sender
{
    
    [self makeCall:@"02037302282"];
    
}


#pragma mark - 打电话事件
- (void)makeCall:(NSString *)number
{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:[NSString stringWithFormat:@"呼叫 %@",number] delegate:self
                                                  cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
        alertView.tag = kCallAlertViewTag;
        self.phoneNumber = number;
        [alertView show];
        return;
    
}

#pragma mark - 打电话代理事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == kCallAlertViewTag) {
        
        if (buttonIndex == 1) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phoneNumber]]];
            
        }
        
    }
    
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
            
            if (userModel.isBoughtStoreCard || [userModel.balance floatValue] > 0.1f) {
                
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