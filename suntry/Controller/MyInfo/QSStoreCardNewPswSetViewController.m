//
//  QSStoreCardNewPswSetViewController.m
//  suntry
//
//  Created by ysmeng on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSStoreCardNewPswSetViewController.h"

#import "CommonHeader.h"
#import "ColorHeader.h"
#import "DeviceSizeHeader.h"

#import "QSRequestManager.h"
#import "QSUserManager.h"
#import "QSUserInfoDataModel.h"

#import "QSBlockButton.h"

#import "MBProgressHUD.h"

@interface QSStoreCardNewPswSetViewController () <UITextFieldDelegate>

@property (nonatomic,copy) NSString *phone;       //!<手机号码
@property (nonatomic,copy) NSString *code;        //!<验证码
@property (nonatomic,retain) MBProgressHUD *hud;  //!<HUD

@end

@implementation QSStoreCardNewPswSetViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-02 18:03:30
 *
 *  @brief          根据手机号码和验证码，更新储值卡支付密码
 *
 *  @param phone    手机号码
 *  @param vercode  验证码
 *
 *  @return         返回更新密码页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPhone:(NSString *)phone andVerticode:(NSString *)vercode
{

    if (self = [super init]) {
        
        self.phone = phone;
        self.code = vercode;
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    ///导航栏底view
    UIImageView *navRootView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 64.0f)];
    navRootView.image = [UIImage imageNamed:@"nav_backgroud"];
    navRootView.userInteractionEnabled = YES;
    [self.view addSubview:navRootView];
    
    ///标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(navRootView.frame.size.width / 2.0f - 60.0f, 27.0f, 120.0f, 30.0f)];
    titleLabel.text = @"忘记密码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [navRootView addSubview:titleLabel];
    
    ///自定义返回按钮
    UIButton *turnBackButton = [UIButton createBlockButtonWithFrame:CGRectMake(5.0f, 20.0f, 44.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///返回
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    ///设置返回按钮的颜色
    [turnBackButton setImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal];
    [turnBackButton setImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted];
    [navRootView addSubview:turnBackButton];
    
    ///新密码输入框
    __block UITextField *newpswField = [[UITextField alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, navRootView.frame.origin.y + navRootView.frame.size.height + 8.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f)];
    newpswField.borderStyle = UITextBorderStyleRoundedRect;
    newpswField.placeholder = @"新的支付密码";
    newpswField.delegate = self;
    newpswField.secureTextEntry = YES;
    [self.view addSubview:newpswField];
    
    ///确认密码输入框
    __block UITextField *confirmpswField = [[UITextField alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, newpswField.frame.origin.y + newpswField.frame.size.height + 8.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f)];
    confirmpswField.borderStyle = UITextBorderStyleRoundedRect;
    confirmpswField.placeholder = @"再次确认您的支付密码";
    confirmpswField.delegate = self;
    confirmpswField.secureTextEntry = YES;
    [self.view addSubview:confirmpswField];
    
    ///提交按钮
    UIButton *confirmButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, confirmpswField.frame.origin.y + confirmpswField.frame.size.height + 8.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///新的密码
        NSString *newpsw = newpswField.text;
        NSString *confirmpsw = confirmpswField.text;
        
        ///判断数据
        if (nil == newpsw || 0 >= newpsw) {
            
            [newpswField becomeFirstResponder];
            return;
            
        }
        
        if (nil == confirmpsw || 0 >= confirmpsw) {
            
            [confirmpswField becomeFirstResponder];
            return;
            
        }
        
        ///校验两个密码是否一致
        if (![newpsw isEqualToString:confirmpsw]) {
            
            ///提示信息
            UIAlertView *aler = [[UIAlertView alloc] initWithTitle:nil message:@"两次输入的密码不一致，请重新输入。" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [aler show];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [aler dismissWithClickedButtonIndex:0 animated:YES];
                
            });
            
            return;
            
        }
        
        ///开始更新储值卡密码
        [self forgetStoreCardPsw:newpsw];
        
    }];
    [confirmButton setTitle:@"提交" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitleColor:COLOR_CHARACTERS_RED forState:UIControlStateHighlighted];
    confirmButton.layer.cornerRadius = 6.0f;
    confirmButton.backgroundColor = COLOR_CHARACTERS_RED;
    [self.view addSubview:confirmButton];
    
}

#pragma mark - 网络修改支付密码
///进行密码网络修改
- (void)forgetStoreCardPsw:(NSString *)newPsw
{
    
    self.hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ///请数
    NSDictionary *tempParams = @{@"phone" : self.phone,
                                 @"pay" : newPsw,
                                 @"type" : @"1",
                                 @"vcode" : self.code};
    
    ///开始请求
    [QSRequestManager requestDataWithType:rRequestTypeForgetStoredCardPsw andParams:tempParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否更新成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
//            ///弹出框
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"修改支付密码成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//            [alert show];
            self.hud.labelText=@"修改支付密码成功";
            
            ///刷新用户数据
            [QSUserManager updateUserData:nil];
            
            [self.hud hide:YES afterDelay:2.0f];
            
//            ///显示一秒
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                
//                [alert dismissWithClickedButtonIndex:0 animated:YES];
            
                ///返回上一级
                NSInteger sumVC = [self.navigationController.viewControllers count];
                UIViewController *tempVC = self.navigationController.viewControllers[sumVC - 3];
                if (tempVC) {
                    
                    [self.navigationController popToViewController:tempVC animated:YES];
                    
                } else {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                
//            });
        
        } else {
            
//            ///弹出框
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"修改支付密码失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//            [alert show];
//            
//            ///显示一秒
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                
//                [alert dismissWithClickedButtonIndex:0 animated:YES];
//                
//            });
            self.hud.labelText=@"修改支付密码失败";
            [self.hud hide:YES afterDelay:2.0f];
            
        }
        
    }];
    
}

#pragma mark - 回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
    
}

@end