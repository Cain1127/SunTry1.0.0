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

@interface QSWEditSendAdsViewController ()

@end

@implementation QSWEditSendAdsViewController

- (void)viewDidLoad {
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
    
       QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"李易"];
    
    
    group.items = @[item];
    
}

-(void)setupGroup1
{
    
    QSWSettingGroup *group = [self addGroup];
    
        QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"您的性别"];
    
    
    group.items = @[item];
    
}

-(void)setupGroup2
{
    
    QSWSettingGroup *group = [self addGroup];
    
        QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"城建大厦5楼广州七升"];
    
    
    group.items = @[item];
    
}

-(void)setupGroup3
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"七升科技有限公司"];
    
    
    group.items = @[item];
    
}

-(void)setupGroup4
{
    
    QSWSettingGroup *group = [self addGroup];
    
        QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"1380013800"];
    
    
    group.items = @[item];
    
}

-(void)setupGroup5
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"设为默认配送地址"];
    
    
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
    [footterButton setBackgroundImage:[UIImage imageNamed:@"nav_backgroud"] forState:UIControlStateNormal];
    [footterButton setBackgroundImage:[UIImage imageNamed:@"nav_backgroud"] forState:UIControlStateHighlighted];
    [footterButton setTitle:@"保存修改" forState:UIControlStateNormal];
    footterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [footterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
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
    [footterButton1 setBackgroundImage:[UIImage imageNamed:@"nav_backgroud"] forState:UIControlStateNormal];
    [footterButton1 setBackgroundImage:[UIImage imageNamed:@"nav_backgroud"] forState:UIControlStateHighlighted];
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
