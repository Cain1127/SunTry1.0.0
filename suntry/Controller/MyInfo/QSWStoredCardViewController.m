//
//  QSWStoredCardViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWStoredCardViewController.h"
#import "QSWStoredCardCell.h"

#import "DeviceSizeHeader.h"
#import "ColorHeader.h"

#import "QSStoredCardDataModel.h"
#import "QSUserStoredCardReturnData.h"
#import "QSRequestTaskDataModel.h"
#import "QSUserInfoDataModel.h"

#import "QSRequestManager.h"
#import "QSUserManager.h"

#import "MJRefresh.h"
#import "MBProgressHUD.h"

#import "QSResetStoreCardPaypswViewController.h"
#import "QSWPayOrderViewController.h"

@interface QSWStoredCardViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;               //!<顶部view
@property (weak, nonatomic) IBOutlet UIView *middleView;            //!<中间view,放充值记录，消费记录按钮
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;         //!<余额文字label
@property (weak, nonatomic) IBOutlet UILabel *balanceCountLabel;    //!<余额数label
@property (weak, nonatomic) IBOutlet UILabel *payPswLabel;          //!<支付密码label
@property (weak, nonatomic) IBOutlet UIButton *chargeButton;        //!<充值按钮
@property (weak, nonatomic) IBOutlet UIButton *resetPswButton;      //!<重置密码按钮
@property (weak, nonatomic) IBOutlet UIButton *chargeRecord;        //!<充值记录按钮
@property (weak, nonatomic) IBOutlet UIButton *consumeRecord;       //!<消费记录按钮
@property (nonatomic, strong) UITableView *tabbleView;              //!<充值，消费记录view
@property (nonatomic, retain) NSMutableArray *storedCardDataSource; //!<充值卡信息数据源

@property (nonatomic,retain) MBProgressHUD *hud;                    //!<HUD

@end

@implementation QSWStoredCardViewController

#pragma mark - 初始化
- (instancetype)init
{
    
    if (self = [super init]) {
        
        self.pageGap = 2;
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
///UI搭建
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ///标题
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"我的储值卡"];
    self.navigationItem.titleView = navTitle;
    
    ///自定义返回按钮
    UIBarButtonItem *turnBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(turnBackAction)];
    turnBackButton.tintColor = [UIColor whiteColor];
    
    ///设置返回按钮的颜色
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = turnBackButton;
    
    [self setupTopView];
    [self setupMiddleView];
    [self setupBottomView];
    
}

#pragma mark - 控件加载
///加载顶部view
-(void)setupTopView
{
    
    CGFloat topViewH = 176.0f;
    _topView.frame = CGRectMake(0.0f, (iOS7 ? 64.0f : 0.0f), SIZE_DEVICE_WIDTH, topViewH);
    
    _balanceLabel.frame = CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.0f, 150.0f, _topView.frame.size.height * 1.0f / 4.0f);
    _balanceCountLabel.frame = CGRectMake(SIZE_DEVICE_WIDTH - 100.0f - SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.0f, 100.0f, topViewH * 1.0f / 4.0f);
    _balanceCountLabel.textAlignment = NSTextAlignmentRight ;
    
    _payPswLabel.frame = CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, _balanceLabel.frame.origin.y+_balanceLabel.frame.size.height, SIZE_DEVICE_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, topViewH * 1.0f / 4.0f);
    
    ///显示当前用户的余额
    QSUserInfoDataModel *userModel = [QSUserManager getCurrentUserData];
    self.balanceCountLabel.text = [NSString stringWithFormat:@"￥%@",userModel.balance];
    
    ///加边框
    UIView *lineTopView = [[UIView alloc] initWithFrame:CGRectMake(_payPswLabel.frame.origin.x, _payPswLabel.frame.origin.y, _payPswLabel.frame.size.width, 0.5f)];
    lineTopView.backgroundColor=COLOR_CHARACTERS_ROOTLINE;
    
    ///加边框
    UIView *lineBottomView = [[UIView alloc] initWithFrame:CGRectMake(_payPswLabel.frame.origin.x, _payPswLabel.frame.origin.y+_payPswLabel.frame.size.height, _payPswLabel.frame.size.width, 0.5f)];
    [_topView addSubview:lineTopView];
    [_topView addSubview:lineBottomView];
    lineBottomView.backgroundColor=COLOR_CHARACTERS_ROOTLINE;
    
    _chargeButton.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, _payPswLabel.frame.origin.y+_payPswLabel.frame.size.height+topViewH*1.0f/8.0f,(SIZE_DEVICE_WIDTH-3.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)*0.5f, 44.0f);
    _chargeButton.backgroundColor=COLOR_CHARACTERS_RED;
    _chargeButton.layer.cornerRadius=6.0f;
    
    _resetPswButton.frame=CGRectMake(2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT+_chargeButton.frame.size.width, _payPswLabel.frame.origin.y+_payPswLabel.frame.size.height+topViewH*1/8,(SIZE_DEVICE_WIDTH-3*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)*0.5, 44.0f);
    _resetPswButton.backgroundColor=COLOR_CHARACTERS_RED;
    _resetPswButton.layer.cornerRadius=6.0f;
    
}

