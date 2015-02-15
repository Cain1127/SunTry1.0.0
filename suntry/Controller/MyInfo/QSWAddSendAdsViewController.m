//
//  QSWAddSendAdsViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/7.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWAddSendAdsViewController.h"
#import "QSWSettingCell.h"
#import "QSWSettingItem.h"
#import "QSWSettingGroup.h"
#import "QSWSettingArrowItem.h"
#import "QSWTextFieldItem.h"
#import "DeviceSizeHeader.h"
#import "QSRequestManager.h"
#import "ColorHeader.h"
#import "QSPickerViewItem.h"
#import "QSDatePickerViewController.h"
#import "QSUserInfoDataModel.h"

#import "ASDepthModalViewController.h"

@interface QSWAddSendAdsViewController ()<UITextFieldDelegate>

@property (nonatomic,retain) QSWTextFieldItem *userNameItem;        //!<用户名输入框模型
@property (nonatomic,retain) QSWTextFieldItem *genderItem;          //!<性别选择框模型
@property (nonatomic,retain) QSWTextFieldItem *addressItem;         //!<送餐地址输入框模型
@property (nonatomic,retain) QSWTextFieldItem *companyItem;         //!<所在公司输入框模型
@property (nonatomic,retain) QSWTextFieldItem *phoneItem;           //!<联系电话输入框模型
@property (nonatomic,retain) QSWTextFieldItem *isMasterItem;        //!<是否默认配送选择框模型

@property (nonatomic,retain) QSUserInfoDataModel *userInfo;         //!<用户信息模型
@property (nonatomic,strong) QSDatePickerViewController *pickerVC;  //!<选择器

@end

@implementation QSWAddSendAdsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    ///设置标题
    self.title=@"新增送餐地址";
    
    ///获取用户数据
    self.userInfo = [QSUserInfoDataModel userDataModel];
    
    ///每个功能cell
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
    self.userNameItem = [QSWTextFieldItem itemWithTitle: @"请填写联系人姓名" andDelegate:self];
    
    if ((self.userInfo && self.userInfo.realName)) {
        
        self.userNameItem.subtitle = self.userInfo.realName;
        
    }
    
    group.items = @[self.userNameItem];

}

-(void)setupGroup1
{
    
    ///性别默认信息
    NSString *genderTitle = @"男";
    
    if (self.userInfo && self.userInfo.gender) {
        
        if ([self.userInfo.gender intValue] == 1) {
            
            genderTitle = @"男";
            
        }
        
        if ([self.userInfo.gender intValue] == 0) {
            
            genderTitle = @"女";
            
        }
        
    }
    
    QSWSettingGroup *group = [self addGroup];
    self.genderItem = [QSPickerViewItem itemWithTitle:@"您的性别" andDelegate:self];
    [self.genderItem setValue:genderTitle forKey:@"rightTitle"];
    group.items = @[self.genderItem];
    
}

-(void)setupGroup2
{
    
    QSWSettingGroup *group = [self addGroup];
    self.addressItem = [QSWTextFieldItem itemWithTitle:@"送餐地址请尽量填写详细" andDelegate:self];
    
    ///获取系统的地址
    if (self.userInfo && self.userInfo.address) {
        
        self.addressItem.subtitle = self.userInfo.address;
        
    }
    
    group.items = @[self.addressItem];
    
}

-(void)setupGroup3
{
    
    QSWSettingGroup *group = [self addGroup];
    self.companyItem = [QSWTextFieldItem itemWithTitle:@"请输入公司全称" andDelegate:self];
    
    ///判断原来是否有数据
    if (self.userInfo && self.userInfo.company) {
        
        self.companyItem.subtitle = self.userInfo.company;
        
    }
    
    group.items = @[self.companyItem];
    
}

-(void)setupGroup4
{
    
    QSWSettingGroup *group = [self addGroup];
    self.phoneItem = [QSWTextFieldItem itemWithTitle:@"配送人员联系您的电话" andDelegate:self];
    
    ///获取本地用户电话
    if (self.userInfo && self.userInfo.phone) {
        
        self.phoneItem.subtitle = self.userInfo.phone;
        
    }
    
    group.items = @[self.phoneItem];
    
}

-(void)setupGroup5
{
    
    QSWSettingGroup *group = [self addGroup];
    self.isMasterItem = [QSPickerViewItem itemWithTitle:@"设为默认配送地址" andDelegate:self];
    [self.isMasterItem setValue:@"否" forKey:@"rightTitle"];
    group.items = @[self.isMasterItem];
    
}

- (void)setupFooter
{
    
    // 按钮
    UIButton *footterButton = [[UIButton alloc] init];
    CGFloat footterButtonX = SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 2;
    CGFloat footterButtonY = 10;
    CGFloat footterButtonW = self.tableView.frame.size.width - 2 * footterButtonX;
    CGFloat footterButtonH = 44;
    footterButton.frame = CGRectMake(footterButtonX, footterButtonY, footterButtonW, footterButtonH);
    
    // 背景和文字
    footterButton.backgroundColor=COLOR_CHARACTERS_RED;
    [footterButton setTitle:@"添加" forState:UIControlStateNormal];
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

#pragma mark - 确认添加地址
///确认添加地址
-(void)gotoNextVC
{

    

}


#pragma mark--UItextFieldDelegate方法
///开始编辑
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

///键盘回收
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [((UITextField *)self.userNameItem.property) resignFirstResponder];
    [((UITextField *)self.addressItem.property) resignFirstResponder];
    [((UITextField *)self.companyItem.property) resignFirstResponder];
    [((UITextField *)self.phoneItem.property) resignFirstResponder];
    
}

@end
