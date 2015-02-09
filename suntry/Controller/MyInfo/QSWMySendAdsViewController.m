//
//  QSWMySendAdsViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWMySendAdsViewController.h"
#import "QSWSettingCell.h"
#import "QSWSettingItem.h"
#import "QSWSettingGroup.h"
#import "QSWSettingButtonItem.h"
#import "QSWSettingArrowItem.h"
#import "DeviceSizeHeader.h"
#import "QSWAddSendAdsViewController.h"

@interface QSWMySendAdsViewController ()

@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *adress;
@end

@implementation QSWMySendAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"送餐地址管理";
    [self setupGrounp0];
    [self setupFooter];
}

-(void)setupGrounp0
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWSettingButtonItem *item = [QSWSettingButtonItem itemWithIcon:nil title:@"李先生:119110118" subtitle:@"地址:天河体育西108号" destVcClass:nil];
    
    
    group.items = @[item];

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
    [footterButton setBackgroundImage:[UIImage imageNamed:@"nav_backgroud"] forState:UIControlStateNormal];
    [footterButton setBackgroundImage:[UIImage imageNamed:@"nav_backgroud"] forState:UIControlStateHighlighted];
    [footterButton setTitle:@"新增送餐地址" forState:UIControlStateNormal];
    footterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [footterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // footer
    UIView *footer = [[UIView alloc] init];
    CGFloat footerH = footterButtonH + 20;
    footer.frame = CGRectMake(0, 0, 0, footerH);
    self.tableView.tableFooterView = footer;
    [footer addSubview:footterButton];
    [footterButton addTarget:self action:@selector(gotoNextVC) forControlEvents:UIControlEventTouchUpInside];
}

///新增送餐地址按钮方法
-(void)gotoNextVC
{
    
    QSWAddSendAdsViewController *VC=[[QSWAddSendAdsViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 60.0f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