///加载中间view
-(void)setupMiddleView
{
    
    _middleView.frame=CGRectMake(0, _topView.frame.origin.y+_topView.frame.size.height, SIZE_DEVICE_WIDTH, 45.0f);
    _middleView.backgroundColor=[UIColor whiteColor];
    
    _chargeRecord.frame=CGRectMake(0, 0, SIZE_DEVICE_WIDTH*0.5f, 45.0f);
    _chargeRecord.selected = YES;
    
    _consumeRecord.frame=CGRectMake(_chargeRecord.frame.size.width, 0, SIZE_DEVICE_WIDTH*0.5f, 45.0f);
    
    ///加边框
    UIView *lineTopView = [[UIView alloc] initWithFrame:CGRectMake(_consumeRecord.frame.origin.x,0,0.5f,45.0f)];
    lineTopView.backgroundColor=[UIColor lightGrayColor];
    
    ///加边框
    UIView *lineBottomView = [[UIView alloc] initWithFrame:CGRectMake(_chargeRecord.frame.origin.x, 44.5f, SIZE_DEVICE_WIDTH, 0.5f)];
    lineBottomView.backgroundColor=[UIColor lightGrayColor];
    
    [_middleView addSubview:lineTopView];
    [_middleView addSubview:lineBottomView];
    
}

///加载底部collertionView
-(void)setupBottomView
{
    
    ///初始化tabbleView
    self.tabbleView=[[UITableView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, _middleView.frame.origin.y + _middleView.frame.size.height, SIZE_DEVICE_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - _middleView.frame.origin.y - _middleView.frame.size.height - 49.0f)];
    
    [self.view addSubview:self.tabbleView];
    
    self.tabbleView.delegate=self;
    self.tabbleView.dataSource=self;
    
    ///取消边线样式
    //self.tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ///取消滚动条
    self.tabbleView.showsHorizontalScrollIndicator = NO;
    self.tabbleView.showsVerticalScrollIndicator = NO;
    
    ///头部刷新
    [self.tabbleView addHeaderWithTarget:self action:@selector(getChargeRecordList)];
    
    ///开始就刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tabbleView headerBeginRefreshing];
        
    });
    
}

