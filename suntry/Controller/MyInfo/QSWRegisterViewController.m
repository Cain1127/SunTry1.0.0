//
//  QSWRegisterViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWRegisterViewController.h"
#import "QSWSettingCell.h"
#import "QSWSettingItem.h"
#import "QSWSettingGroup.h"
#import "QSWTextFieldItem.h"
#import "DeviceSizeHeader.h"
#import "ColorHeader.h"
#import "MBProgressHUD.h"
#import "ColorHeader.h"

#import "QSUserRegisterReturnData.h"
#import "QSCommonStringReturnData.h"
#import "QSRegisterDataModel.h"
#import "QSRequestManager.h"

#import "NSString+Format.h"

@interface QSWRegisterViewController ()<UITextFieldDelegate>

@property (nonatomic,retain) QSWTextFieldItem *userNameItem;  //!<用户账号
@property (nonatomic,retain) QSWTextFieldItem *passWordItem;  //!<密码
@property (nonatomic,retain) MBProgressHUD *hud;            //!<HUD
@property (nonatomic,strong) UIImageView *selectImageView;  //!<服务协议图片
@property (nonatomic,strong) UITextField *activateTextfield;//!<验证码输入框
@property (nonatomic,strong) UIButton *serviceButton;       //!<服务协议按钮
@property (nonatomic,strong) UIButton *registerButton;      //!<提交注册按钮
@property (nonatomic,copy) NSString *code;                  //!<验证码

@end

@implementation QSWRegisterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    ///标题
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"注册"];
    self.navigationItem.titleView = navTitle;
    
    
    ///自定义返回按钮
    UIBarButtonItem *turnBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(turnBackAction)];
    turnBackButton.tintColor = [UIColor whiteColor];
    
    ///设置返回按钮的颜色
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = turnBackButton;
    
    ///密码密文输入
    //((UITextField *)self.passWordItem.property).secureTextEntry=YES;
    [self setupGroup0];
    [self setupGroup1];
    [self setupFooter];
    
}

-(void)setupGroup0
{

    QSWSettingGroup *group = [self addGroup];
    
    self.userNameItem = [QSWTextFieldItem itemWithTitle:@"请输入您的手机号码"];
    
    group.items = @[self.userNameItem];
    
}

-(void)setupGroup1
{
    
    QSWSettingGroup *group = [self addGroup];
    
    self.passWordItem = [QSWTextFieldItem itemWithTitle:@"请输入您的登录密码"];
    group.items = @[self.passWordItem];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///密码密文输入
        ((UITextField *)self.passWordItem.property).secureTextEntry=YES;
        
    });
    
}

