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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title=@"登录";
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
    NSString *userName = ((UITextField *)self.userNameItem.property).text;
    NSString *pwd = ((UITextField *)self.passWordItem.property).text;
    
    ///回收键盘
    [((UITextField *)self.userNameItem.property) resignFirstResponder];
    [((UITextField *)self.passWordItem.property) resignFirstResponder];
    
    if ((nil == userName) || (0 >= [userName length])) {
        
        return;
        
    }
    
    if ((nil == pwd) || (0 >= [pwd length])) {
        
        return;
        
    }
    
    ///显示HUD
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
            
            ///修改登录状态
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"is_login"];
            
            ///同步数据
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            ///保存数据
            [tempModel.userInfo saveUserData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///返回上一页
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
        } else {
        
            self.hud.labelText = @"登录失败";
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
    [self.navigationController pushViewController:VC animated:YES];
    
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