#pragma mark - UItabbleViewDataSource数据源方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0f;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    ///如果列表有数据，则显示数据个数，否则显示暂无记录
    if (self.storedCardDataSource.count > 0) {
        
        return self.storedCardDataSource.count;
        
    }
    
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///判断是否是显示暂无记录提示
    if ([self.storedCardDataSource count] <= 0) {
        
        static NSString * noRecordCellName = @"noRecordCell";
        
        UITableViewCell *cellNoRecord= [tableView dequeueReusableCellWithIdentifier:noRecordCellName];
        
        if (cellNoRecord == nil) {
            
            cellNoRecord = [[QSWStoredCardCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f)];
            
        }
        
        ///加载暂无记录提示
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 14.0f, SIZE_DEFAULT_MAX_WIDTH, 30.0f)];
        tipsLabel.text = @"暂无记录";
        tipsLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.textColor = COLOR_CHARACTERS_ROOTLINE;
        [cellNoRecord.contentView addSubview:tipsLabel];
        cellNoRecord.selectionStyle=UITableViewScrollPositionNone;
        
        return cellNoRecord;
        
    } else {
        
        static NSString * CellIdentifier = @"normalInfoCell";
        
        QSWStoredCardCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            cell = [[QSWStoredCardCell alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_HOME_BANNAR_HEIGHT, 0.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f)];
            
            
        }
        
        ///获取模型
        QSStoredCardDataModel *tempModel = self.storedCardDataSource[indexPath.row];
        
        cell.cTimeLabel.text = tempModel.createTime;
        if (_chargeRecord.selected){
            
            cell.cPrcieLabel.text=[NSString stringWithFormat:@"￥+%@",tempModel.amount];
            
        }
        
        if (_consumeRecord.selected) {
            
            cell.cPrcieLabel.text=[NSString stringWithFormat:@"￥-%@",tempModel.amount];
            
        }
        
        cell.cBalanceLabel.text=tempModel.historybalance;
        
        ///取消选择样式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 44.0f;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    CGFloat viewW=SIZE_DEVICE_WIDTH-2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    CGFloat viewH=44.0f;
    
    UIView *headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
    headView.backgroundColor=[UIColor whiteColor];
    
    UILabel *cTimeLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0,viewW*1/3, viewH)];
    cTimeLabel.textColor = COLOR_CHARACTERS_ROOTLINE;
    cTimeLabel.textAlignment=NSTextAlignmentCenter;
    cTimeLabel.font=[UIFont systemFontOfSize:16.0f];
    
    UILabel *cPrcieLabel =[[UILabel alloc] initWithFrame:CGRectMake(viewW*1/3, 0, viewW*1/3, viewH)];
    cPrcieLabel.textColor = COLOR_CHARACTERS_ROOTLINE;
    cPrcieLabel.textAlignment=NSTextAlignmentCenter;
    cPrcieLabel.font=[UIFont systemFontOfSize:16.0f];
    
    UILabel *cBalanceLabel =[[UILabel alloc] initWithFrame:CGRectMake(viewW*2/3, 0, viewW*1/3, viewH)];
    cBalanceLabel.textColor = COLOR_CHARACTERS_ROOTLINE;
    cBalanceLabel.textAlignment=NSTextAlignmentCenter;
    cBalanceLabel.font=[UIFont systemFontOfSize:16.0f];
    
    [headView addSubview:cTimeLabel];
    [headView addSubview:cPrcieLabel];
    [headView addSubview:cBalanceLabel];
    
    if (_chargeRecord.selected){
        
        cTimeLabel.text=@"充值时间";
        cPrcieLabel.text=@"充值金额";
    }
    
    if (_consumeRecord.selected) {
        
        cTimeLabel.text=@"消费时间";
        cPrcieLabel.text=@"消费金额";
        
    }
    
    cBalanceLabel.text=@"余额";
    
    ///加边框
    UIView *lineTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5f, headView.frame.size.width, 0.5f)];
    lineTopView.backgroundColor=[UIColor lightGrayColor];
    [headView addSubview:lineTopView];
    return headView;
}

