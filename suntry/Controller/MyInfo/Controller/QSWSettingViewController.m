//
//  QSWSettingViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWSettingViewController.h"
#import "QSWSettingGroup.h"
#import "QSWSettingCell.h"
#import "QSWSettingArrowItem.h"
#import "QSWSettingButtonItem.h"
#import "CommonHeader.h"
#import "DeviceSizeHeader.h"
#import "QSWTextFieldItem.h"
#import "QSWLoginViewController.h"

@interface QSWSettingViewController ()<UITextFieldDelegate>

@end

@implementation QSWSettingViewController

- (NSMutableArray *)groups
{
    
    if (_groups == nil) {
        
        _groups = [NSMutableArray array];
        
    }
    
    return _groups;
    
}

- (QSWSettingGroup *)addGroup
{
    
    QSWSettingGroup *group = [QSWSettingGroup group];
    [self.groups addObject:group];
    return group;
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    
    return [super initWithStyle:UITableViewStyleGrouped];
    
}

- (id)init
{
    
    return [super initWithStyle:UITableViewStyleGrouped];
    
}

- (void)viewDidAppear:(BOOL)animated {}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    ///自身背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.sectionHeaderHeight = SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    self.tableView.sectionFooterHeight = 0;
    
    ///取消分隔样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (iOS7) {
        
        self.tableView.contentInset = UIEdgeInsetsMake(-20.0f, 0, 0, 0);
        
    }
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.groups.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    QSWSettingGroup *group = self.groups[section];
    return group.items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QSWSettingCell *cell = [QSWSettingCell cellWithTableView:tableView];
    QSWSettingGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    cell.indexPath = indexPath;
    
    ///取消选择状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - 代理
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    
    QSWSettingGroup *group = self.groups[section];
    return group.footer;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    QSWSettingGroup *group = self.groups[section];
    return group.header;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /// 1.取出模型
    QSWSettingGroup *group = self.groups[indexPath.section];
    QSWSettingItem *item = group.items[indexPath.row];
    
    /// 2.操作
    if (item.operation) {
        
        item.operation();
        
    }
    
    /// 3.右侧类型
    ///右侧是跳转箭头
    if ([item isKindOfClass:[QSWSettingArrowItem class]]) {
        
        QSWSettingArrowItem *arrowItem = (QSWSettingArrowItem *)item;
        if (arrowItem.destVcClass) {
            UIViewController *destVc = [[arrowItem.destVcClass alloc] init];
            destVc.title = arrowItem.title;
            ///隐藏tabbar
            destVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:destVc animated:YES];
        }
        
    }
    
    ///右侧是按钮
    if ([item isKindOfClass:[QSWSettingButtonItem class]]) {
        
        QSWSettingButtonItem *buttonItem = (QSWSettingButtonItem*)item;
        if (buttonItem.destVcClass) {
            
            UIViewController *destVc = [[buttonItem.destVcClass alloc] init];
            destVc.title = buttonItem.title;
            [self.navigationController pushViewController:destVc animated:YES];
            
        }
    }
    
}

@end
