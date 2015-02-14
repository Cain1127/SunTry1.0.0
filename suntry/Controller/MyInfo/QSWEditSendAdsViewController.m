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

#import "QSUserAddressDataModel.h"

@interface QSWEditSendAdsViewController ()<UITextFieldDelegate>

@property (nonatomic,retain) QSUserAddressDataModel *addressModel;//!<地址数据模型

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
    
    self.title=@"编辑送餐地址";
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
    QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"用户名" andDelegate:self];
    item.subtitle = self.addressModel.userName;
    group.items = @[item];
    
}

-(void)setupGroup1
{
    
    QSWSettingGroup *group = [self addGroup];
    QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"性别" andDelegate:self];
    item.subtitle = ([self.addressModel.gender intValue] == 1) ? @"男" : @"女";
    group.items = @[item];
    
}

-(void)setupGroup2
{
    
    QSWSettingGroup *group = [self addGroup];
    QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"送餐地址" andDelegate:self];
    item.subtitle = self.addressModel.address;
    group.items = @[item];
    
}

-(void)setupGroup3
{
    
    QSWSettingGroup *group = [self addGroup];
    QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"公司" andDelegate:self];
    item.subtitle = self.addressModel.company;
    group.items = @[item];
    
}

-(void)setupGroup4
{
    
    QSWSettingGroup *group = [self addGroup];
    QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"联系电话" andDelegate:self];
    item.subtitle = self.addressModel.phone;
    group.items = @[item];
    
}

-(void)setupGroup5
{
    
    QSWSettingGroup *group = [self addGroup];
    QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"设为默认配送地址" andDelegate:self];
    item.subtitle = ([self.addressModel.is_master intValue] == 1) ? @"默认送餐地址" : @"设置为默认地址";
    group.items = @[item];
    
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
    footterButton1.backgroundColor=[UIColor colorWithRed:247.0f / 255.0f green:243.0f / 255.0f blue:245.0f / 255.0f alpha:1.0f];
    [footterButton1 setTitle:@"删除送餐地址" forState:UIControlStateNormal];
    footterButton1.titleLabel.font = [UIFont systemFontOfSize:14];
    [footterButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [footer addSubview:footterButton1];
    [footterButton1 addTarget:self action:@selector(gotoNextVC1) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark --按钮方法
///保存修改按钮方法
-(void)gotoNextVC
{
    
    
}

///删除送餐地址按钮方法
-(void)gotoNextVC1
{
    
    
}

@end
