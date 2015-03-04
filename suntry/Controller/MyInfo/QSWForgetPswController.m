//
//  QSWForgetPswController.m
//  suntry
//
//  Created by 王树朋 on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWForgetPswController.h"
#import "QSWSettingCell.h"
#import "QSWSettingItem.h"
#import "QSWSettingGroup.h"
#import "QSWTextFieldItem.h"
#import "DeviceSizeHeader.h"
#import "QSWResetPswController.h"
#import "ColorHeader.h"

#import "QSRequestManager.h"
#import "QSCommonStringReturnData.h"

#import "QSBlockButton.h"
#import "NSString+Format.h"

#import "MBProgressHUD.h"

@interface QSWForgetPswController () <UITextFieldDelegate>

@property (nonatomic,retain) QSWTextFieldItem *phoneItem;       //!<手机号码
@property (nonatomic,retain) UITextField *verticodeField;       //!<验证码
@property (nonatomic,copy) NSString *code;                      //!<验证码

@property (nonatomic,retain) MBProgressHUD *hud;                //!<hud

@end

@implementation QSWForgetPswController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    ///标题
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"忘记密码"];
    self.navigationItem.titleView = navTitle;
    
    ///自定义返回按钮
    UIBarButtonItem *turnBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(turnBackAction)];
    turnBackButton.tintColor = [UIColor whiteColor];
    
    ///设置返回按钮的颜色
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = turnBackButton;

    [self setupGroup0];
    [self setupFooter];
    
}

-(void)setupGroup0
{
    
    QSWSettingGroup *group = [self addGroup];
    self.phoneItem = [QSWTextFieldItem itemWithTitle:@"输入您的手机号码"];
    group.items = @[self.phoneItem];
    
}

- (void)setupFooter
{
    
    ///验证码输入框
    self.verticodeField = [[UITextField alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 8.0f, SIZE_DEFAULT_MAX_WIDTH - 80.0f, 44.0f)];
    self.verticodeField.borderStyle = UITextBorderStyleRoundedRect;
    self.verticodeField.placeholder = @"激活码";
    self.verticodeField.delegate = self;
    
    ///获取验证码按钮
    UIButton *getVercodeButton = [UIButton createBlockButtonWithFrame:CGRectMake(self.verticodeField.frame.origin.x + self.verticodeField.frame.size.width + 5.0f, self.verticodeField.frame.origin.y, 75.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        UITextField *phoneField = self.phoneItem.property;
        
        ///验证手机是否有效
        if ([NSString isValidateMobile:phoneField.text]) {
            
            [self getVertificationCode:phoneField.text];
            
        } else {
            
            [self.verticodeField becomeFirstResponder];
            
        }
        
    }];
    [getVercodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVercodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getVercodeButton setTitleColor:COLOR_CHARACTERS_RED forState:UIControlStateHighlighted];
    getVercodeButton.layer.cornerRadius = 6.0f;
    getVercodeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    getVercodeButton.backgroundColor = COLOR_CHARACTERS_YELLOW;
    
    ///按钮
    UIButton *footterButton = [[UIButton alloc] init];
    CGFloat footterButtonX = SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 2;
    CGFloat footterButtonW = self.tableView.frame.size.width - 2 * footterButtonX;
    CGFloat footterButtonH = 44;
    footterButton.frame = CGRectMake(footterButtonX, getVercodeButton.frame.origin.y + getVercodeButton.frame.size.height + 25.0f, footterButtonW, footterButtonH);
    
    ///背景和文字
    footterButton.backgroundColor = COLOR_CHARACTERS_RED;
    [footterButton setTitle:@"下一步" forState:UIControlStateNormal];
    footterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [footterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footterButton.layer.cornerRadius=6.0f;
    
    ///footer
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 25.0f + 44.0f * 2.0f)];
    self.tableView.tableFooterView = footer;
    
    [footer addSubview:self.verticodeField];
    [footer addSubview:getVercodeButton];
    [footer addSubview:footterButton];
    [footterButton addTarget:self action:@selector(gotoNextVC) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 返回事件
- (void)turnBackAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

///进入下一步按钮事件
-(void)gotoNextVC
{
    
    ///保存手机号码
    UITextField *phoneField = self.phoneItem.property;
    NSString *phone = phoneField.text;
    
    ///判断手机号
    if (![NSString isValidateMobile:phone]) {
        
        [phoneField becomeFirstResponder];
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
    
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"reset_psw_phone"];
    [[NSUserDefaults standardUserDefaults] setObject:inputVercode forKey:@"reset_psw_vercode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    QSWResetPswController *VC = [[QSWResetPswController alloc] init];
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

@end
