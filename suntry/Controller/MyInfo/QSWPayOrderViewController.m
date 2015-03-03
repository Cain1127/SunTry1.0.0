//
//  QSWPayOrderViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWPayOrderViewController.h"
#import "QSWStoredCardViewController.h"
#import "QSStoreCarInfoCollectionViewCell.h"

#import "DeviceSizeHeader.h"
#import "QSRequestManager.h"
#import "QSRequestTaskDataModel.h"
#import "QSGoodsDataModel.h"
#import "QSGoodsListReturnData.h"

#import "MJRefresh.h"
#import "ColorHeader.h"
#import "QSUserManager.h"

#import "QSAlixPayManager.h"

#import "MBProgressHUD.h"

#import "QSUserInfoDataModel.h"
#import "QSAddOrderReturnData.h"
#import "QSOrderInfoDataModel.h"

@interface QSWPayOrderViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,assign) BOOL isTurnBack;                           //!<是否回退
@property (nonatomic, strong) UIView *nodataView;                       //!<没有储值卡view
@property (strong, nonatomic) UICollectionView *collectionView;         //!<每个充值按钮
@property (nonatomic,retain)  NSMutableArray *storedCardDataSource;     //!<充值卡信息数据源
@property (nonatomic,copy) NSString *selectedID;                        //!<当前选择状态的储值卡ID
@property (nonatomic,assign) int selectedIndex;                         //!<当前选择状态的下标

@property (nonatomic,retain) MBProgressHUD *hud;                        //!<HUD

@property (nonatomic,retain) QSOrderInfoDataModel *orderFormModel;      //!<订单模型

@end

