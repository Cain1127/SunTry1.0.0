//
//  QSStoreCardForgetPswViewController.m
//  suntry
//
//  Created by ysmeng on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSStoreCardForgetPswViewController.h"

#import "ColorHeader.h"
#import "DeviceSizeHeader.h"

#import "NSString+Format.h"

#import "QSBlockButton.h"

#import "QSStoreCardNewPswSetViewController.h"

#import "QSUserManager.h"
#import "QSRequestManager.h"

#import "QSCommonStringReturnData.h"
#import "QSUserInfoDataModel.h"

#import "MBProgressHUD.h"

@interface QSStoreCardForgetPswViewController () <UITextFieldDelegate>

@property (nonatomic,retain) QSUserInfoDataModel *userInfo; //!<用户信息

@property (nonatomic,strong) UITextField *phoneField;       //!<手机输入框
@property (nonatomic,strong) UITextField *verticodeField;   //!<验证码输入框
@property (nonatomic,copy) NSString *code;                  //!<验证码

@property (nonatomic,retain) MBProgressHUD *hud;            //!<HUD

@end

@implementation QSStoreCardForgetPswViewController

#pragma mark - UI搭建
///UI搭建
- (void)viewDidLoad
{

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
    
    ///获取用户信息
    self.userInfo = [QSUserManager getCurrentUserData];
    
    ///手机号
    self.phoneField = [[UITextField alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 72.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f)];
    self.phoneField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneField.placeholder = @"输入您的手机号码";
    if (self.userInfo.phone && [self.userInfo.phone length] == 11) {
        
        self.phoneField.text = self.userInfo.phone;
        
    }
    self.phoneField.delegate = self;
    [self.view addSubview:self.phoneField];
    
    ///激活码
    self.verticodeField = [[UITextField alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.phoneField.frame.origin.y + self.phoneField.frame.size.height + 8.0f, SIZE_DEFAULT_MAX_WIDTH - 80.0f, 44.0f)];
    self.verticodeField.borderStyle = UITextBorderStyleRoundedRect;
    self.verticodeField.placeholder = @"激活码";
    self.verticodeField.delegate = self;
    [self.view addSubview:self.verticodeField];
    
    ///获取激活码按钮
    UIButton *getVercodeButton = [UIButton createBlockButtonWithFrame:CGRectMake(self.verticodeField.frame.size.width + self.verticodeField.frame.origin.x + 5.0f, self.verticodeField.frame.origin.y, 75.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///验证手机号码
        if ([NSString isValidateMobile:self.phoneField.text]) {
            
            ///获取验证码
            [self getVertificationCode:self.phoneField.text];
            
        } else {
        
            [self.phoneField becomeFirstResponder];
        
        }
        
    }];
    [getVercodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVercodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getVercodeButton setTitleColor:COLOR_CHARACTERS_RED forState:UIControlStateHighlighted];
    getVercodeButton.layer.cornerRadius = 6.0f;
    getVercodeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    getVercodeButton.backgroundColor = COLOR_CHARACTERS_ROOTLINE;
    [self.view addSubview:getVercodeButton];
    
    ///提交按钮
    UIButton *commitButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.verticodeField.frame.origin.y + self.verticodeField.frame.size.height + 25.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///输入的验证码
        NSString *inputVercode = self.verticodeField.text;
        
        ///验证码校验
        if (!(inputVercode &&
              ([inputVercode length] > 0) &&
              (NSOrderedSame == [inputVercode compare:self.code options:NSCaseInsensitiveSearch]))) {
            
            UIAlertView *aler = [[UIAlertView alloc] initWithTitle:nil message:@"验证码不正确，请核对后再提交！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [aler show];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [aler dismissWithClickedButtonIndex:0 animated:YES];
                
            });
            return;
            
        }
        
        ///校验通过后，进行密码修改
        [self updateStoreCardPayPassword];
        
    }];
    [commitButton setTitle:@"下一步" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton setTitleColor:COLOR_CHARACTERS_RED forState:UIControlStateHighlighted];
    commitButton.backgroundColor = COLOR_CHARACTERS_RED;
    commitButton.layer.cornerRadius = 6.0f;
    [self.view addSubview:commitButton];

}

#pragma mark - 更新储值卡的支付密码
///更新储值卡的支付密码
- (void)updateStoreCardPayPassword
{

    ///保存手机号码
    NSString *phone = self.phoneField.text;
    
    ///判断手机号
    if (![NSString isValidateMobile:phone]) {
        
        [self.phoneField becomeFirstResponder];
        return;
        
    }
    
    ///判断验证码
    NSString *inputVercode = self.verticodeField.text;
    if (nil == inputVercode || 0 >= inputVercode) {
        
        [self.verticodeField becomeFirstResponder];
        return;
        
    }
    
    if (!(inputVercode &&
          ([inputVercode length] > 0) &&
          (NSOrderedSame == [inputVercode compare:self.code options:NSCaseInsensitiveSearch]))) {
        
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:nil message:@"验证码不正确，请核对后再提交！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [aler show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [aler dismissWithClickedButtonIndex:0 animated:YES];
            
        });
        return;
        
    }
    
    ///进入密码重置页面
    QSStoreCardNewPswSetViewController *VC = [[QSStoreCardNewPswSetViewController alloc] initWithPhone:phone andVerticode:inputVercode];
    [self.navigationController pushViewController:VC animated:YES];

}

#pragma mark - 获取验证码
///获取验证码
- (void)getVertificationCode:(NSString *)phone
{
    
    ///显示HUD
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [QSRequestManager requestDataWithType:rRequestTypeGetVertification andParams:@{@"phone" : phone} andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///发送成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSCommonStringReturnData *tempModel = resultData;
            self.code = tempModel.verticode;
            self.hud.labelText = @"发送成功";
            NSLog(@"=================手机验证码====================");
            NSLog(@"手机验证码：%@",self.code);
            NSLog(@"=================手机验证码====================");
            [self.hud hide:YES afterDelay:0.6f];
            
        } else {
            
            QSHeaderDataModel *tempModel = resultData;
            self.hud.labelText = tempModel ? ([tempModel.info length] > 0 ? tempModel.info : @"手机验证码发送失败，请稍后再试……") : @"手机验证码发送失败，请稍后再试……";
            [self.hud hide:YES afterDelay:0.6f];
            
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
