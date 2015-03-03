//
//  QSWEditSendAdsViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWEditSendAdsViewController.h"
#import "QSWSettingCell.h"
#import "QSWSettingItem.h"
#import "QSWSettingGroup.h"
#import "QSWSettingArrowItem.h"
#import "QSWTextFieldItem.h"
#import "DeviceSizeHeader.h"
#import "ColorHeader.h"
#import "QSDatePickerViewController.h"
#import "NSString+Format.h"
#import "ASDepthModalViewController.h"
#import "QSUserAddressDataModel.h"
#import "QSPickerViewItem.h"
#import "QSRequestManager.h"

@interface QSWEditSendAdsViewController ()<UITextFieldDelegate>

@property (nonatomic,retain) QSUserAddressDataModel *addressModel;//!<地址数据模型

@property (nonatomic,retain) QSWTextFieldItem *userNameItem;        //!<用户名输入框模型
@property (nonatomic,retain) QSWTextFieldItem *genderItem;          //!<性别选择框模型
@property (nonatomic,retain) QSWTextFieldItem *addressItem;         //!<送餐地址输入框模型
@property (nonatomic,retain) QSWTextFieldItem *companyItem;         //!<所在公司输入框模型
@property (nonatomic,retain) QSWTextFieldItem *phoneItem;           //!<联系电话输入框模型
@property (nonatomic,retain) QSWTextFieldItem *isMasterItem;        //!<是否默认配送选择框模型

@property (nonatomic,strong) QSDatePickerViewController *pickerVC;  //!<选择器

@end

@implementation QSWEditSendAdsViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-02-13 11:02:53
 *
 *  @brief          根据给定的地址模型，进入地址编辑页面
 *
 *  @param model    地址的数据模型
 *
 *  @return         返回当前创建的地址编辑页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithAddressModel:(QSUserAddressDataModel *)model
{
    
    if (self = [super init]) {
        
        ///保存数据模型
        self.addressModel = model;
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    ///自定义返回按钮
    UIBarButtonItem *turnBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(turnBackAction)];
    turnBackButton.tintColor = [UIColor whiteColor];
    
    ///设置返回按钮的颜色
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = turnBackButton;
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"编辑送餐地址"];
    self.navigationItem.titleView = navTitle;
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
    [self setupGroup4];
    [self setupGroup5];
    [self setupFooter];
    
}

-(void)setupGroup0
{
    
    QSWSettingGroup *group = [self addGroup];
    self.userNameItem = [QSWTextFieldItem itemWithTitle:@"用户名" andDelegate:self];
    self.userNameItem.subtitle = self.addressModel.userName;
    group.items = @[self.userNameItem];
    
}

-(void)setupGroup1
{
    
    QSWSettingGroup *group = [self addGroup];
    self.genderItem = [QSPickerViewItem itemWithTitle:@"性别" andDelegate:self];
    [self.genderItem setValue:([self.addressModel.gender intValue] == 0) ? @"先生" : @"女士" forKey:@"rightTitle"];
    group.items = @[self.genderItem];
    
}

-(void)setupGroup2
{
    
    QSWSettingGroup *group = [self addGroup];
    self.addressItem = [QSWTextFieldItem itemWithTitle:@"送餐地址" andDelegate:self];
    self.addressItem.subtitle = self.addressModel.address;
    group.items = @[self.addressItem];
    
}

-(void)setupGroup3
{
    
    QSWSettingGroup *group = [self addGroup];
    self.companyItem = [QSWTextFieldItem itemWithTitle:@"公司" andDelegate:self];
    self.companyItem.subtitle = self.addressModel.company;
    group.items = @[self.companyItem];
    
}

-(void)setupGroup4
{
    
    QSWSettingGroup *group = [self addGroup];
    self.phoneItem = [QSWTextFieldItem itemWithTitle:@"联系电话" andDelegate:self];
    self.phoneItem.subtitle = self.addressModel.phone;
    group.items = @[self.phoneItem];
    
}

-(void)setupGroup5
{
    
    QSWSettingGroup *group = [self addGroup];
    self.isMasterItem = [QSPickerViewItem itemWithTitle:@"是否默认配送地址" andDelegate:self];
    [self.isMasterItem setValue:(([self.addressModel.is_master intValue] == 1) ? @"是" : @"否") forKey:@"rightTitle"];
    group.items = @[self.isMasterItem];
    
}