#pragma mark - 返回事件
- (void)turnBackAction
{
    
    ///判断是否是返回给定的页面
    if (self.pageGap > 2) {
        
        NSArray *vcArray = self.navigationController.viewControllers;
        NSInteger index = [vcArray count] - self.pageGap;
        if (index >= 0) {
            
            UIViewController *tempVC = self.navigationController.viewControllers[index];
            [self.navigationController popToViewController:tempVC animated:YES];
            
        } else {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        
        return;
        
    }
    
    ///正常返回
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 点击充值
///点击充值储存卡
- (IBAction)chargeButton:(id)sender
{
    
    QSWPayOrderViewController *VC=[[QSWPayOrderViewController alloc] initWithID:nil isTurnBack:YES];
    VC.buyStoreCardCallBack = ^(BOOL flag){
        
        if (flag) {
            
            [self getChargeRecordList];
            QSUserInfoDataModel *userModel = [QSUserManager getCurrentUserData];
            self.balanceCountLabel.text = [NSString stringWithFormat:@"￥ %@",userModel.balance];
            
        }
        
    };
    [self.navigationController pushViewController:VC animated:YES];
    
}

///点击重置密码
- (IBAction)resetPswButton:(id)sender
{
    
    QSResetStoreCardPaypswViewController *VC=[[QSResetStoreCardPaypswViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

///点击充值记录
- (IBAction)chargeRecord:(id)sender
{
    
    if (_chargeRecord.selected) {
        
        return;
        
    }
    
    _chargeRecord.selected = YES;
    _consumeRecord.selected = NO;
    [self.tabbleView addHeaderWithTarget:self action:@selector(getChargeRecordList)];
    
    ///显示HUD
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self getChargeRecordList];
    
}

///点击消费记录
- (IBAction)consumeRecord:(id)sender
{
    
    if (_consumeRecord.selected) {
        
        return;
        
    }
    
    _consumeRecord.selected = YES;
    _chargeRecord.selected = NO;
    [self.tabbleView addHeaderWithTarget:self action:@selector(getConsumRecordList)];
    
    ///显示HUD
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self getConsumRecordList];
    
}

///获取网络数据
-(void)getChargeRecordList
{
    
    //储值卡信息请求参数
    NSDictionary *dict = @{@"type":@"",@"key": @"",@"user_id":@"47",@"flag":@"income"};
    
    [QSRequestManager requestDataWithType:rRequestTypeStoredCard andParams:dict andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            //模型转换
            QSUserStoredCardReturnData *tempModel = resultData;
            NSArray *array = tempModel.storedCardListData.storedCardList;
            NSLog(@"QSStoredCardReturnData : %@",tempModel);
            
            //设置页码：当前页码/最大页码
            
            self.storedCardDataSource = [[NSMutableArray alloc]init];
            //清空的数据源
            [self.storedCardDataSource removeAllObjects];
            
            ///保存数据源
            [self.storedCardDataSource addObjectsFromArray:array];
            
            ///结束刷新动画
            [self.tabbleView headerEndRefreshing];
            
            ///reload数据
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.tabbleView reloadData];
                
            });
            
        } else {
            
            NSLog(@"================充值信息请求失败================");
            NSLog(@"error : %@",errorInfo);
            NSLog(@"================充值信息请求失败================");
            
        }
        
        ///移除HUD
        [self.hud hide:YES afterDelay:1.0f];
        
    }];
    
}

-(void)getConsumRecordList
{
    
    //用户充值卡信息请求参数
    NSDictionary *dict = @{@"type":@"",@"key": @"",@"user_id":@"47",@"flag":@"expand"};
    
    [QSRequestManager requestDataWithType:rRequestTypeStoredCard andParams:dict andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            //模型转换
            QSUserStoredCardReturnData *tempModel = resultData;
            NSArray *array = tempModel.storedCardListData.storedCardList;
            NSLog(@"QSStoredCardReturnData : %@",tempModel);
            
            //设置页码：当前页码/最大页码
            
            self.storedCardDataSource=[[NSMutableArray alloc]init];
            //清空的数据源
            [self.storedCardDataSource removeAllObjects];
            
            ///保存数据源
            [self.storedCardDataSource addObjectsFromArray:array];
            
            ///结束刷新动画
            [self.tabbleView headerEndRefreshing];
            
            ///reload数据
            [self.tabbleView reloadData];
            
        } else {
            
            NSLog(@"================消费信息请求失败================");
            NSLog(@"error : %@",errorInfo);
            NSLog(@"================消费信息请求失败================");
        }
        
        ///移除HUD
        [self.hud hide:YES afterDelay:1.0f];
        
    }];
    
}

@end