@implementation QSWPayOrderViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-02-23 11:02:17
 *
 *  @brief              根据给定的储值卡ID创建储值卡购买页面
 *
 *  @param storeCarID   当前选择的储值卡ID
 *
 *  @return             返回当前创建的储值卡购买页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithID:(NSString *)storeCarID isTurnBack:(BOOL)flag
{
    
    if (self = [super init]) {
        
        ///保存当前选择的储值卡ID
        if (storeCarID) {
            
            self.selectedID = storeCarID;
            
        }
        
        self.isTurnBack = flag;
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
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
    [navTitle setText:@"支付订单"];
    self.navigationItem.titleView = navTitle;
    self.view.backgroundColor=[UIColor whiteColor];
    
    ///加载储值卡数据
    [self getStoredCardList];
    
    UILabel *userBanlaceLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT,(iOS7 ? 64.0f : 0.0f), 150.0f, 44.0f)];
    userBanlaceLabel.text=@"帐户余额";
    userBanlaceLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:userBanlaceLabel];
    
    UILabel *banlaceLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 100.0f - SIZE_DEFAULT_MARGIN_LEFT_RIGHT - 5.0f, userBanlaceLabel.frame.origin.y, 100.0f, 44.0f)];
    //banlaceLabel.text=@"￥0.0";
    banlaceLabel.textAlignment = NSTextAlignmentRight;
    banlaceLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:banlaceLabel];
    
    ///显示当前用户的余额
    QSUserInfoDataModel *userModel = [QSUserManager getCurrentUserData];
    banlaceLabel.text = [NSString stringWithFormat:@"￥%@",userModel.balance];
    
    ///分隔线
    UILabel *priceSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, userBanlaceLabel.frame.origin.y + userBanlaceLabel.frame.size.height - 0.25f, SIZE_DEFAULT_MAX_WIDTH, 0.25f)];
    priceSepLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [self.view addSubview:priceSepLabel];
    
    UILabel *storedCardPrice=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, userBanlaceLabel.frame.origin.y + userBanlaceLabel.frame.size.height, SIZE_DEVICE_WIDTH-2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f)];
    
    storedCardPrice.text=@"储值卡金额";
    [self.view addSubview:storedCardPrice];
    
    ///分隔线
    UILabel *storeSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, storedCardPrice.frame.origin.y + storedCardPrice.frame.size.height - 0.25f, SIZE_DEFAULT_MAX_WIDTH, 0.25f)];
    storeSepLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [self.view addSubview:storeSepLabel];
    
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    ///设置每个cell大小与位置
    CGFloat viewW = (SIZE_DEVICE_WIDTH - 5.0f * 8.0f) / 3.0f;
    CGFloat viewH = viewW - 10.0f;
    CGSize itemSize = CGSizeMake(viewW, viewH);
    flowLayout.itemSize = itemSize;
    flowLayout.sectionInset = UIEdgeInsetsMake(8.0f, 8.0f, 8.0f, 8.0f);
    
    ///初始化collectionView
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, storedCardPrice.frame.origin.y + storedCardPrice.frame.size.height, SIZE_DEVICE_WIDTH, viewH * 2.0f + 3.0f * 8.0f) collectionViewLayout:flowLayout];
    
    ///取消导航条
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.backgroundColor=[UIColor clearColor];
    
    ///注册Cell
    [self.collectionView registerClass:[QSStoreCarInfoCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [self.view addSubview:self.collectionView];
    
    ///分隔线
    UILabel *storeCardSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 3.75f, SIZE_DEFAULT_MAX_WIDTH, 0.25f)];
    storeCardSepLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [self.view addSubview:storeCardSepLabel];
    
    ///支付方式提示
    UILabel *payStyleTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 8.0f, SIZE_DEFAULT_MAX_WIDTH, 30.0f)];
    payStyleTipsLabel.text = @"支付方式";
    [self.view addSubview:payStyleTipsLabel];
    
    ///分隔线
    UILabel *payTipsSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, payStyleTipsLabel.frame.origin.y + payStyleTipsLabel.frame.size.height + 3.75f, SIZE_DEFAULT_MAX_WIDTH, 0.25f)];
    payTipsSepLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [self.view addSubview:payTipsSepLabel];
    
    ///支付方式
    UILabel *payStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, payTipsSepLabel.frame.origin.y + payTipsSepLabel.frame.size.height + 8.0f, SIZE_DEFAULT_MAX_WIDTH, 30.0f)];
    payStyleLabel.text = @"在线支付：支付宝支付";
    payStyleLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:payStyleLabel];
    
    ///分隔线
    UILabel *paySepLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, payStyleLabel.frame.origin.y + payStyleLabel.frame.size.height + 3.75f, SIZE_DEFAULT_MAX_WIDTH, 0.25f)];
    paySepLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [self.view addSubview:paySepLabel];
    
    ///提交支付
    UIButton *putPayButton=[[UIButton alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 44.0f - 60.0f - 10.0f,SIZE_DEFAULT_MAX_WIDTH, 44.0f)];
    [putPayButton setTitle:@"提交支付" forState:UIControlStateNormal];
    [putPayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    putPayButton.backgroundColor=COLOR_CHARACTERS_RED;
    putPayButton.layer.cornerRadius = 6.0f;
    
    [putPayButton addTarget:self action:@selector(putPayButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:putPayButton];
    
}

#pragma mark - 返回可购买的储值卡数量
///定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.storedCardDataSource count];
    
}

///定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
    
}

#pragma mark - 每一个储值卡信息cell
///每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///从复用队列中返回当前cell
    static NSString * CellIdentifier = @"UICollectionViewCell";
    QSStoreCarInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ///获取模型
    QSGoodsDataModel *tempModel = self.storedCardDataSource[indexPath.row];
    [cell updateStoreCardInfoCellUI:tempModel];
    
    ///判断是否第一行
    if (0 == indexPath.row && !(self.selectedID)) {
        
        cell.selected = YES;
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        
    } else if (self.selectedID && ([self.selectedID intValue] == [tempModel.goodsID intValue])) {
        
        cell.selected = YES;
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        
    }
    
    return cell;
    
}

