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
#import "QSRegisterDataModel.h"
#import "QSRequestManager.h"

@interface QSWRegisterViewController ()<UITextFieldDelegate>

@property (nonatomic,retain) QSWSettingItem *userNameItem;  //!<用户账号
@property (nonatomic,retain) QSWSettingItem *passWordItem;  //!<密码
@property (nonatomic,retain) MBProgressHUD *hud;            //!<HUD

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
    
}

- (void)setupFooter
{
    // 提交注册按钮
      UIButton *footterButton = [[UIButton alloc] init];
      footterButton.translatesAutoresizingMaskIntoConstraints=NO;
    
    // 背景和文字
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
    UITextField *activateTextfield=[[UITextField alloc] init];
    activateTextfield.placeholder = @"激活码";
    activateTextfield.translatesAutoresizingMaskIntoConstraints=NO;
    activateTextfield.returnKeyType=UIReturnKeySearch;
    activateTextfield.clearButtonMode=UITextFieldViewModeUnlessEditing;
    activateTextfield.delegate=self;
    activateTextfield.tag = 222;
    activateTextfield.borderStyle = UITextBorderStyleRoundedRect;
    [footer addSubview:activateTextfield];
    
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
    UIImageView *selectImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myinfo_select_normal"] highlightedImage:[UIImage imageNamed:@"myinfo_select_selected"]];
    selectImageView.translatesAutoresizingMaskIntoConstraints=NO;
    selectImageView.userInteractionEnabled=YES;
    [footer addSubview:selectImageView];
    
    UILabel *selectLabel=[[UILabel alloc] init];
    selectLabel.translatesAutoresizingMaskIntoConstraints=NO;
    selectLabel.text=@"我已阅读并同意《用户服务协议》";
    selectLabel.font=[UIFont systemFontOfSize:14.0f];
    [footer addSubview:selectLabel];

    ///4.添加VFL约束
    ///参数
    NSDictionary *___viewsVFL=NSDictionaryOfVariableBindings(activateTextfield,activateButton,selectImageView,selectLabel,footterButton);
    NSDictionary *___sizeVFL = @{@"margin" : [NSString stringWithFormat:@"%.2f",SIZE_DEFAULT_MARGIN_LEFT_RIGHT]};
    
    ///约束
    NSString *___hVFL_activateTextfield = @"H:|-margin-[activateTextfield]-5-[activateButton(100)]-margin-|";
    NSString *___hVFL_selectImageView=@"H:|-margin-[selectImageView(20)]-5-[selectLabel]-margin-|";
    NSString *___hVFL_footterButton=@"H:|-margin-[footterButton]-margin-|";
    NSString *___vVFL_all = @"V:|-margin-[activateTextfield(44)]-margin-[selectImageView(20)]-margin-[footterButton(44)]";
    NSString *___vVFL_activateButton=@"V:[activateButton(44)]";
    
    ///添加约束
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_activateTextfield options:NSLayoutFormatAlignAllCenterY metrics:___sizeVFL views:___viewsVFL]];
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_selectImageView options:NSLayoutFormatAlignAllCenterY metrics:___sizeVFL views:___viewsVFL]];
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_footterButton options:0 metrics:___sizeVFL  views:___viewsVFL]];
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_all  options:0 metrics:___sizeVFL views:___viewsVFL]];
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_activateButton options:0 metrics:___sizeVFL views:___viewsVFL]];
    
}

#pragma mark - 返回事件
- (void)turnBackAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

///点击获取激活码
-(void)activateButtonAction
{

    
}

///点击注册按钮
-(void)gotoRegister
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
    
    [QSRequestManager requestDataWithType:rRequestTypeRegister andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否登录成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            self.hud.labelText = @"注册成功";
            [self.hud hide:YES afterDelay:1.5f];
            
            ///转换模型
            QSUserRegisterReturnData *tempModel = resultData;
             NSLog(@"===========成功注册的用户名==========");
             NSLog(@"%@",tempModel.RegisterList.userName);
             NSLog(@"===========成功注册的用户名==========");
            
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
