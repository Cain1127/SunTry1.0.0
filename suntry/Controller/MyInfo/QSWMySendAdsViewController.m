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
#import "QSWEditSendAdsViewController.h"
#import "MJRefresh.h"

#import "QSUserAddressListReturnData.h"

#import "QSRequestManager.h"

@interface QSWMySendAdsViewController ()

@property (nonatomic,retain) NSMutableArray *dataSource;//!<地址数据源

@end

@implementation QSWMySendAdsViewController

#pragma mark - UI搭建
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title=@"送餐地址管理";
    [self setupGrounp0];
    [self setupFooter];
    
    ///初始化数据源
    self.dataSource = [[NSMutableArray alloc] init];
    
    ///获取本地数据
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/user_send_address"];
    NSData *tempData = [NSData dataWithContentsOfFile:path];
    NSArray *tempList = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
    if (tempList && [tempList count] > 0) {
        
        [self.dataSource addObjectsFromArray:tempList];
        
    }
    
    [self.tableView reloadData];
    
    ///添加头部刷新
    [self.tableView addHeaderWithTarget:self action:@selector(getUserAddressList)];
    
    ///开始就头部刷新
    [self.tableView headerBeginRefreshing];
    
}

-(void)setupGrounp0
{
    
    QSWSettingGroup *group = [self addGroup];
    QSWSettingItem *item = [QSWSettingItem itemWithTitle:@"暂无记录"];
    group.items = @[item];

}

#pragma mark - 返回每个地址信息cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([self.dataSource count] > 0) {
        
        QSWSettingCell *normalCell = [QSWSettingCell cellWithTableView:tableView];
        
        ///获取地址模型
        QSUserAddressDataModel *addressModel = self.dataSource[indexPath.row];
        
        ///创建item
        QSWSettingButtonItem *tempItem = [QSWSettingButtonItem itemWithIcon:nil title:[NSString stringWithFormat:@"%@    %@",addressModel.userName,addressModel.phone] subtitle:[NSString stringWithFormat:@"地址：%@",addressModel.address] destVcClass:nil];
        
        normalCell.item = tempItem;
        normalCell.indexPath = indexPath;
        
        ///取消选择状态
        normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ///添加分隔线
        UILabel *sepLine = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 59.5f, SIZE_DEFAULT_MAX_WIDTH, 0.5f)];
        sepLine.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
        [normalCell.contentView addSubview:sepLine];
        
        return normalCell;
        
    }
    
    QSWSettingCell *cell = [QSWSettingCell cellWithTableView:tableView];
    QSWSettingGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    cell.indexPath = indexPath;
    
    ///取消选择状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ///添加分隔线
    UILabel *sepLine = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 59.5f, SIZE_DEFAULT_MAX_WIDTH, 0.5f)];
    sepLine.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    [cell.contentView addSubview:sepLine];
    
    return cell;

}

- (void)setupFooter
{
    
    ///按钮
    UIButton *footterButton = [[UIButton alloc] init];
    CGFloat footterButtonX = SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 2;
    CGFloat footterButtonY = 10;
    CGFloat footterButtonW = self.tableView.frame.size.width - 2 * footterButtonX;
    CGFloat footterButtonH = 44;
    footterButton.frame = CGRectMake(footterButtonX, footterButtonY, footterButtonW, footterButtonH);
    
    ///背景和文字
    [footterButton setBackgroundImage:[UIImage imageNamed:@"nav_backgroud"] forState:UIControlStateNormal];
    [footterButton setBackgroundImage:[UIImage imageNamed:@"nav_backgroud"] forState:UIControlStateHighlighted];
    [footterButton setTitle:@"新增送餐地址" forState:UIControlStateNormal];
    footterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [footterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    ///footer
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

#pragma mark - 返回有多少个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if ([self.dataSource count] > 0) {
        
        return [self.dataSource count];
        
    }
    
    return 1;

}

#pragma mark - 请求用户的送餐地址列表
///请求用户的送餐地址列表
- (void)getUserAddressList
{

    [QSRequestManager requestDataWithType:rRequestTypeUserSendAddressList andParams:@{@"status" : @"0"} andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///清空数据
        [self.dataSource removeAllObjects];
        
        ///请成功，并有数据
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///转换模型
            QSUserAddressListReturnData *tempModel = resultData;
            
            ///判断是否有数据
            if ([tempModel.addressList count] > 0) {
                
                [self.dataSource addObjectsFromArray:tempModel.addressList];
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/user_send_address"];
                
                ///把地址信息coding在本地
                NSData *tempData = [NSKeyedArchiver archivedDataWithRootObject:tempModel.addressList];
                [tempData writeToFile:path atomically:YES];
                
            }
            
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            ///刷新数据
            [self.tableView reloadData];
            
            ///结束刷新动画
            [self.tableView headerEndRefreshing];
            
        });
        
    }];
    
}

@end
