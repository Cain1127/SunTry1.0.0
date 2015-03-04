//
//  QSResetStoreCardPaypswViewController.m
//  suntry
//
//  Created by ysmeng on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSResetStoreCardPaypswViewController.h"
#import "QSStoreCardForgetPswViewController.h"

#import "DeviceSizeHeader.h"
#import "ColorHeader.h"

#import "QSBlockButton.h"

#import "QSUserManager.h"
#import "QSUserInfoDataModel.h"

#import "QSRequestManager.h"

#import "MBProgressHUD.h"

@interface QSResetStoreCardPaypswViewController () <UITextFieldDelegate>

@property (nonatomic,strong) UITextField *originalPswInputField;    //!<原密码输入框
@property (nonatomic,strong) UITextField *pswInputField;            //!<新密码输入框
@property (nonatomic,strong) UITextField *confirmField;             //!<新的支付密码输入框
@property (nonatomic,strong) UIButton *resetButton;                 //!<重置按钮

@property (nonatomic,strong) QSUserInfoDataModel *userInfo;         //!<用户信息

@property (nonatomic,retain) MBProgressHUD *hud;                    //!<HUD

@end

@implementation QSResetStoreCardPaypswViewController

#pragma mark - UI搭建
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES];
    
    ///导航栏底view
    UIImageView *navRootView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 64.0f)];
    navRootView.image = [UIImage imageNamed:@"nav_backgroud"];
    navRootView.userInteractionEnabled = YES;
    [self.view addSubview:navRootView];
    
    ///标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(navRootView.frame.size.width / 2.0f - 60.0f, 27.0f, 120.0f, 30.0f)];
    titleLabel.text = @"新的支付密码";
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
    
    ///获取用户信息
    self.userInfo = [QSUserManager getCurrentUserData];
    
    ///起始坐标
    CGFloat ypoint = 72.0f;
    
    if (self.userInfo.pay_salt && [self.userInfo.pay_salt length] > 0) {
        
        ypoint = ypoint + 44.0f + 8.0f;
        
        ///原密码输入框
        self.originalPswInputField = [[UITextField alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 72.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f)];
        self.originalPswInputField.borderStyle = UITextBorderStyleRoundedRect;
        self.originalPswInputField.placeholder = @"您当前的支付密码";
        self.originalPswInputField.secureTextEntry = YES;
        self.originalPswInputField.delegate = self;
        [self.view addSubview:self.originalPswInputField];
        
    }
    
    ///新支付密码
    self.pswInputField = [[UITextField alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, ypoint, SIZE_DEFAULT_MAX_WIDTH, 44.0f)];
    self.pswInputField.borderStyle = UITextBorderStyleRoundedRect;
    self.pswInputField.placeholder = @"新的支付密码";
    self.pswInputField.secureTextEntry = YES;
    self.pswInputField.delegate = self;
    [self.view addSubview:self.pswInputField];
    
    ///确认密码输入框
    self.confirmField = [[UITextField alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.pswInputField.frame.origin.y + self.pswInputField.frame.size.height + 8.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f)];
    self.confirmField.borderStyle = UITextBorderStyleRoundedRect;
    self.confirmField.placeholder = @"再次确认您的支付密码";
    self.confirmField.secureTextEntry = YES;
    self.confirmField.delegate = self;
    [self.view addSubview:self.confirmField];
    
    ///重置按钮
    self.resetButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.confirmField.frame.origin.y + self.confirmField.frame.size.height + 25.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///首先回收键盘
        [self.originalPswInputField resignFirstResponder];
        [self.pswInputField resignFirstResponder];
        [self.confirmField resignFirstResponder];
        
        [self resetStoreCardPsw];
        
    }];
    [self.resetButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.resetButton setTitleColor:COLOR_CHARACTERS_RED forState:UIControlStateHighlighted];
    self.resetButton.backgroundColor = COLOR_CHARACTERS_RED;
    self.resetButton.layer.cornerRadius = 6.0f;
    [self.view addSubview:self.resetButton];
    
    ///忘记密码按钮
    UIButton *forgetPayPswButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.resetButton.frame.origin.y + self.resetButton.frame.size.height + 5.0f, 120.0f, 30.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///进入忘记密码页面
        QSStoreCardForgetPswViewController *resetPswVC = [[QSStoreCardForgetPswViewController alloc] init];
        [self.navigationController pushViewController:resetPswVC animated:YES];
        
    }];
    [forgetPayPswButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetPayPswButton setTitleColor:COLOR_CHARACTERS_ROOTLINE forState:UIControlStateNormal];
    [forgetPayPswButton setTitleColor:COLOR_CHARACTERS_RED forState:UIControlStateHighlighted];
    [self.view addSubview:forgetPayPswButton];
    
}

#pragma mark - 网络修改支付密码
///进行密码网络修改
- (void)resetStoreCardPsw
{
    
    ///当前输入的原密码
    NSString *originalPsw = @"";
    
    ///判断当前输入的原密码是否和原密码一致
    if (self.userInfo.pay_salt && [self.userInfo.pay_salt length] > 0) {
        
        ///当前输入的原密码
        originalPsw = self.originalPswInputField.text;
        
        if (nil == originalPsw || [originalPsw length] <= 0) {
            
            [self.originalPswInputField becomeFirstResponder];
            return;
            
        }
        
    }
    
    ///新密码
    NSString *newPsw = self.pswInputField.text;
    if (nil == newPsw || [newPsw length] <=0) {
        
        [self.pswInputField becomeFirstResponder];
        return;
        
    }
    
    ///确认密码
    NSString *confirmPsw = self.confirmField.text;
    if (nil == confirmPsw || [confirmPsw length] <= 0) {
        
        [self.confirmField becomeFirstResponder];
        return;
        
    }
    
    ///验证确认密码
    if (![newPsw isEqualToString:confirmPsw]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"两次输入的密码不一致" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        
        ///显示一秒
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            
        });
        
        return;
        
    }
    
    self.hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ///请数
    NSDictionary *tempParams = @{@"old_pay" : originalPsw,
                                 @"pay" : newPsw};
    
    ///开始请求
    [QSRequestManager requestDataWithType:rRequestTypeEditStoredCardPsw andParams:tempParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否更新成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            
            self.hud.labelText=@"更新支付密码成功";
            [self.hud hide:YES afterDelay:2.0f];
           
            ///刷新用户数据
            [QSUserManager updateUserData:nil];
            
                ///返回上一级
                [self.navigationController popViewControllerAnimated:YES];
            
        } else {
        
            self.hud.labelText=@"更新支付密码失败";
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