- (void)setupFooter
{
    
    //保存修改 按钮
    UIButton *footterButton = [[UIButton alloc] init];
    CGFloat footterButtonX = SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 2;
    CGFloat footterButtonY = 10.0f;
    CGFloat footterButtonW = self.tableView.frame.size.width - 2 * footterButtonX;
    CGFloat footterButtonH = 44.0f;
    footterButton.frame = CGRectMake(footterButtonX, footterButtonY, footterButtonW, footterButtonH);
    
    // 背景和文字
    footterButton.backgroundColor=COLOR_CHARACTERS_RED;
    [footterButton setTitle:@"保存修改" forState:UIControlStateNormal];
    footterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [footterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footterButton.layer.cornerRadius = 6.0f;
    
    // footer
    UIView *footer = [[UIView alloc] init];
    CGFloat footerH = 2*footterButtonH + 20;
    footer.frame = CGRectMake(0, 0, 0, footerH);
    self.tableView.tableFooterView = footer;
    [footer addSubview:footterButton];
    [footterButton addTarget:self action:@selector(gotoNextVC) forControlEvents:UIControlEventTouchUpInside];
    
    ///删除送餐地址 按钮
    UIButton *footterButton1 = [[UIButton alloc] init];
    CGFloat footterButton1X = SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 2;
    CGFloat footterButton1Y = 59.0f;
    CGFloat footterButton1W = self.tableView.frame.size.width - 2 * footterButton1X;
    CGFloat footterButton1H = 44.0f;
    footterButton1.frame = CGRectMake(footterButton1X, footterButton1Y, footterButton1W, footterButton1H);
    
    // 背景和文字
    footterButton1.backgroundColor=[UIColor brownColor];
    [footterButton1 setTitle:@"删除送餐地址" forState:UIControlStateNormal];
    footterButton1.titleLabel.font = [UIFont systemFontOfSize:14];
    [footterButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footterButton1.layer.cornerRadius=6.0f;
    
    [footer addSubview:footterButton1];
    [footterButton1 addTarget:self action:@selector(gotoNextVC1) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 返回事件
- (void)turnBackAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark --按钮方法
///保存修改按钮方法
-(void)gotoNextVC
{
    
    ///姓名
    UITextField *nameField = ((UITextField *)self.userNameItem.property);
    NSString *name = nameField.text;
    
    ///判断姓名
    if (nil == name || 0 >= [name length]) {
        
        [nameField becomeFirstResponder];
        return;
        
    }
    
    ///性别
    UITextField *genderField = (UITextField *)self.genderItem.property;
    UILabel *genderLabel = [genderField.rightView subviews][0];
    NSString *genderString = genderLabel.text ? genderLabel.text : @"先生";
    NSString *gender = ([genderString isEqualToString:@"先生"]) ? @"0" : @"1";
    
    ///地址
    UITextField *addressField = (UITextField *)self.addressItem.property;
    NSString *address = addressField.text;
    if (nil == address || 0 >= address) {
        
        [addressField becomeFirstResponder];
        return;
        
    }
    
    ///公司
    UITextField *companyField = (UITextField *)self.companyItem.property;
    NSString *company = companyField.text;
    if (nil == company || 0 >= [company length]) {
        
        [companyField becomeFirstResponder];
        return;
        
    }
    
    ///电话
    UITextField *phoneField = (UITextField *)self.phoneItem.property;
    NSString *phone = phoneField.text;
    BOOL isPhone = [NSString isValidateMobile:phone];
    if (!isPhone) {
        
        [phoneField becomeFirstResponder];
        return;
        
    }
    
    ///是否默认配送地址
    UITextField *isMasterField = (UITextField *)self.isMasterItem.property;
    UILabel *isMasterLabel = [isMasterField.rightView subviews][0];
    NSString *isMasterString = isMasterLabel.text ? isMasterLabel.text : @"否";
    NSString *isMaster = ([isMasterString isEqualToString:@"是"]) ? @"1" : @"0";
    
    ///生成参数
    NSDictionary *params = @{@"id" : self.addressModel.addressID,
                             @"name" : name,
                             @"sex" : gender,
                             @"address" : address,
                             @"company" : company,
                             @"phone" : phone,
                             @"master" : isMaster};
    
    ///发回服务端添加
    [QSRequestManager requestDataWithType:rRequestTypeAddSendAddress andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///添加成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///弹出提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"添加成功。" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            
            ///显示1秒后移除提示
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                
                ///刷新送餐地址列表
                if (self.editSendAddressCallBack) {
                    
                    self.editSendAddressCallBack(YES);
                    
                }
                
                ///返回上一页
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
        } else {
            
            ///弹出提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"添加送餐地址失败，请稍后再试。" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            
            ///显示1秒后移除提示
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                
            });
            
        }
        
    }];
    
}