#pragma mark - 提交支付按钮方法
///提交支付
-(void)putPayButtonAction
{
    
    
    /**
     *  user_id 用户id
     *  name 下订名字
     *  address 地址
     *  phone 电话
     *  expand_4 （必传参数，支付类型，3，储蓄卡支付；1在线支付，2餐到付款 ）
     *  mer_id 商家id
     *  total_money 总价
     *  get_time 要求获取的时间,字符串
     *  ortherPhone 其他电话
     *  desc 描述
     *  diet 菜牌的数量
     *  array() or json promotion 优惠数组
     *  array() or json coupon 优惠卷
     *  array() or json status 状态
     *  source_type 来源类型 1 为后台，2为ios手机端，3为android手机端，4为网站端
     *  latitude 经度，（可选）
     *  longitude 纬度（可选）
     *  diet_num 菜品总数
     *  pay_type是否已支付，必传参数，默认传0
     *  run_id 用户id
     *  run_type 操作类型，1代表为后台下单，2代表为线上下单
     */
    
    /**
     *  {
     "user_id":"47",
     "source_type":4,
     "diet_num":1,
     "total_money":"500",
     "get_time":"",
     "name":"充500送50",
     "address":"地址",
     "phone":"13430315807",
     "expand_4":"5",
     "mer_id":1,
     "desc":"在线购买储蓄卡金额",
     "diet":[{
     "goods_id":"94",
     "num":1,
     "sale_id":"",
     "sale_money":"500",
     "name":"充500送50"
     }],
     "pay_type":0,
     "run_id":"47",
     "run_type":"1"
     *  }
     *
     */
    
    ///判断当前是否存在选择状态的储值卡ID
    if (nil == self.selectedID || 0 >= self.selectedID.length) {
        
        return;
        
    }
    
    ///显示HUD
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ///判断是否再次支付
    if (self.orderFormModel) {
        
        ///进入支付宝
        [[QSAlixPayManager shareAlixPayManager] startAlixPay:self.orderFormModel];
        return;
    }
    
    ///储值卡模型
    __block QSGoodsDataModel *tempModel = self.storedCardDataSource[self.selectedIndex];
    
    ///用户信息模型
    QSUserInfoDataModel *userModel = [QSUserInfoDataModel userDataModel];
    
    ///暂存参数
    NSMutableDictionary *tempParams = [[NSMutableDictionary alloc] init];
    
    ///类型
    [tempParams setObject:tempModel.goodsTypeID forKey:@"source_type"];
    
    ///购买数量
    [tempParams setObject:@"1" forKey:@"diet_num"];
    
    ///买价
    [tempParams setObject:tempModel.goodsPrice forKey:@"total_money"];
    
    ///时间戳：储值卡购买不需要时间戳
    [tempParams setObject:@"" forKey:@"get_time"];
    
    ///订单标题
    [tempParams setObject:[NSString stringWithFormat:@"购买储蓄卡(%@)",tempModel.goodsName] forKey:@"name"];
    
    ///用户地址
    [tempParams setObject:userModel.address forKey:@"address"];
    
    ///用户手机号码
    [tempParams setObject:userModel.phone forKey:@"phone"];
    
    ///支付类型：5-在线支付
    [tempParams setObject:@"5" forKey:@"expand_4"];
    
    ///商户类型
    [tempParams setObject:@"1" forKey:@"mer_id"];
    
    ///订单说明
    [tempParams setObject:[NSString stringWithFormat:@"在线购买储蓄卡(￥%@)，%@",tempModel.goodsPrice,tempModel.goodsName] forKey:@"desc"];
    
    ///订单详情
    NSMutableArray *orderList = [[NSMutableArray alloc] init];
    NSMutableDictionary *orderDetail = [[NSMutableDictionary alloc] init];
    
    ///商品ID
    [orderDetail setObject:tempModel.goodsID forKey:@"goods_id"];
    
    ///购买数量
    [orderDetail setObject:@"1" forKey:@"num"];
    
    ///限时优惠使用字段
    [orderDetail setObject:@"" forKey:@"sale_id"];
    
    ///购买价格
    [orderDetail setObject:tempModel.goodsPrice forKey:@"sale_money"];
    
    ///商品名
    [orderDetail setObject:tempModel.goodsName forKey:@"name"];
    
    ///将商品放在参数里
    [orderList addObject:orderDetail];
    [tempParams setObject:orderList forKey:@"diet"];
    
    ///支付状态：0-未支付
    [tempParams setObject:@"0" forKey:@"pay_type"];
    
    ///用户ID
    [tempParams setObject:userModel.userID forKey:@"run_id"];
    
    ///下单方式：储值卡购买肯定为在线下单
    [tempParams setObject:@"2" forKey:@"run_type"];
    
    ///生成订单
    [QSRequestManager requestDataWithType:rRequestTypeAddOrder andParams:tempParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///订单生成成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///设置参数
            QSAddOrderReturnData *tempReturnModel = resultData;
            self.orderFormModel = tempReturnModel.orderInfoList[0];
            
            ///订单标题
            self.orderFormModel.orderTitle = [NSString stringWithFormat:@"购买储蓄卡(%@)",tempModel.goodsName];
            
            ///订单描述
            self.orderFormModel.des = [NSString stringWithFormat:@"在线购买储蓄卡(￥%@)，%@",tempModel.goodsPrice,tempModel.goodsName];
            
            ///支付金额
            self.orderFormModel.payPrice = tempModel.goodsPrice;
            
            ///回调
            __block NSString *orderID = self.orderFormModel.order_id;
            __weak QSWPayOrderViewController *weakSelf = self;
            self.orderFormModel.alixpayCallBack = ^(NSString *payCode,NSString *payInfo){
                
                ///处理支付宝的回调结果
                [weakSelf checkPayResultWithCode:payCode andPayResultInfo:payInfo andOrderID:orderID];
                
            };
            
            ///进入支付宝
            [[QSAlixPayManager shareAlixPayManager] startAlixPay:self.orderFormModel];
            
        } else {
            
            ///隐藏HUD
            [self.hud hide:YES];
            
            ///重置订单模型
            self.orderFormModel = nil;
            
            ///订单生成失败
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"订单提交失败，请稍后再试……" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            
            ///显示1秒后移聊
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
                
            });
            
        }
        
    }];
    
}

