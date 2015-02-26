//
//  QSWPayOrderViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWPayOrderViewController.h"
#import "DeviceSizeHeader.h"
#import "QSRequestManager.h"
#import "QSRequestTaskDataModel.h"
#import "QSGoodsDataModel.h"
#import "QSGoodsListReturnData.h"
#import "MJRefresh.h"
#import "ColorHeader.h"

@interface QSWPayOrderViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *nodataView;                       //!<没有储值卡view
@property (strong, nonatomic) UICollectionView *collectionView;         //!<每个充值按钮
@property (nonatomic,retain)  NSMutableArray *storedCardDataSource;     //!<充值卡信息数据源
@property (nonatomic,copy) NSString *selectedID;                        //!<当前选择状态的储值卡ID

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
- (instancetype)initWithID:(NSString *)storeCarID
{

    if (self = [super init]) {
        
        ///保存当前选择的储值卡ID
        if (storeCarID) {
            
            self.selectedID = storeCarID;
            
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
    
    self.title=@"支付订单";
    self.view.backgroundColor=[UIColor whiteColor];
    
    ///加载储值卡数据
    [self getStoredCardList];
    
    UILabel *userBanlaceLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT,0.0f, 150.0f, 44.0f)];
    userBanlaceLabel.text=@"帐户余额";
    userBanlaceLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:userBanlaceLabel];
    
    UILabel *banlaceLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 60.0f - SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.0f, 60.0f, 44.0f)];
    banlaceLabel.text=@"￥0.0f";
    banlaceLabel.textAlignment = NSTextAlignmentRight;
    banlaceLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:banlaceLabel];
    
    ///分隔线
    UILabel *priceSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, userBanlaceLabel.frame.origin.y + userBanlaceLabel.frame.size.height - 0.25f, SIZE_DEFAULT_MAX_WIDTH, 0.25f)];
    priceSepLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [self.view addSubview:priceSepLabel];
    
    UILabel *storedCardPrice=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f, SIZE_DEVICE_WIDTH-2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f)];
    
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
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
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
    UIButton *putPayButton=[[UIButton alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 64.0f - 44.0f - 49.0f - 10.0f, SIZE_DEVICE_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f)];
    [putPayButton setTitle:@"提交支付" forState:UIControlStateNormal];
    [putPayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    putPayButton.backgroundColor=COLOR_CHARACTERS_RED;
    
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
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ///清空原信息
    for (id subView in cell.contentView.subviews) {
        
        [subView removeFromSuperview];
        
    }
    
    ///获取模型
    QSGoodsDataModel *tempModel = self.storedCardDataSource[indexPath.row];
    
    UILabel *priceLabel =[[UILabel alloc] initWithFrame:CGRectMake(0.0f, cell.frame.size.height * 0.25, cell.frame.size.width, cell.frame.size.height * 0.25)];
    priceLabel.textColor = [UIColor brownColor];
    priceLabel.textAlignment=NSTextAlignmentCenter;
    priceLabel.text=[NSString stringWithFormat:@"￥%@",tempModel.goodsPrice];
    priceLabel.font=[UIFont systemFontOfSize:20];
    priceLabel.tintColor = [UIColor whiteColor];
    priceLabel.tag = 98;
    
    UILabel *specialLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height*0.5+5.0f, cell.frame.size.width, cell.frame.size.height*0.2)];
    specialLabel.textColor = [UIColor brownColor];
    specialLabel.textAlignment=NSTextAlignmentCenter;
    specialLabel.text=[NSString stringWithFormat:@"送￥%@",tempModel.presentPrice];
    specialLabel.font=[UIFont systemFontOfSize:16];
    specialLabel.tintColor = [UIColor whiteColor];
    specialLabel.tag = 99;
    
    ///加边框
    UIView *lineRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cell.frame.size.width, cell.frame.size.height)];
    lineRootView.backgroundColor = [UIColor clearColor];
    lineRootView.layer.borderColor = [[UIColor colorWithRed:194.0f / 255.0f green:181.0f / 255.0f blue:156.0f / 255.0f alpha:1.0f] CGColor];
    lineRootView.layer.borderWidth = 0.5f;
    lineRootView.layer.cornerRadius = 6.0f;
    
    ///加载到content上
    [cell.contentView addSubview:lineRootView];
    [cell.contentView sendSubviewToBack:lineRootView];
    
    cell.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:priceLabel];
    [cell.contentView addSubview:specialLabel];
    
    ///选择状态时的背景
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cell.frame.size.width, cell.frame.size.height)];
    bgView.backgroundColor = COLOR_CHARACTERS_RED;
    bgView.layer.cornerRadius = 6.0f;
    cell.selectedBackgroundView = bgView;
    
    ///判断是否第一行
    if (0 == indexPath.row && !(self.selectedID)) {
        
        [collectionView selectItemAtIndexPath:[NSIndexPath indexPathWithIndex:indexPath.row] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        
    } else if (self.selectedID && ([self.selectedID intValue] == [tempModel.goodsID intValue])) {
    
        [collectionView selectItemAtIndexPath:[NSIndexPath indexPathWithIndex:indexPath.row] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    }
    
    return cell;
    
}

#pragma mark - 提交支付按钮方法
///提交支付
-(void)putPayButtonAction
{



}

#pragma mark - 选择一项储值卡时，改变字体颜色
///选择某一个储值卡时，字体颜色为白色
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    

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
