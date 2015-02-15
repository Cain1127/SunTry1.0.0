//
//  QSWMerchantIndexViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWMerchantIndexViewController.h"
#import "DeviceSizeHeader.h"
#import "FontHeader.h"
#import "QSMapNavigationViewController.h"
#import "QSLabel.h"
#import "QSPShakeFoodView.h"
#import "QSWMerchantIndexCell.h"
#import "QSGoodsDataModel.h"
#import "QSGoodsListReturnData.h"
#import "QSRequestManager.h"
#import "QSRequestTaskDataModel.h"
#import "UIImageView+CacheImage.h"
#import "FontHeader.h"
#import "MJRefresh.h"

@interface QSWMerchantIndexViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *foodImageView;  //!<菜品图片
@property (weak, nonatomic) IBOutlet UIButton *sharkButton;       //!<摇一摇按钮
@property (weak, nonatomic) IBOutlet UIButton *packageButton;     //!<美味套餐按钮
@property (weak, nonatomic) IBOutlet UIButton *carButton;         //!<车车在哪儿按钮
@property (weak, nonatomic) IBOutlet UIButton *customButton;      //!<客服按钮
@property (weak, nonatomic) IBOutlet UIButton *moreButton;        //!<更多按钮
@property (weak, nonatomic) IBOutlet UILabel *specialsLabel;      //!<第日优惠菜品优惠价label
@property (strong, nonatomic)UICollectionView *collectionView;    //!<每日优惠菜品窗体

@property (strong,nonatomic)NSString *distictID;                  //!<地区ID
@property (strong,nonatomic)NSString *distictName;                //!<地区名称

@property (nonatomic,retain) NSMutableArray *specialDataSource;   //!<优惠信息数据源

@end

@implementation QSWMerchantIndexViewController

#pragma mark - 初始化
///初始化
- (instancetype)initWithID:(NSString *)distictID andDistictName:(NSString *)districtName
{

    if (self = [super init]) {
        
        self.distictID=distictID;
        self.distictName=districtName;
        
        ///初始化数据源数组
        self.specialDataSource = [[NSMutableArray alloc] init];
        
    }
    
    return self;

}

#pragma mark - 初始UI搭建
///UI搭建
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    ///下载数据
    [self downloadAspecialInfo];
    
    ///添加摇一摇功能
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    
    ///导航栏
    UIImageView *navRootView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 64.0f)];
    navRootView.userInteractionEnabled = YES;
    navRootView.image = [UIImage imageNamed:@"nav_backgroud"];
    [self.view addSubview:navRootView];
    
    ///0.添加导航栏主题view
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 60.0f, 30.0f)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentRight];
    [navTitle setText:self.distictName];
    navTitle.tag = 51;
    
    UIImageView *localImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_local"] ];
    localImageView.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
    localImageView.tag = 52;
    
    UIImageView *titleImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_arrow_down"] ];
    titleImageView.frame = CGRectMake(90.0f, 0.0f, 30.0f, 30.0f);
    titleImageView.tag = 50;
    
    UIButton *districtButton = [[UIButton alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 120.0f) / 2.0f, navRootView.frame.size.height - 37.0f, 120.0f, 30.0f)];
    [districtButton addSubview:navTitle];
    [districtButton addSubview:titleImageView];
    [districtButton addSubview:localImageView];
    
    [navRootView addSubview:districtButton];
    [districtButton addTarget:self action:@selector(showStreetPicker) forControlEvents:UIControlEventTouchUpInside];
    
    ///加载头部view
    [self setupTopView];
    
    ///加载食品列表
    [self setupFoodListView];
    
}

///加载顶部view
-(void)setupTopView
{
    
    _foodImageView.frame=CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEFAULT_HOME_BANNAR_HEIGHT);
    
    CGFloat buttonW = (SIZE_DEVICE_WIDTH - 5.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 4.0f;
    CGFloat buttonH = buttonW * 74.0f / 78.0f;
    CGFloat buttonY = 64.0f + SIZE_DEFAULT_HOME_BANNAR_HEIGHT + SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    
    _sharkButton.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, buttonY, buttonW, buttonH);
    _packageButton.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 2.0f + buttonW, buttonY, buttonW, buttonH);
    _carButton.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 3.0f + 2.0f * buttonW, buttonY, buttonW, buttonH);
     _customButton.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 4.0f + 3.0f * buttonW, buttonY, buttonW, buttonH);
    _specialsLabel.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT,buttonY+buttonH+SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 180.0f, 20.0f);
    [_specialsLabel setFont:[UIFont systemFontOfSize:20.0f]];
    
    _moreButton.frame=CGRectMake(SIZE_DEVICE_WIDTH-SIZE_DEFAULT_MARGIN_LEFT_RIGHT - 30.0f, buttonY+buttonH+SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 30.0f, 20.0f);
    
}