#pragma mark - 支付宝支付时的回调处理
/**
 *  @author         yangshengmeng, 15-02-26 14:02:38
 *
 *  @brief          支付宝支付时的回调处理
 *
 *  @param payCode  支付结果的编码
 *  @param payInfo  支付结果说明
 *
 *  @since          1.0.0
 */
- (void)checkPayResultWithCode:(NSString *)payCode andPayResultInfo:(NSString *)payInfo andOrderID:(NSString *)orderID
{
    
    ///将支付回调的代码，转换为整数代码
    int resultCode = [payCode intValue];
    
    /**
     *                  9000---订单支付成功
     *                  8000---正在处理中
     *                  4000---订单支付失败
     *                  6001---用户中途取消
     *                  6002---网络连接出错
     */
    
    ///支付成功回调：进入支付成功页面
    if (resultCode == 9000) {
        
        ///确认参数
        NSDictionary *tempParams = @{@"id" : orderID,
                                     @"type" : @"1",
                                     @"is_pay" : @"1",
                                     @"desc" : @"储值卡购买确认"};
        
        ///回调服务端确认支付
        [QSRequestManager requestDataWithType:rRequestTypeCommitOrderPayResult andParams:tempParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///更新用户信息
            [QSUserManager updateUserData:^(BOOL flag) {
                
                ///移聊HUD
                [self.hud hide:YES];
                
                ///返回储值卡页面:如果是第一次购买，则是创建页面
                if (self.isTurnBack) {
                    
                    if (self.buyStoreCardCallBack) {
                        
                        self.buyStoreCardCallBack(YES);
                        
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } else {
                    
                    QSWStoredCardViewController *storeCardVC = [[QSWStoredCardViewController alloc] init];
                    storeCardVC.pageGap = 4;
                    [self.navigationController pushViewController:storeCardVC animated:YES];
                    
                }
                
            }];
            
        }];
        
        return;
        
    }
    
    ///支付回调：正在处理中
    if (resultCode == 8000) {
        
        ///确认参数
        NSDictionary *tempParams = @{@"id" : orderID,
                                     @"type" : @"1",
                                     @"is_pay" : @"0",
                                     @"desc" : @"储值卡购买确认"};
        
        ///回调服务端确认支付
        [QSRequestManager requestDataWithType:rRequestTypeCommitOrderPayResult andParams:tempParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///更新用户信息
            [QSUserManager updateUserData:^(BOOL flag) {
                
                ///移聊HUD
                [self.hud hide:YES];
                
                ///更新用户购买储值卡的状态
                QSUserInfoDataModel *userDataModel = [QSUserInfoDataModel userDataModel];
                userDataModel.is_buy_card = @"1";
                [userDataModel saveUserData];
                
                ///返回储值卡页面:如果是第一次购买，则是创建页面
                if (self.isTurnBack) {
                    
                    if (self.buyStoreCardCallBack) {
                        
                        self.buyStoreCardCallBack(YES);
                        
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } else {
                    
                    QSWStoredCardViewController *storeCardVC = [[QSWStoredCardViewController alloc] init];
                    storeCardVC.pageGap = 4;
                    [self.navigationController pushViewController:storeCardVC animated:YES];
                    
                }
                
            }];
            
        }];
        
        return;
        
    }
    
    ///移聊HUD
    [self.hud hide:YES];
    
    ///支付失败
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"支付失败，请稍后再试……"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    
    ///显示1秒后移聊
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        
    });
    
}

