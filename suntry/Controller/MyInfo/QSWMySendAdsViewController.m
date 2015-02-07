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
#import "QSWSettingArrowItem.h"

@interface QSWMySendAdsViewController ()

@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *adress;
@end

@implementation QSWMySendAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的送餐的址";
    [self setupGrounp0];
  
}

-(void)setupGrounp0
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWSettingArrowItem *item = [QSWSettingArrowItem itemWithIcon:nil title:@"李先生:119110118" subtitle:@"地址:天河体育西108号" destVcClass:nil];
    
    
    group.items = @[item];

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