///加载食品列表
-(void)setupFoodListView
{

    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    ///设置
    CGFloat viewW = (SIZE_DEVICE_WIDTH - 3.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) * 0.5;
    CGFloat viewH = viewW * 289.0f / 335.0f;
    CGSize itemSize = CGSizeMake(viewW, viewH);
    flowLayout.itemSize = itemSize;
    flowLayout.sectionInset = UIEdgeInsetsMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MARGIN_LEFT_RIGHT);
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, self.moreButton.frame.origin.y + 20.0f + 5.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - self.moreButton.frame.origin.y - 20.0f - 49.0f) collectionViewLayout:flowLayout];
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
    //注册Cell，必须要有
    [self.collectionView registerClass:[QSWMerchantIndexCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - 街道选择
///弹出街道选择窗口
- (void)showStreetPicker
{

    

}

#pragma mark - 当前特价总数
///定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.specialDataSource count];
    
}

///定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
    
}

#pragma mark - 返回每一个特价信息cell
///每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    
    QSWMerchantIndexCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell==nil) {
        
        cell=[[QSWMerchantIndexCell alloc]init];
    
    }
    
    ///获取模型
    QSGoodsDataModel *tempModel = self.specialDataSource[indexPath.row];
   
    cell.foodImageView.image=[UIImage imageNamed:@"home_bannar"];
    cell.foodNameLabel.text= tempModel.goodsName;
    cell.priceMarkImageView.image=[UIImage imageNamed:@"home_pricemark"];
    [cell.foodImageView loadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://admin.9dxz.com/files/%@",tempModel.goodsImageUrl]] placeholderImage:[UIImage imageNamed:@"home_bannar"]];
    cell.priceLabel.text= tempModel.goodsSpecialPrice;
    return cell;
    
}

#pragma mark - 点击某一个特价，进入点餐页面
///点击某一个特价，进入点餐页面
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    QSGoodsDataModel *goodsItem = _specialDataSource[indexPath.row];
    QSPShakeFoodView *shakeFoodView = [QSPShakeFoodView getShakeFoodView];
    [self.tabBarController.view addSubview:shakeFoodView];
    [shakeFoodView updateFoodData:goodsItem];
    [shakeFoodView showShakeFoodView];
    
}

///返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
    
}

#pragma mark - 摇一摇
///点击摇一摇功能按钮
- (IBAction)sharkButtonClick:(id)sender
{
    
    [self getRandomGoods];
    
}

#pragma mark - 优惠套餐按钮事件
///优惠套餐按钮事件
- (IBAction)packageButtonClick:(id)sender
{
   
    [self.tabBarController setSelectedIndex:1];
    
}

#pragma mark - 车在哪按钮
///车在哪按钮
- (IBAction)carButtonClick:(id)sender
{
    
    QSMapNavigationViewController *VC=[[QSMapNavigationViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark - 客服热线
///客服热线
- (IBAction)customButtonClick:(id)sender
{
    
    
    
}

#pragma mark - 更多点餐信息
///更多点餐信息
- (IBAction)moreButtonClick:(id)sender
{
    
     [self.tabBarController setSelectedIndex:1];
    
}

#pragma mark - 摇一摇事件
///摇一摇事件接收入口
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    //FIXME: 需要完善逻辑，预防网络慢时同时触发调用的问题。
    [self getRandomGoods];
    
}

#pragma mark - 每日特价网络信息请求
///每日特价查询信息请求
- (void)downloadAspecialInfo
{
    //每日特价信息请求参数
    NSDictionary *dict = @{@"type" : @"1", @"key" : @"",@"goods_tag":@"4"};
    
    [QSRequestManager requestDataWithType:rRequestTypeAspecial andParams:dict andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            //模型转换
            QSGoodsListReturnData *tempModel = resultData;
            NSArray *array = tempModel.goodsListData.goodsList;
            
            NSLog(@"QSAspecialReturnData : %@",tempModel);
            //设置页码：当前页码/最大页码
            
            //清空的数据源
            [self.specialDataSource removeAllObjects];
            
            ///保存数据源
            [self.specialDataSource addObjectsFromArray:array];
            
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

#pragma mark - 随机菜品网络信息请求
///随机菜品网络信息请求
- (void)getRandomGoods
{
    //随机菜品信息请求参数
    NSDictionary *dict = @{@"num" : @"1"};
    
    [QSRequestManager requestDataWithType:rRequestTypeRandom andParams:dict andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///模型转换
            QSGoodsListReturnData *tempModel = resultData;
            NSArray *array = tempModel.goodsListData.goodsList;
            NSLog(@"获取随机菜品成功");
            
            if ([array isKindOfClass:[NSArray class]]&&[array count]>0) {
                
                QSGoodsDataModel *goodsItem = array[0];
                QSPShakeFoodView *shakeFoodView = [QSPShakeFoodView getShakeFoodView];
                [self.tabBarController.view addSubview:shakeFoodView];
                [shakeFoodView updateFoodData:goodsItem];
                [shakeFoodView showShakeFoodView];
                
            }
            
            
        } else {
            
            NSLog(@"================随机菜品信息请求失败================");
            NSLog(@"error : %@",errorInfo);
        }
        
    }];
    
}

@end