- (void)setupFooter
{
    
    // 脚部大view
    UIView *footer = [[UIView alloc] init];
    CGFloat footerH = 120.0f + 20.0f +44.0f+44.0f;
    footer.frame = CGRectMake(0, 0, 0, footerH);
    self.tableView.tableFooterView = footer;
    
    ///激活textfield
    self.activateTextfield=[[UITextField alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MAX_WIDTH-100.0f-5.0f, 44.0f)];
    self.activateTextfield.placeholder = @"激活码";
    self.activateTextfield.translatesAutoresizingMaskIntoConstraints=NO;
    self.activateTextfield.returnKeyType=UIReturnKeySearch;
    self.activateTextfield.clearButtonMode=UITextFieldViewModeUnlessEditing;
    self.activateTextfield.delegate=self;
    self.activateTextfield.borderStyle = UITextBorderStyleRoundedRect;
    [footer addSubview:self.activateTextfield];
    
    ///获取激活码按钮
    UIButton *activateButton=[[UIButton alloc] initWithFrame:CGRectMake(self.activateTextfield.frame.origin.x+self.activateTextfield.frame.size.width + 5.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 100.0f, 44.0f)];
    [activateButton setTitle:@"获取激活码" forState:UIControlStateNormal];
    activateButton.backgroundColor=COLOR_CHARACTERS_YELLOW;
    [activateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    activateButton.layer.cornerRadius = 6.0f;
    [activateButton addTarget:self action:@selector(activateButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:activateButton];
    
    
    ///服务协议按钮
    self.serviceButton = [[UIButton alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, _activateTextfield.frame.origin.y+_activateTextfield.frame.size.height+1*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 300.0f, 20.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    
    _selectImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f, 20.0f)];
    _selectImageView.image=[UIImage imageNamed:@"myinfo_select_normal"];
    _selectImageView.highlightedImage=[UIImage imageNamed:@"myinfo_select_selected"];
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(_selectImageView.frame.origin.x+_selectImageView.frame.size.width+SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 250.0f, 20.0f)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentLeft];
    [navTitle setText:@"我已阅读并同意《用户服务协议》"];
    navTitle.textColor=COLOR_CHARACTERS_YELLOW;

    [self.serviceButton addSubview:navTitle];
    [self.serviceButton addSubview:_selectImageView];
    [footer addSubview:self.serviceButton];
    _selectImageView.highlighted = NO;
    
    [self.serviceButton addTarget:self action:@selector(serviceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    ///提交注册按钮
    _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT,self.serviceButton.frame.origin.y+self.serviceButton.frame.size.height+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MAX_WIDTH, 44.0f)];
    
    ///背景和文字
    _registerButton.backgroundColor = COLOR_CHARACTERS_ROOTLINE;
    [_registerButton setTitle:@"提交注册" forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _registerButton.layer.cornerRadius = 6.0f;
    [footer addSubview:_registerButton];
    _registerButton.selected = NO;
    [_registerButton addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];

}

- (void)serviceButtonClick:(UIButton *)button
{
    
    if (button.selected) {
        
        button.selected = NO;
        _selectImageView.highlighted = NO;
        _registerButton.backgroundColor=COLOR_CHARACTERS_ROOTLINE;
        _registerButton.selected = NO;
        
    } else {
    
        button.selected = YES;
        _selectImageView.highlighted = YES;
        _registerButton.backgroundColor=COLOR_CHARACTERS_RED;
        _registerButton.selected = YES;
    
    }
    
}

#pragma mark - 返回事件
- (void)turnBackAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

///点击获取激活码
-(void)activateButtonAction
{

    UITextField *phoneField = self.userNameItem.property;
    if ([NSString isValidateMobile:phoneField.text ]) {
        
        [self getVertificationCode:phoneField.text];
        return;
        
    }
    
}

///点击注册按钮
-(void)gotoRegister
{
    
    ///判断是否可以注册
    if (!self.registerButton.selected) {
        
        return;
        
    }
    
    UITextField *userNameField = (UITextField *)self.userNameItem.property;
    UITextField *pswNameField = (UITextField *)self.passWordItem.property;
    
    ///判断数据
    __block NSString *userName = userNameField.text;
    __block NSString *pwd = pswNameField.text;
    
    ///回收键盘
    [((UITextField *)self.userNameItem.property) resignFirstResponder];
    [((UITextField *)self.passWordItem.property) resignFirstResponder];
    
    if ((nil == userName) || (0 >= [userName length])) {
        
        [userNameField becomeFirstResponder];
        return;
        
    }
    
    if ((nil == pwd) || (0 >= [pwd length])) {
        
        [pswNameField becomeFirstResponder];
        return;
        
    }
    
    ///检测验证码
    NSString *inputCode = self.activateTextfield.text;
    if (!(inputCode &&
          ([inputCode length] > 0) &&
          (NSOrderedSame == [inputCode compare:self.code options:NSCaseInsensitiveSearch]))) {
        
        ///弹出提醒框
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"验证码有误，请确认后再注册。" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        
        [alert show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [self.activateTextfield becomeFirstResponder];
            
        });
        return;
        
    }
    
    ///显示HUD
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ///封装登录参数
    NSDictionary *params = @{@"account" : userName,@"psw" : pwd,@"type" : @"1"};
    
    [QSRequestManager requestDataWithType:rRequestTypeRegister andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否登录成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            self.hud.labelText = @"注册成功";
            [self.hud hide:YES afterDelay:1.5f];
            
            ///回调
            if (self.registCallBack) {
                
                self.registCallBack(YES,userName,pwd);
                
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///返回上一页
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
        } else {
            
            QSHeaderDataModel *tempModel = resultData;
            
            self.hud.labelText = tempModel ? (tempModel.info ? tempModel.info : @"注册失败") : @"注册失败";
            [self.hud hide:YES afterDelay:1.0f];
            
            
        }
        
    }];

    
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
            [self.hud hide:YES afterDelay:0.6f];
            
        } else {
            
            self.hud.labelText = @"手机验证码发送失败，请稍后再试……";
            [self.hud hide:YES afterDelay:0.6f];
            
        }
        
    }];
    
}

@end
