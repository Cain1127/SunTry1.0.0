//
//  QSWMyStoredCardViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWMyStoredCardViewController.h"
#import "QSBlockButton.h"
#import "ImageHeader.h"
#import "QSLabel.h"
#import "DeviceSizeHeader.h"
#import "QSRequestManager.h"
#import "QSRequestTaskDataModel.h"
#import "QSGoodsDataModel.h"
#import "QSGoodsListReturnData.h"
#import "MJRefresh.h"
#import "QSWPayOrderViewController.h"

#define ORDER_LIST_VIEWCONTROLLER_NAV_TITLE_FONT_SIZE   17.
#define ORDER_LIST_VIEWCONTROLLER_CONTENT_COLOR         [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]
#define ORDER_LIST_VIEWCONTROLLER_CONTENT_FONT_SIZE     17.

@interface QSWMyStoredCardViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *nodataView;                    //!<没有储值卡view
@property (strong, nonatomic) UILabel *priceLabel;                   //!<价钱label
@property (strong, nonatomic) UILabel *specialLabel;                 //!<优惠label
@property (strong, nonatomic) UICollectionView *collectionView;      //!<每个充值按钮
@property (nonatomic,retain)  NSMutableArray *storedCardDataSource;  //!<充值卡信息数据源

@end

@implementation QSWMyStoredCardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    ///自定义返回按钮
    UIBarButtonItem *turnBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(turnBackAction)];
    turnBackButton.tintColor = [UIColor whiteColor];
    
    ///设置返回按钮的颜色
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = turnBackButton;

    self.title=@"我的储值卡";
    self.view.backgroundColor=[UIColor whiteColor];
    
    ///加载储值卡数据
    [self getStoredCardList];
    
    ///没有数据时的显示
    self.nodataView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_nodataView];
    
    UIImageView *nodataImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myinfo_rmbmark"]];
    [nodataImgView setCenter:self.view.center];
    [nodataImgView setFrame:CGRectMake(nodataImgView.frame.origin.x, 110/667.*SIZE_DEVICE_HEIGHT, nodataImgView.frame.size.width, nodataImgView.frame.size.height)];
    [_nodataView addSubview:nodataImgView];
    
    QSLabel *infoLabel = [[QSLabel alloc] initWithFrame:CGRectMake(20, nodataImgView.frame.origin.y+nodataImgView.frame.size.height+5, SIZE_DEVICE_WIDTH-40, 50)];
    [infoLabel setFont:[UIFont boldSystemFontOfSize:ORDER_LIST_VIEWCONTROLLER_CONTENT_FONT_SIZE]];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [infoLabel setNumberOfLines:2];
    [infoLabel setTextAlignment:NSTextAlignmentCenter];
    [infoLabel setText:@"您的帐号还没有储值卡，请选择需要购买的储值卡"];
    [infoLabel setTextColor:ORDER_LIST_VIEWCONTROLLER_CONTENT_COLOR];
    [_nodataView addSubview:infoLabel];
    
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
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, infoLabel.frame.origin.y+infoLabel.frame.size.height+10.0f, SIZE_DEVICE_WIDTH-2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT-infoLabel.frame.origin.y-infoLabel.frame.size.height-10.0f-49.0f-64.0f) collectionViewLayout:flowLayout];
    ///取消导航条
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.backgroundColor=[UIColor clearColor];
    
    ///注册Cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [self.view addSubview:self.collectionView];

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

#pragma mark - 选择某个储值卡
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    QSGoodsDataModel *tempModel = self.storedCardDataSource[indexPath.row];
    QSWPayOrderViewController *VC=[[QSWPayOrderViewController alloc] initWithID:tempModel.goodsID];
    [self.navigationController pushViewController:VC animated:YES];
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
    
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
            
            NSLog(@"================储值卡信息请求失败================");
            NSLog(@"error : %@",errorInfo);
            NSLog(@"================储值卡信息请求失败================");
            
        }
        
    }];

}

@end