///删除送餐地址按钮方法
-(void)gotoNextVC1
{
    
    ///生成参数
    NSDictionary *params = @{@"id" : self.addressModel.addressID};
    
    ///发回服务端添加
    [QSRequestManager requestDataWithType:rRequestTypeDelSendAddress andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///删除成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///弹出提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"删除成功。" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            
            ///显示1秒后移除提示
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                
                ///刷新送餐地址列表
                if (self.editSendAddressCallBack) {
                    
                    self.editSendAddressCallBack(YES);
                    
                }
                
                ///返回上一页
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
        } else {
            
            ///弹出提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"删除送餐地址失败，请稍后再试。" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            
            ///显示1秒后移除提示
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                
            });
            
        }
        
    }];

    
}

#pragma mark - 点击输入框时性别和默认送餐地址为弹出样式
///点击输入框时性别和默认送餐地址为弹出样式
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    ///如果是性别选择框，则弹出选择框
    if (textField == self.genderItem.property) {
        
        [((UITextField *)self.userNameItem.property) resignFirstResponder];
        [((UITextField *)self.addressItem.property) resignFirstResponder];
        [((UITextField *)self.companyItem.property) resignFirstResponder];
        [((UITextField *)self.phoneItem.property) resignFirstResponder];
        
        ///设置选择的VC
        self.pickerVC = [[QSDatePickerViewController alloc] init];
        self.pickerVC.pickerType = kPickerType_Item;
        self.pickerVC.dataSource = [[NSMutableArray alloc] initWithArray:@[@"女",@"男"]];
        self.pickerVC.onCancelButtonHandler = ^{
            
            [ASDepthModalViewController dismiss];
            
        };
        self.pickerVC.onItemConfirmButtonHandler = ^(NSInteger index, NSString *item){
            
            ///更换标题
            UILabel *titleLabel = [textField.rightView subviews][0];
            titleLabel.text = item;
            
            [ASDepthModalViewController dismiss];
            
        };
        
        ///用动画弹框
        [ASDepthModalViewController presentView:self.pickerVC.view];
        
        return NO;
        
    }
    
    
    ///如果是默认配送地址选择框，则弹出选择框
    if (textField == self.isMasterItem.property) {
        
        [((UITextField *)self.userNameItem.property) resignFirstResponder];
        [((UITextField *)self.addressItem.property) resignFirstResponder];
        [((UITextField *)self.companyItem.property) resignFirstResponder];
        [((UITextField *)self.phoneItem.property) resignFirstResponder];
        
        ///设置选择的VC
        self.pickerVC = [[QSDatePickerViewController alloc] init];
        self.pickerVC.pickerType = kPickerType_Item;
        self.pickerVC.dataSource = [[NSMutableArray alloc] initWithArray:@[@"是",@"否"]];
        self.pickerVC.onCancelButtonHandler = ^{
            
            [ASDepthModalViewController dismiss];
            
        };
        self.pickerVC.onItemConfirmButtonHandler = ^(NSInteger index, NSString *item){
            
            ///更换标题
            UILabel *titleLabel = [textField.rightView subviews][0];
            titleLabel.text = item;
            
            [ASDepthModalViewController dismiss];
            
        };
        
        ///用动画弹框
        [ASDepthModalViewController presentView:self.pickerVC.view];
        
        return NO;
        
    }
    
    return YES;
    
}

///键盘回收
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
    
}

@end
