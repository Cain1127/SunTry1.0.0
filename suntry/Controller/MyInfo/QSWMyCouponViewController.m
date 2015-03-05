//
//  QSWMyCouponViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWMyCouponViewController.h"
#import "QSUserCouponTableViewCell.h"
#import "MBProgressHUD.h"
#import "QSBlockButton.h"

#import "QSUserCouponListReturnData.h"
#import "QSCouponInfoDataModel.h"

#import "QSRequestManager.h"

#import "ColorHeader.h"
#import "DeviceSizeHeader.h"

#import "MJRefresh.h"

@interface QSWMyCouponViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITextField *inputField;       //!<输入框
@property (nonatomic,strong) UITableView *couponListView;   //!<优惠券列表
@property (nonatomic,retain) NSMutableArray *dataSource;    //!<优惠券数据
@property (nonatomic,strong) MBProgressHUD *hud;            //!<HUD

///选择优惠券时的回调
@property (nonatomic,copy) void(^pickCouponCallBack)(BOOL flag,id couponModel);

@end

@implementation QSWMyCouponViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-05 10:03:59
 *
 *  @brief          创建一个选择优惠券的优惠卷列表
 *
 *  @param callBack 选择一张优惠券时的回调
 *
 *  @return         返回当前优惠券选择窗口
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPickedCallBack:(void(^)(BOOL flag,id couponModel))callBack
{

    if (self = [super init]) {
        
        ///保存回调
        if (callBack) {
            
            self.pickCouponCallBack = callBack;
            
        }
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    ///设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    [navTitle setText:@"我的优惠券"];
    self.navigationItem.titleView = navTitle;
    
    ///头信息
    [self setupHeader];
    
    ///初始化数据源
    self.dataSource = [[NSMutableArray alloc] init];
    
    ///优惠券列表
    self.couponListView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, (iOS7 ? 72.0f + 44.0f + 5.0f : 8.0f + 44.0f + 5.0f), SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 49.0f - 64.0f - 44.0f - 13.0f)];
    
    ///取消滚动条
    self.couponListView.showsHorizontalScrollIndicator = NO;
    self.couponListView.showsVerticalScrollIndicator = NO;
    
    ///取消分隔样式
    self.couponListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ///设置代理和数据源
    self.couponListView.delegate = self;
    self.couponListView.dataSource = self;
    
    ///添加头部刷新
    [self.couponListView addHeaderWithTarget:self action:@selector(getUserCouponList)];
    [self.couponListView addFooterWithTarget:self action:@selector(getMoreUserCouponList)];
    
    [self.view addSubview:self.couponListView];
    
    ///一进入此页面就请求数据
    [self.couponListView headerBeginRefreshing];
    
}

- (void)setupHeader
{

    ///1.添加textfield输入框控件
    self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, (iOS7 ? 72.0f : 8.0f), SIZE_DEFAULT_MAX_WIDTH - 49.0f, 44.0f)];
    self.inputField.placeholder = @"输入您的优惠编码";
    self.inputField.returnKeyType = UIReturnKeyDone;
    self.inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputField.delegate = self;
    self.inputField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.inputField];
    
    ///2.添加按钮
    UIButton *addButton = [UIButton createBlockButtonWithFrame:CGRectMake(self.inputField.frame.origin.x + self.inputField.frame.size.width + 5.0f, self.inputField.frame.origin.y, 44.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///校验编码
        [self addButtonAction];
        
    }];
    addButton.layer.cornerRadius = 6.0f;
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    addButton.backgroundColor=COLOR_CHARACTERS_RED;
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton setTitleColor:COLOR_CHARACTERS_RED forState:UIControlStateHighlighted];
    addButton.layer.cornerRadius=6.0f;
    [self.view addSubview:addButton];
    
}

