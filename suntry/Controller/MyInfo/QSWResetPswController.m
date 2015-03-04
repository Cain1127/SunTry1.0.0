//
//  QSWResetPswController.m
//  suntry
//
//  Created by 王树朋 on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWResetPswController.h"
#import "QSWSettingCell.h"
#import "QSWSettingItem.h"
#import "QSWSettingGroup.h"
#import "QSWTextFieldItem.h"
#import "DeviceSizeHeader.h"
#import "ColorHeader.h"

#import "NSString+Format.h"

#import "MBProgressHUD.h"

#import "QSRequestManager.h"
#import "QSUserManager.h"

#import "QSUserInfoDataModel.h"
#import "QSHeaderDataModel.h"

@interface QSWResetPswController ()

@property (nonatomic,retain) QSWSettingItem *passWordItem;      //!<新的密码
@property (nonatomic,retain) QSWSettingItem *passWordItem1;     //!<二次输入新的密码
@property (nonatomic,retain) MBProgressHUD *hud;                //!<HUD

@end

@implementation QSWResetPswController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    ///标题
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"重置密码"];
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
    
    self.passWordItem = [QSWTextFieldItem itemWithTitle:@"输入您新的密码"];
    
    group.items = @[self.passWordItem];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///密码密文输入
        ((UITextField *)self.passWordItem.property).secureTextEntry=YES;
        
    });
}

-(void)setupGroup1
{
    
    QSWSettingGroup *group = [self addGroup];
    
    self.passWordItem1 = [QSWTextFieldItem itemWithTitle:@"再次确认您的新密码"];
    
    group.items = @[self.passWordItem1];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///密码密文输入
        ((UITextField *)self.passWordItem1.property).secureTextEntry=YES;
        
    });
    
}

- (void)setupFooter
{
    
    ///按钮
    UIButton *footterButton = [[UIButton alloc] init];
    CGFloat footterButtonX = SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 2;
    CGFloat footterButtonY = 10.0f;
    CGFloat footterButtonW = self.tableView.frame.size.width - 2 * footterButtonX;
    CGFloat footterButtonH = 44.0f;
    footterButton.frame = CGRectMake(footterButtonX, footterButtonY, footterButtonW, footterButtonH);
    
    ///背景和文字
    footterButton.backgroundColor=COLOR_CHARACTERS_RED;
    [footterButton setTitle:@"提交" forState:UIControlStateNormal];
    footterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [footterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footterButton.layer.cornerRadius=6.0f;
    
    // footer
    UIView *footer = [[UIView alloc] init];
    CGFloat footerH = footterButtonH + 20;
    footer.frame = CGRectMake(0, 0, 0, footerH);
    self.tableView.tableFooterView = footer;
    [footer addSubview:footterButton];
    [footterButton addTarget:self action:@selector(gotoNextVC) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 返回事件
- (void)turnBackAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 点击提交开始重置密码
///点击提交按钮事件
-(void)gotoNextVC
{
    
    ///获取输入内容
    UITextField *newPswField = self.passWordItem.property;
    NSString *newPsw = newPswField.text;
    
    UITextField *confirmField = self.passWordItem1.property;
    NSString *confirmPsw = confirmField.text;
    
    ///验证
    if (nil == newPsw || 0 >= [newPsw length]) {
        
        [newPswField becomeFirstResponder];
        return;
        
    }
    
    if (nil == confirmPsw || 0 >= [confirmPsw length]) {
        
        [confirmField becomeFirstResponder];
        return;
        
    }
    
    if (![newPsw isEqualToString:confirmPsw]) {
        
        ///提示
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:nil message:@"两次输入的密码不一致" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [aler show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [aler dismissWithClickedButtonIndex:0 animated:YES];
            
        });
        
        return;
        
    }
    
    ///显示HUD
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ///获取改换密码的手机号
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"reset_psw_phone"];
    NSString *vercode = [[NSUserDefaults standardUserDefaults] objectForKey:@"reset_psw_vercode"];
    
    ///封装参数
    NSDictionary *params = @{@"phone" : phone,
                             @"pwd" : newPsw,
                             @"type" : @"1",
                             @"vcode" : vercode};
    
    [QSRequestManager requestDataWithType:rRequestTypeUserForgetPassword andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [self.hud hide:YES];
            
            UIAlertView *aler = [[UIAlertView alloc] initWithTitle:nil message:@"密码重置成功！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [aler show];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [aler dismissWithClickedButtonIndex:0 animated:YES];
                
                ///返回登录页面
                NSInteger sumVC = [self.navigationController.viewControllers count];
                UIViewController *tempVC = self.navigationController.viewControllers[sumVC - 3];
                if (tempVC) {
                    
                    [self.navigationController popToViewController:tempVC animated:YES];
                    
                } else {
                
                    [self.navigationController popViewControllerAnimated:YES];
                
                }
                
            });
            
        } else {
            
            [self.hud hide:YES];
            
            QSHeaderDataModel *tempModel = resultData;
        
            UIAlertView *aler = [[UIAlertView alloc] initWithTitle:nil message:(tempModel ? ([tempModel.info length] > 0 ? tempModel.info : @"密码重置失败！") : @"密码重置失败！") delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [aler show];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [aler dismissWithClickedButtonIndex:0 animated:YES];
                
            });
        
        }
        
    }];
    
}

@end
