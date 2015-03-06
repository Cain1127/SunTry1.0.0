//
//  QSWLoginViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWLoginViewController.h"
#import "QSWSettingCell.h"
#import "QSWSettingItem.h"
#import "QSWSettingGroup.h"
#import "QSWTextFieldItem.h"
#import "DeviceSizeHeader.h"
#import "QSMyinfoViewController.h"
#import "QSWForgetPswController.h"
#import "QSWRegisterViewController.h"
#import "ColorHeader.h"
#import "MBProgressHUD.h"

#import "QSUserLoginReturnData.h"

#import "QSRequestManager.h"

@interface QSWLoginViewController () <UITextFieldDelegate>

@property (nonatomic,retain) QSWSettingItem *userNameItem;  //!<用户账号
@property (nonatomic,retain) QSWSettingItem *passWordItem;  //!<密码
@property (nonatomic,retain) MBProgressHUD *hud;            //!<HUD

@end

@implementation QSWLoginViewController

#pragma mark - UI搭建
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem=backItem;
    backItem.title=@"";
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"登录"];
    self.navigationItem.titleView = navTitle;
    
    ///自定义返回按钮
    UIBarButtonItem *turnBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(turnBackAction)];
    turnBackButton.tintColor = [UIColor whiteColor];
    
    ///设置返回按钮的颜色
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = turnBackButton;
    
    [self setupGroup0];
    [self setupGroup1];
    [self setupFooter];
    
}

-(void)setupGroup0
{
    
    QSWSettingGroup *group = [self addGroup];
    self.userNameItem = [QSWTextFieldItem itemWithTitle:@"输入您的手机号码" andDelegate:self];
    group.items = @[self.userNameItem];
    
}

-(void)setupGroup1
{
    
    QSWSettingGroup *group = [self addGroup];
    self.passWordItem = [QSWTextFieldItem itemWithTitle:@"输入您的登录密码" andDelegate:self];
    
    group.items = @[self.passWordItem];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///密码密文输入
        ((UITextField *)self.passWordItem.property).secureTextEntry=YES;
        
    });
    
}

- (void)setupFooter
{
    
    ///  登录按钮
    UIButton *footterButton = [[UIButton alloc] init];
    CGFloat footterButtonX = SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 2;
    CGFloat footterButtonY = 10;
    CGFloat footterButtonW = self.tableView.frame.size.width - 2 * footterButtonX;
    CGFloat footterButtonH = 44;
    footterButton.frame = CGRectMake(footterButtonX, footterButtonY, footterButtonW, footterButtonH);
    
    /// 背景和文字
    footterButton.backgroundColor=COLOR_CHARACTERS_RED;
    [footterButton setTitle:@"登录" forState:UIControlStateNormal];
    footterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [footterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footterButton.layer.cornerRadius = 6.0f;
    
    /// footer
    UIView *footer = [[UIView alloc] init];
    CGFloat footerH = footterButtonH + 20.0f + SIZE_DEFAULT_MARGIN_LEFT_RIGHT+30.0f;
    footer.frame = CGRectMake(0, 0, 0, footerH);
    self.tableView.tableFooterView = footer;
    [footer addSubview:footterButton];
    [footterButton addTarget:self action:@selector(gotoLoginVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *forgetPsw=[[UIButton alloc]initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MARGIN_LEFT_RIGHT+44.0f,100.0f, 30.0f)];
    [forgetPsw setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPsw setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [forgetPsw addTarget:self action:@selector(forgetPswAction) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:forgetPsw];
    
    UIButton *registerPsw=[[UIButton alloc]initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-SIZE_DEFAULT_MARGIN_LEFT_RIGHT-100.0f,SIZE_DEFAULT_MARGIN_LEFT_RIGHT+44.0f,100.0f, 30.0f)];
    [registerPsw setTitle:@"注册帐号" forState:UIControlStateNormal];
    [registerPsw setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [registerPsw addTarget:self action:@selector(registerPswAction) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:registerPsw];
    
}

///点击登录
-(void)gotoLoginVC
{
    
    ///判断数据
    UITextField *userNameField = (UITextField *)self.userNameItem.property;
    UITextField *pwdField = (UITextField *)self.passWordItem.property;
    NSString *userName = userNameField.text;
    NSString *pwd = pwdField.text;
    
    ///回收键盘
    [userNameField resignFirstResponder];
    [pwdField resignFirstResponder];
    
    ///显示HUD
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ((nil == userName) || (0 >= [userName length])) {

        self.hud.labelText = @"请输入用户名";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.hud hide:YES];
            [userNameField resignFirstResponder];
            
        });
        return;
        
    }
    
    if ((nil == pwd) || (0 >= [pwd length])) {
        
        self.hud.labelText = @"请输入登录密码";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.hud hide:YES];
            [pwdField resignFirstResponder];
            
        });
        return;
        
    }
    
    ///封装登录参数
    NSDictionary *params = @{@"account" : userName,@"psw" : pwd,@"type" : @"1"};
    
    [QSRequestManager requestDataWithType:rRequestTypeLogin andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否登录成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            self.hud.labelText = @"登录成功";
            [self.hud hide:YES afterDelay:1.5f];
            
            ///转换模型
            QSUserLoginReturnData *tempModel = resultData;
            
            ///保存到本地
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"user_count"];
            [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:@"pwd"];
            [[NSUserDefaults standardUserDefaults] setObject:tempModel.userInfo.userID forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults] setObject:tempModel.userInfo.phone forKey:@"phone"];
            
            ///修改登录状态
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"is_login"];
            
            ///同步数据
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            ///保存数据
            [tempModel.userInfo saveUserData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///回调
                if (self.loginSuccessCallBack) {
                    
                    self.loginSuccessCallBack(YES);
                    
                }
                
                ///返回上一页
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
        } else {
            
            QSHeaderDataModel *tempModel = resultData;
            self.hud.labelText = tempModel ? ([tempModel.info length] > 0 ? tempModel.info : @"登录失败") : @"登录失败";
            [self.hud hide:YES afterDelay:1.0f];
            
            ///修改登录状态
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"is_login"];
            ///同步数据
            [[NSUserDefaults standardUserDefaults] synchronize];
        
        }
        
    }];
    
}

///进入忘记密码界面
-(void)forgetPswAction
{
    
    QSWForgetPswController *VC=[[QSWForgetPswController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

///进入注册帐号界面
-(void)registerPswAction
{
    
    QSWRegisterViewController *VC=[[QSWRegisterViewController alloc] init];
    VC.registCallBack = ^(BOOL flag,NSString *userName,NSString *psw){
    
        if (flag) {
            
            ((UITextField *)self.userNameItem.property).text = userName;
            ((UITextField *)self.passWordItem.property).text = psw;
            
        }
    
    };
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark - 返回事件
- (void)turnBackAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 点击done按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    ///进行登录事件
    [self gotoLoginVC];
    ///回收键盘
    [textField resignFirstResponder];
    return YES;

}

@end