#pragma mark - 选择一项储值卡时，改变字体颜色
///选择某一个储值卡时，字体颜色为白色
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///保存当前选择的储值卡
    QSGoodsDataModel *tempModel = self.storedCardDataSource[indexPath.row];
    
    ///判断当前选择的是否和原来的相同
    if (self.selectedIndex == indexPath.row) {
        
        self.selectedID = tempModel.goodsID;
        self.selectedIndex = (int)indexPath.row;
        
    } else {
        
        self.selectedID = tempModel.goodsID;
        self.selectedIndex = (int)indexPath.row;
        self.orderFormModel = nil;
        
    }
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
    
}

#pragma mark - 返回事件
///返回
- (void)turnBackAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 获取储值卡信息
///获取当前可以购买的储值卡数据
-(void)getStoredCardList
{
    
    //每日特价信息请求参数
    NSDictionary *dict = @{@"type" : @"11",
                           @"key" : @"",
                           @"goods_tag":@"",
                           @"source":@"phone"};
    
    [QSRequestManager requestDataWithType:rRequestTypeAspecial andParams:dict andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            //模型转换
            QSGoodsListReturnData *tempModel = resultData;
            NSArray *array = tempModel.goodsListData.goodsList;
            NSLog(@"QSAspecialReturnData : %@",tempModel);
            
            //设置页码：当前页码/最大页码
            
            self.storedCardDataSource=[[NSMutableArray alloc]init];
            //清空的数据源
            [self.storedCardDataSource removeAllObjects];
            
            ///保存数据源
            [self.storedCardDataSource addObjectsFromArray:array];
            
            ///结束刷新动画
            [self.collectionView headerEndRefreshing];
            
            ///reload数据
            [self.collectionView reloadData];
            
        } else {
            
            NSLog(@"================今日特价搜索信息请求失败================");
            NSLog(@"error : %@",errorInfo);
            NSLog(@"================今日特价搜索信息请求失败================");
            
        }
        
    }];
    
}

@end
