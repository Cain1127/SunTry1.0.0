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

@interface QSWUserSettingViewController ()

@end

@implementation QSWUserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"帐户设置";
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    
}

-(void)setupGroup0
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWSettingArrowItem *item = [QSWSettingArrowItem itemWithIcon:nil title:@"服务条款" destVcClass:nil];
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
    
    QSWSettingArrowItem *item = [QSWSettingArrowItem itemWithIcon:nil title:@"关于香哉" destVcClass:nil];
    group.items = @[item];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
