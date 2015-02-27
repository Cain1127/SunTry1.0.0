//
//  QSWUserSettingViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWUserSettingViewController.h"
#import "QSWSettingCell.h"
#import "QSWSettingItem.h"
#import "QSWSettingGroup.h"
#import "QSWSettingArrowItem.h"
#import "DeviceSizeHeader.h"
#import "QSWTheSuntryView.h"
#import "QSWServiceTermViewController.h"

@interface QSWUserSettingViewController ()

@end

@implementation QSWUserSettingViewController

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
    [navTitle setText:@"帐户设置"];
    self.navigationItem.titleView = navTitle;
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    
}

-(void)setupGroup0
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWSettingArrowItem *item = [QSWSettingArrowItem itemWithIcon:nil title:@"服务条款" destVcClass:[QSWServiceTermViewController class]];
    group.items = @[item];
    
}

-(void)setupGroup1
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWSettingArrowItem *item = [QSWSettingArrowItem itemWithIcon:nil title:@"检查更新" destVcClass:nil];
    group.items = @[item];
    
}

-(void)setupGroup2
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWSettingArrowItem *item = [QSWSettingArrowItem itemWithIcon:nil title:@"关于香哉" destVcClass:[QSWTheSuntryView class]];
    group.items = @[item];
    
}

#pragma mark - 返回事件
- (void)turnBackAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
