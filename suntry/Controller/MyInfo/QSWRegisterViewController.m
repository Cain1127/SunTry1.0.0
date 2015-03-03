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

#import "QSUserRegisterReturnData.h"
#import "QSCommonStringReturnData.h"
#import "QSRegisterDataModel.h"
#import "QSRequestManager.h"

#import "NSString+Format.h"

@interface QSWRegisterViewController ()<UITextFieldDelegate>

@property (nonatomic,retain) QSWSettingItem *userNameItem;  //!<用户账号
@property (nonatomic,retain) QSWSettingItem *passWordItem;  //!<密码
@property (nonatomic,retain) MBProgressHUD *hud;            //!<HUD
@property (nonatomic,strong) UIImageView *selectImageView;  //!<服务协议图片
@property (nonatomic,strong) UITextField *activateTextfield;//!<验证码输入框
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
    ///密码密文输入
    ((UITextField *)self.passWordItem.property).secureTextEntry=YES;
    [self setupGroup0];
    [self setupGroup1];
    [self setupFooter];
    
}

-(void)setupGroup0
{
    
    ///自定义返回按钮
    UIBarButtonItem *turnBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(turnBackAction)];
    turnBackButton.tintColor = [UIColor whiteColor];
    
    ///设置返回按钮的颜色
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = turnBackButton;

    
    QSWSettingGroup *group = [self addGroup];
    
    self.userNameItem = [QSWTextFieldItem itemWithTitle:@"请输入您的手机号码" andDelegate:self];
    
    group.items = @[self.userNameItem];
    
}

-(void)setupGroup1
{
    
    QSWSettingGroup *group = [self addGroup];
    
    self.passWordItem = [QSWTextFieldItem itemWithTitle:@"请输入您的登录密码" andDelegate:self];
    group.items = @[self.passWordItem];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///密码密文输入
        ((UITextField *)self.passWordItem.property).secureTextEntry=YES;
        
    });
    
}

- (void)setupFooter
{
    
    ///提交注册按钮
    UIButton *footterButton = [[UIButton alloc] init];
    footterButton.translatesAutoresizingMaskIntoConstraints=NO;
    
    ///背景和文字
    footterButton.backgroundColor=COLOR_CHARACTERS_RED;
    [footterButton setTitle:@"提交注册" forState:UIControlStateNormal];
    footterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [footterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footterButton.layer.cornerRadius = 6.0f;
    
    // footer
    UIView *footer = [[UIView alloc] init];
    CGFloat footerH = 120.0f + 20.0f +5.0f+44.0f+40.0f;
    footer.frame = CGRectMake(0, 0, 0, footerH);
    self.tableView.tableFooterView = footer;
    [footer addSubview:footterButton];
    [footterButton addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
    
    ///激活textfield
    self.activateTextfield=[[UITextField alloc] init];
    self.activateTextfield.placeholder = @"激活码";
    self.activateTextfield.translatesAutoresizingMaskIntoConstraints=NO;
    self.activateTextfield.returnKeyType=UIReturnKeySearch;
    self.activateTextfield.clearButtonMode=UITextFieldViewModeUnlessEditing;
    self.activateTextfield.delegate=self;
    self.activateTextfield.borderStyle = UITextBorderStyleRoundedRect;
    [footer addSubview:self.activateTextfield];
    
    ///获取激活码按钮
    UIButton *activateButton=[[UIButton alloc] init];
    activateButton.translatesAutoresizingMaskIntoConstraints=NO;
    [activateButton setTitle:@"获取激活码" forState:UIControlStateNormal];
    [activateButton setBackgroundColor:[UIColor brownColor]];
    [activateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    activateButton.layer.cornerRadius = 6.0f;
    [activateButton addTarget:self action:@selector(activateButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:activateButton];
    
    ///条款控件
    self.selectImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myinfo_select_normal"] highlightedImage:[UIImage imageNamed:@"myinfo_select_selected"]];
    self.selectImageView.translatesAutoresizingMaskIntoConstraints=NO;
    self.selectImageView.userInteractionEnabled=YES;
    
    //[selectImageView setTag:2];//带个参数过去
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickx:)];
    [self.selectImageView addGestureRecognizer:singleTap];
    
    [footer addSubview:_selectImageView];
    
    UILabel *selectLabel=[[UILabel alloc] init];
    selectLabel.translatesAutoresizingMaskIntoConstraints=NO;
    selectLabel.text=@"我已阅读并同意《用户服务协议》";
    selectLabel.font=[UIFont systemFontOfSize:14.0f];
    [footer addSubview:selectLabel];

    ///4.添加VFL约束
    ///参数
    NSDictionary *___viewsVFL=NSDictionaryOfVariableBindings(_activateTextfield,activateButton,_selectImageView,selectLabel,footterButton);
    NSDictionary *___sizeVFL = @{@"margin" : [NSString stringWithFormat:@"%.2f",SIZE_DEFAULT_MARGIN_LEFT_RIGHT]};
    
    ///约束
    NSString *___hVFL_activateTextfield = @"H:|-margin-[_activateTextfield]-5-[activateButton(100)]-margin-|";
    NSString *___hVFL_selectImageView=@"H:|-margin-[_selectImageView(20)]-5-[selectLabel]-margin-|";
    NSString *___hVFL_footterButton=@"H:|-margin-[footterButton]-margin-|";
    NSString *___vVFL_all = @"V:|-margin-[_activateTextfield(44)]-margin-[_selectImageView(20)]-margin-[footterButton(44)]";
    NSString *___vVFL_activateButton=@"V:[activateButton(44)]";
    
    ///添加约束
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_activateTextfield options:NSLayoutFormatAlignAllCenterY metrics:___sizeVFL views:___viewsVFL]];
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_selectImageView options:NSLayoutFormatAlignAllCenterY metrics:___sizeVFL views:___viewsVFL]];
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_footterButton options:0 metrics:___sizeVFL  views:___viewsVFL]];
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_all  options:0 metrics:___sizeVFL views:___viewsVFL]];
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_activateButton options:0 metrics:___sizeVFL views:___viewsVFL]];
    
}

- (void)clickx:(UITapGestureRecognizer *)tap
{
  
    _selectImageView.highlighted=YES;
    
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
    
    ///判断数据
    __block NSString *userName = ((UITextField *)self.userNameItem.property).text;
    __block NSString *pwd = ((UITextField *)self.passWordItem.property).text;
    
    ///回收键盘
    [((UITextField *)self.userNameItem.property) resignFirstResponder];
    [((UITextField *)self.passWordItem.property) resignFirstResponder];
    
    if ((nil == userName) || (0 >= [userName length])) {
        
        return;
        
    }
    
    if ((nil == pwd) || (0 >= [pwd length])) {
        
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
            
            self.hud.labelText = @"注册失败";
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
