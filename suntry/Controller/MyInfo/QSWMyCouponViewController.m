//
//  QSWMyCouponViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWMyCouponViewController.h"
#import "QSWSettingCell.h"
#import "QSWSettingItem.h"
#import "QSWSettingGroup.h"
#import "QSWSettingArrowItem.h"

@interface QSWMyCouponViewController ()

@end

@implementation QSWMyCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的优惠券";
      [self setupGrounp0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupGrounp0
{

    QSWSettingGroup *group = [self addGroup];
    
    QSWSettingItem *item = [QSWSettingItem itemWithIcon:@"home_car_selected" title:@"李先生:119110118" subtitle:@"地址:天河体育西108号"];
    
    group.items = @[item];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;

}

@end
