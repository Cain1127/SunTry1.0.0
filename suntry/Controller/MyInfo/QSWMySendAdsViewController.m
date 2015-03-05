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
#import "ColorHeader.h"

#import "QSUserAddressListReturnData.h"

#import "QSRequestManager.h"
#import "QSUserManager.h"
#import "QSUserInfoDataModel.h"

@interface QSWMySendAdsViewController ()

@property (nonatomic,retain) NSMutableArray *dataSource;//!<地址数据源
///选择一个地址时的回调
@property (nonatomic,copy) void(^pickAddressAction)(BOOL flag,QSUserAddressDataModel *addressModel);

@end

@implementation QSWMySendAdsViewController

#pragma mark - 初始化
/**
 *  @author                     yangshengmeng, 15-03-04 18:03:38
 *
 *  @brief                      如若是选择地送餐地址，则回调所选择的地址
 *
 *  @param pickAddressAction    选择一个地址时的回调
 *
 *  @return                     返回当前地址列表
 *
 *  @since                      1.0.0
 */
- (instancetype)initWithCallBackBlock:(void(^)(BOOL flag,QSUserAddressDataModel *addressModel))pickAddressAction
{

    if (self = [super init]) {
        
        ///保存回调
        if (pickAddressAction) {
            
            self.pickAddressAction = pickAddressAction;
            
        }
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    ///自定义返回按钮
    UIBarButtonItem *turnBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(turnBackAction)];
    turnBackButton.tintColor = [UIColor whiteColor];
    
    ///设置返回按钮的颜色
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = turnBackButton;
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"送餐地址管理"];
    self.navigationItem.titleView = navTitle;
    
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
        
        ///获取用户模型
        QSUserInfoDataModel *userInfo = [QSUserManager getCurrentUserData];
        
        ///过滤数据
        for (QSUserAddressDataModel *obj in tempList) {
            
            if ([obj.userID isEqualToString:userInfo.userID]) {
                
                [self.dataSource addObject:obj];
                
            }
            
        }
        
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

#pragma mark - 返回事件
- (void)turnBackAction
{

    [self.navigationController popViewControllerAnimated:YES];

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
        
        return normalCell;
        
    }
    
    static NSString *cellNoneName = @"noneCell";
    UITableViewCell *noneCell = [tableView dequeueReusableCellWithIdentifier:cellNoneName];
    if (nil == noneCell) {
        
        noneCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNoneName];
        
    }
    
    ///取消选择状态
    noneCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ///虚线框
    UIView *noRecordView = [[UIView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f)];
    noRecordView.backgroundColor = [UIColor whiteColor];
    noRecordView.layer.borderColor = [[UIColor colorWithRed:194.0f / 255.0f green:181.0f / 255.0f blue:156.0f / 255.0f alpha:1.0f] CGColor];
    noRecordView.layer.borderWidth = 0.5f;
    noRecordView.layer.cornerRadius = 6.0f;
    
    ///标题Label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 5.0f, noRecordView.frame.size.width - 30.0f, noRecordView.frame.size.height - 10.0f)];
    titleLabel.text = @"暂无送餐地址";
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.textColor = COLOR_CHARACTERS_RED;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [noRecordView addSubview:titleLabel];
    
    [noneCell.contentView addSubview:noRecordView];
    
    return noneCell;

}

#pragma mark - 点击某一个送餐地址
///选择某一个送餐地址
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([self.dataSource count] > 0 && indexPath.row <= [self.dataSource count]) {
        
        ///模型
        QSUserAddressDataModel *tempModel = self.dataSource[indexPath.row];
        
        ///判断是否是选择地址
        if (self.pickAddressAction) {
            
            self.pickAddressAction(YES,tempModel);
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            QSWEditSendAdsViewController *editVC = [[QSWEditSendAdsViewController alloc] initWithAddressModel:tempModel];
            editVC.editSendAddressCallBack = ^(BOOL flag){
                
                if (flag) {
                    
                    [self.tableView headerBeginRefreshing];
                    
                }
                
            };
            [self.navigationController pushViewController:editVC animated:YES];
            
        }
        
    } else {
    
        if (self.pickAddressAction) {
            
            self.pickAddressAction (NO,nil);
            
        }
    
    }

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
    footterButton.backgroundColor=COLOR_CHARACTERS_RED;
    [footterButton setTitle:@"新增送餐地址" forState:UIControlStateNormal];
    footterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [footterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footterButton.layer.cornerRadius = 6.0f;
    
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
    
    QSWAddSendAdsViewController *addSendVC=[[QSWAddSendAdsViewController alloc] init];
    addSendVC.addSendAddressCallBack = ^(BOOL flag){
        
        if (flag) {
            
            ///刷新数据
            [self.tableView headerBeginRefreshing];
            
        }
        
    };
    [self.navigationController pushViewController:addSendVC animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 70.0f;
    
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
        
        ///请成功，并有数据
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///清空数据
            [self.dataSource removeAllObjects];
            
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
                
            } else {
                
                ///清空数据
                [self.dataSource removeAllObjects];
            
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/user_send_address"];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    
                    NSError *error = nil;
                    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                    if (error) {
                        
                        NSLog(@"===============清空本地送餐地址失败=================");
                        
                    } else {
                        
                        NSLog(@"===============清空本地送餐地址成功=================");
                        
                    }
                    
                }
            
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
