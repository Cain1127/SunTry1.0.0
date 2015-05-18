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
#import "ImageHeader.h"

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

@property (nonatomic,strong) UIButton *getVercodeButton;    //!<获取验证码按钮
@end

@implementation QSStoreCardForgetPswViewController

#pragma mark - UI搭建
///UI搭建
- (void)viewDidLoad
{

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"新的支付密码"];
    self.navigationItem.titleView = navTitle;
    
    QSBlockButtonStyleModel *backButtonStyle = [[QSBlockButtonStyleModel alloc] init];
    [backButtonStyle setImagesNormal:IMAGE_NAVIGATIONBAR_BACK_NORMAL];
    [backButtonStyle setImagesHighted:IMAGE_NAVIGATIONBAR_MEINFO_HIGHLIGHTED];
    
    UIButton *backButton = [UIButton createBlockButtonWithFrame:CGRectMake(0, 0, 44, 44) andButtonStyle:backButtonStyle andCallBack:^(UIButton *button) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    ///获取用户信息
    self.userInfo = [QSUserManager getCurrentUserData];
    
    ///手机号
    self.phoneField = [[UITextField alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, (iOS7 ? 72.0f : 8.0f), SIZE_DEFAULT_MAX_WIDTH, 44.0f)];
    self.phoneField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneField.placeholder = @"输入您的手机号码";
    self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
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
    self.verticodeField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.verticodeField];
    
    ///获取激活码按钮
    _getVercodeButton = [UIButton createBlockButtonWithFrame:CGRectMake(self.verticodeField.frame.size.width + self.verticodeField.frame.origin.x + 5.0f, self.verticodeField.frame.origin.y, 75.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        _getVercodeButton.userInteractionEnabled = NO;
        
        ///回收键盘
        [self.phoneField resignFirstResponder];
        [self.verticodeField resignFirstResponder];
        
        ///显示HUD
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        ///验证手机号码
        if ([NSString isValidateMobile:self.phoneField.text]) {
            
            ///获取验证码
            [self getVertificationCode:self.phoneField.text];
            
        } else {
        
            self.hud.labelText = @"手机号码无效，请重新输入";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.hud hide:YES];
                [self.phoneField becomeFirstResponder];
                
            });
            _getVercodeButton.userInteractionEnabled = YES;
        }
        
    }];
    [_getVercodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVercodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getVercodeButton setTitleColor:COLOR_CHARACTERS_RED forState:UIControlStateHighlighted];
    _getVercodeButton.layer.cornerRadius = 6.0f;
    _getVercodeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _getVercodeButton.backgroundColor = COLOR_CHARACTERS_YELLOW;
    [self.view addSubview:_getVercodeButton];
    
    ///提交按钮
    UIButton *commitButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.verticodeField.frame.origin.y + self.verticodeField.frame.size.height + 25.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///回收键盘
        [self.phoneField resignFirstResponder];
        [self.verticodeField resignFirstResponder];
        
        ///显示HUD
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        ///输入的验证码
        NSString *inputVercode = self.verticodeField.text;
        
        ///验证码校验
        if (!(inputVercode &&
              ([inputVercode length] > 0) &&
              (NSOrderedSame == [inputVercode compare:self.code options:NSCaseInsensitiveSearch]))) {
            
            self.hud.labelText = @"验证码不正确，请核对后再提交！";
            [self.hud hide:YES afterDelay:1.0f];
            
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
        
        self.hud.labelText = @"请输入有效的手机号码";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.hud hide:YES];
            [self.phoneField becomeFirstResponder];
            
        });
        
        return;
        
    }
    
    ///判断验证码
    NSString *inputVercode = self.verticodeField.text;
    if (nil == inputVercode || 0 >= inputVercode) {
        
        self.hud.labelText = @"请输入验证码";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.hud hide:YES];
            [self.verticodeField becomeFirstResponder];
            
        });
        
        return;
        
    }
    
    if (!(inputVercode &&
          ([inputVercode length] > 0) &&
          (NSOrderedSame == [inputVercode compare:self.code options:NSCaseInsensitiveSearch]))) {
        
        self.hud.labelText = @"验证码有误，请核对后重新提交";
        [self.hud hide:YES afterDelay:1.0f];
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
    
    ///封装参数
    NSDictionary *params = @{@"sign" : @"3",@"phone" : phone};
    
    [QSRequestManager requestDataWithType:rRequestTypeGetVertification andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///发送成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSCommonStringReturnData *tempModel = resultData;
            self.code = tempModel.verticode;
            self.hud.labelText = @"已发送";
            [self.hud hide:YES afterDelay:1.0f];
            /// 倒计时
            [self startTime];
            
        } else {
            
            QSHeaderDataModel *tempModel = resultData;
            self.hud.labelText = tempModel ? ([tempModel.info length] > 0 ? tempModel.info : @"手机验证码发送失败，请稍后再试……") : @"手机验证码发送失败，请稍后再试……";
            [self.hud hide:YES afterDelay:1.0f];
            
            _getVercodeButton.userInteractionEnabled = YES;
            
        }
        
    }];
    
}

#pragma mark -验证码倒计时
-(void)startTime{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_getVercodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                _getVercodeButton.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
//            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [_getVercodeButton setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                _getVercodeButton.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}


#pragma mark - 回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
    
}

@end
