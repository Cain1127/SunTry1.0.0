//
//  QSWLoginPswViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWLoginPswViewController.h"
#import "QSWSettingCell.h"
#import "QSWSettingItem.h"
#import "QSWSettingGroup.h"
#import "QSWTextFieldItem.h"
#import "DeviceSizeHeader.h"
#import "ColorHeader.h"

#import "QSHeaderDataModel.h"

#import "QSRequestManager.h"

@interface QSWLoginPswViewController ()

@property (nonatomic,retain) QSWTextFieldItem *originalPwdItem; //!<原密码
@property (nonatomic,retain) QSWTextFieldItem *resetPwdItem; //!<新密码
@property (nonatomic,retain) QSWTextFieldItem *confirmPwdItem;  //!<确认密码

@end

@implementation QSWLoginPswViewController

#pragma mark - UI搭建
///UI搭建
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    ///自定义返回按钮
    UIBarButtonItem *turnBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(turnBackAction)];
    turnBackButton.tintColor = [UIColor whiteColor];
    
    ///设置返回按钮的颜色
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = turnBackButton;
    
    ///标题
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"登录密码"];
    self.navigationItem.titleView = navTitle;
    
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupFooter];
    
}

-(void)setupGroup0
{
    
    QSWSettingGroup *group = [self addGroup];
    self.originalPwdItem = [QSWTextFieldItem itemWithTitle:@"您当前的登录密码"];
    group.items = @[self.originalPwdItem];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///密码密文输入
        ((UITextField *)self.originalPwdItem.property).secureTextEntry=YES;
        
    });
    
}

-(void)setupGroup1
{
    
    QSWSettingGroup *group = [self addGroup];
    self.resetPwdItem = [QSWTextFieldItem itemWithTitle:@"新的登录密码"];
    group.items = @[self.resetPwdItem];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///密码密文输入
        ((UITextField *)self.resetPwdItem.property).secureTextEntry=YES;
        
    });
    
}

-(void)setupGroup2
{
    
    QSWSettingGroup *group = [self addGroup];
    self.confirmPwdItem = [QSWTextFieldItem itemWithTitle:@"再次确认您的登录密码"];
    group.items = @[self.confirmPwdItem];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///密码密文输入
        ((UITextField *)self.confirmPwdItem.property).secureTextEntry=YES;
        
    });
    
}

- (void)setupFooter
{
    
    /// 按钮
    UIButton *footterButton = [[UIButton alloc] init];
    CGFloat footterButtonX = SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 2;
    CGFloat footterButtonY = 10;
    CGFloat footterButtonW = self.tableView.frame.size.width - 2 * footterButtonX;
    CGFloat footterButtonH = 44;
    footterButton.frame = CGRectMake(footterButtonX, footterButtonY, footterButtonW, footterButtonH);
    
    /// 背景和文字
    footterButton.backgroundColor=COLOR_CHARACTERS_RED;
    [footterButton setTitle:@"提交" forState:UIControlStateNormal];
    footterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [footterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footterButton.layer.cornerRadius = 6.0f;
    
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

#pragma mark - 提交修改密码
///提交修改密码
-(void)gotoNextVC
{
    
    ///验证密码
    UITextField *originalField = self.originalPwdItem.property;
    NSString *originalPwd = originalField.text;
    
    ///本地密码
    NSString *localPwd = [[NSUserDefaults standardUserDefaults] valueForKey:@"pwd"];
    
    if (![originalPwd isEqualToString:localPwd]) {
        
        [originalField becomeFirstResponder];
        return;
        
    }
    
    ///新密码和确认密码
    UITextField *newPwdField = self.originalPwdItem.property;
    UITextField *confirmPwdField = self.originalPwdItem.property;
    
    NSString *newPwd = newPwdField.text;
    NSString *confirmPwd = confirmPwdField.text;
    
    if (nil == newPwd || 0 >= newPwd) {
        
        [newPwdField becomeFirstResponder];
        return;
        
    }
    
    if (nil == confirmPwd || 0 >= confirmPwd) {
        
        [confirmPwdField becomeFirstResponder];
        return;
        
    }
    
    [originalField resignFirstResponder];
    [newPwdField resignFirstResponder];
    [confirmPwdField resignFirstResponder];
    
    ///获取本地手机号码
    NSString *phone = [[NSUserDefaults standardUserDefaults] valueForKey:@"phone"];
    
    ///封装参数
    NSDictionary *params = @{@"phone" : phone,
                             @"pwd" : newPwd,
                             @"type" : @"1",
                             @"vcode" : @"123456"};
    
    [QSRequestManager requestDataWithType:rRequestTypeUserForgetPassword andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///修改成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///转换模型
            QSHeaderDataModel *tempModel = resultData;
            if (tempModel.type) {
                
                ///弹出提示
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码修改成功！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                
                ///显示1秒后移除提示
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [alert dismissWithClickedButtonIndex:0 animated:YES];
                    
                    ///修改本地密码
                    [[NSUserDefaults standardUserDefaults] setObject:newPwd forKey:@"pwd"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    ///返回上一页
                    [self.navigationController popViewControllerAnimated:YES];
                    
                });
                
            } else {
            
                ///弹出提示
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码修改失败，请稍后再试……！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                
                ///显示1秒后移除提示
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [alert dismissWithClickedButtonIndex:0 animated:YES];
                    
                });
            
            }
            
        } else {
        
            ///弹出提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码修改失败，请稍后再试……！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            
            ///显示1秒后移除提示
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                
            });
        
        }
        
    }];
    
}

@end
