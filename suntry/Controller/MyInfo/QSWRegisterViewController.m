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

@interface QSWRegisterViewController ()<UITextFieldDelegate>

@end

@implementation QSWRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"注册";
    [self setupGroup0];
    [self setupGroup1];
    [self setupFooter];
}

-(void)setupGroup0
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"请输入您的手机号码"];
    
    
    group.items = @[item];
    
}

-(void)setupGroup1
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"请输入您的登录密码"];
    
    
    group.items = @[item];
    
}

- (void)setupFooter
{
    // 按钮
      UIButton *footterButton = [[UIButton alloc] init];
      footterButton.translatesAutoresizingMaskIntoConstraints=NO;
//    CGFloat footterButtonX = SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 2;
//    CGFloat footterButtonY = 10;
//    CGFloat footterButtonW = self.tableView.frame.size.width - 2 * footterButtonX;
//    CGFloat footterButtonH = 44;
//    footterButton.frame = CGRectMake(footterButtonX, footterButtonY, footterButtonW, footterButtonH);
    
    // 背景和文字
    [footterButton setBackgroundImage:[UIImage imageNamed:@"nav_backgroud"] forState:UIControlStateNormal];
    [footterButton setBackgroundImage:[UIImage imageNamed:@"nav_backgroud"] forState:UIControlStateHighlighted];
    [footterButton setTitle:@"提交注册" forState:UIControlStateNormal];
    footterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [footterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // footer
    UIView *footer = [[UIView alloc] init];
    CGFloat footerH = 120.0f + 20.0f +5.0f+44.0f;
    footer.frame = CGRectMake(0, 0, 0, footerH);
    self.tableView.tableFooterView = footer;
    [footer addSubview:footterButton];
    [footterButton addTarget:self action:@selector(gotoNextVC) forControlEvents:UIControlEventTouchUpInside];
    
    ///激活textfield
//    UITextField *activate=[[UITextField alloc]initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f+5.0f+SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 150.0f, 44.0f)];
    UITextField *activate=[[UITextField alloc] init];
    activate.placeholder = @"激活码";
    activate.translatesAutoresizingMaskIntoConstraints=NO;
    activate.returnKeyType=UIReturnKeySearch;
    //textfield.autocorrectionType=UITextAutocorrectionTypeNo;
    activate.clearButtonMode=UITextFieldViewModeUnlessEditing;
    activate.delegate=self;
    activate.tag = 222;
    activate.borderStyle = UITextBorderStyleRoundedRect;
    [footer addSubview:activate];
    
    ///获取激活码按钮
    UIButton *activateButton=[[UIButton alloc] init];
    activateButton.translatesAutoresizingMaskIntoConstraints=NO;
    [activateButton setTitle:@"获取激活码" forState:UIControlStateNormal];
    [activateButton setBackgroundColor:[UIColor brownColor]];
    [activateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [activateButton addTarget:self action:@selector(activateButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:activateButton];
    
    ///4.添加VFL约束
    ///参数
    NSDictionary *___viewsVFL=NSDictionaryOfVariableBindings(activate,activateButton,footterButton);
    NSDictionary *___sizeVFL = @{@"margin" : [NSString stringWithFormat:@"%.2f",SIZE_DEFAULT_MARGIN_LEFT_RIGHT]};
    
    ///约束
    NSString *___hVFL_activate = @"H:|-margin-[activate]-5-[activateButton(100)]-margin-|";
    NSString *___hVFL_footterButton=@"H:|-margin-[footterButton]-margin-|";
    NSString *___vVFL_all = @"V:|-margin-[activate(44)]-margin-[footterButton(44)]";
    NSString *___vVFL_activateButton=@"V:[activateButton(44)]";
    
    ///添加约束
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_activate options:NSLayoutFormatAlignAllCenterY metrics:___sizeVFL views:___viewsVFL]];
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_footterButton options:0 metrics:___sizeVFL  views:___viewsVFL]];
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_all  options:0 metrics:___sizeVFL views:___viewsVFL]];
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_activateButton options:0 metrics:___sizeVFL views:___viewsVFL]];
    
}

///获取激活码事件
-(void)activateButtonAction
{

    
}

///进入注册按钮事件
-(void)gotoNextVC
{
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
