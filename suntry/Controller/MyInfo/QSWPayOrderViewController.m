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

@property (nonatomic, strong) UIView *nodataView;                    //!<没有储值卡view
@property (strong, nonatomic) UILabel *priceLabel;                   //!<价钱label
@property (strong, nonatomic) UILabel *specialLabel;                 //!<优惠label
@property (strong, nonatomic) UICollectionView *collectionView;      //!<每个充值按钮
@property (nonatomic,retain)  NSMutableArray *storedCardDataSource;  //!<充值卡信息数据源

@end

@implementation QSWPayOrderViewController

- (void)viewDidLoad {
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
    [self.view addSubview:userBanlaceLabel];
    
    UILabel *BanlaceLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-60.0f-SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.0f, 60.0f, 44.0f)];
    userBanlaceLabel.text=@"￥0";
    [self.view addSubview:BanlaceLabel];
    
    UILabel *storedCardPrice=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f, SIZE_DEVICE_WIDTH-2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f)];
    
    storedCardPrice.text=@"储值卡金额";
    [self.view addSubview:storedCardPrice];
    
    
    
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    ///设置每个cell大小与位置
    CGFloat viewW = (SIZE_DEVICE_WIDTH - 6.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) * 1/3;
    CGFloat viewH = viewW;
    CGSize itemSize = CGSizeMake(viewW, viewH);
    flowLayout.itemSize = itemSize;
    flowLayout.sectionInset = UIEdgeInsetsMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MARGIN_LEFT_RIGHT);
    
    ///初始化collectionView
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, storedCardPrice.frame.origin.y+storedCardPrice.frame.size.height+10.0f, SIZE_DEVICE_WIDTH-2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT-storedCardPrice.frame.origin.y-storedCardPrice.frame.size.height-10.0f-49.0f-64.0f) collectionViewLayout:flowLayout];
    ///取消导航条
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.backgroundColor=[UIColor clearColor];
    
    ///注册Cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [self.view addSubview:self.collectionView];
    
    
    UIButton *putPayButton=[[UIButton alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT-64.0f-44.0f-49.0f, SIZE_DEVICE_WIDTH-2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f)];
    [putPayButton setTitle:@"提交支付" forState:UIControlStateNormal];
    [putPayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    putPayButton.backgroundColor=COLOR_CHARACTERS_RED;
    
    [putPayButton addTarget:self action:@selector(putPayButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:putPayButton];

}

#pragma mark -- UICollectionViewDataSource数据源方法

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

///每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ///获取模型
    QSGoodsDataModel *tempModel = self.storedCardDataSource[indexPath.row];
    
    _priceLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height*0.25, cell.frame.size.width, cell.frame.size.height*0.25)];
    _priceLabel.textColor = [UIColor brownColor];
    _priceLabel.textAlignment=NSTextAlignmentCenter;
    _priceLabel.text=[NSString stringWithFormat:@"￥%@",tempModel.goodsPrice];
    _priceLabel.font=[UIFont systemFontOfSize:20];
    
    _specialLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height*0.5+5.0f, cell.frame.size.width, cell.frame.size.height*0.2)];
    _specialLabel.textColor = [UIColor brownColor];
    _specialLabel.textAlignment=NSTextAlignmentCenter;
    _specialLabel.text=[NSString stringWithFormat:@"送￥%@",tempModel.presentPrice];
    _specialLabel.font=[UIFont systemFontOfSize:16];
    
    for (id subView in cell.contentView.subviews) {
        
        [subView removeFromSuperview];
        
    }
    
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
    [cell.contentView addSubview:_priceLabel];
    [cell.contentView addSubview:_specialLabel];
    return cell;
    
}

#pragma mark --UICollectionViewDelegate代理方法

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //QSGoodsDataModel *goodsItem = _specialDataSource[indexPath.row];
    
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
    
}

#pragma mark --提交支付按钮方法
-(void)putPayButtonAction
{



}

#pragma mark - 返回事件
- (void)turnBackAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark --获取网络数据
-(void)getStoredCardList
{
    
    //每日特价信息请求参数
    NSDictionary *dict = @{@"type" : @"11", @"key" : @"",@"goods_tag":@"",@"source":@"phone"};
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