#pragma mark - 请求优惠券列表
///获取个人优惠券列表
- (void)getUserCouponList
{

    ///请求第一页数据
    [QSRequestManager requestDataWithType:rRequestTypeUserCouponList andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///获取成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///清空原数据
            [self.dataSource removeAllObjects];
            
            ///转换模型
            QSUserCouponListReturnData *couponData = resultData;
            
            if ([couponData.couponListHeader.couponList count] > 0) {
                
                [self.dataSource addObjectsFromArray:couponData.couponListHeader.couponList];
                
            }
            
            ///刷新UI
            [self.couponListView reloadData];
            
        }
        
        ///结束刷新动画
        [self.couponListView headerEndRefreshing];
        
    }];

}

- (void)getMoreUserCouponList
{

    

}

#pragma mark - 返回事件
- (void)turnBackAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 添加优惠券
///添加优惠券
-(void)addButtonAction
{

    ///获取优惠券key
    NSString *couponKey = self.inputField.text;
    if (nil == couponKey || 0 >= [couponKey length]) {
        
        [self.inputField becomeFirstResponder];
        return;
        
    }
    
    ///回收键盘
    [self.inputField resignFirstResponder];
    
    ///显示HUD
    self.hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    self.hud.labelText = @"正在添加……";
    
    ///封装参数
    NSDictionary *params = @{@"coup_code" : couponKey};
    
    ///请求优惠券
    [QSRequestManager requestDataWithType:rRequestTypeUserGetCoupon andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///获取成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///头数据模型
            QSHeaderDataModel *tempModel = resultData;
            
            ///刷新优惠券列表
            [self.couponListView headerBeginRefreshing];
            
            ///清空输入信息
            self.inputField.text = @"";
            
            ///结束HUD
            self.hud.labelText = tempModel.info ? tempModel.info : @"添加成功！";
            [self.hud hide:YES afterDelay:1.0f];
            
            ///刷新数据
            [self.couponListView headerEndRefreshing];
            
        } else if (rRequestResultTypeFail == resultStatus) {
        
            ///领取失败
            self.hud.labelText = @"领取失败！";
            [self.hud hide:YES afterDelay:1.0f];
        
        } else {
            
            ///判断是否存在服务端的返回
            QSHeaderDataModel *tempModel = resultData;
        
            ///结束HUD
            self.hud.labelText = tempModel ? (tempModel.info ? tempModel.info : @"添加失败，请稍后再试！") : @"添加失败，请稍后再试！";
            [self.hud hide:YES afterDelay:1.0f];
        
        }
        
    }];
    
}

#pragma mark - 返回行高
///返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 90.0f;

}

#pragma mark - 返回有多少优惠券数量
///返回有多少优惠券数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if ([self.dataSource count] <= 0) {
        
        return 1;
        
    }
    
    return [self.dataSource count];

}

#pragma mark - 返回每个优惠券信息
///返回每个优惠券信息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///如果没有数据，则显示暂无记录
    if ([self.dataSource count] <= 0) {
        
        static NSString *noneCell = @"noneCell";
        UITableViewCell *cellNone = [tableView dequeueReusableCellWithIdentifier:noneCell];
        if (nil == cellNone) {
            
            cellNone = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noneCell];
            
        }
        
        ///取消选择样式
        cellNone.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ///创建暂无记录
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 10.0f, SIZE_DEFAULT_MAX_WIDTH, 70.0f)];
        tipsLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        tipsLabel.textColor = COLOR_HEXCOLOR(0x939598);
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.text = @"暂无记录";
        [cellNone.contentView addSubview:tipsLabel];
        
        return cellNone;
        
    } else {
        
        static NSString *normalCell = @"normalCell";
        QSUserCouponTableViewCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:normalCell];
        if (nil == cellNormal) {
            
            cellNormal = [[QSUserCouponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell];
            
        }
        
        ///取消选择样式
        cellNormal.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ///更新数据
        [cellNormal updateUserCouponInfoCellUI:self.dataSource[indexPath.row]];
        
        return cellNormal;
        
    }

}

#pragma mark - 选择优惠券
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.pickCouponCallBack && [self.dataSource count] > 0) {
        
        self.pickCouponCallBack(YES,self.dataSource[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }

}

@end
