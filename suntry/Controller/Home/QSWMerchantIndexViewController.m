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
#import "QSAspecialDataModel.h"
#import "QSAspecialReturnData.h"
#import "QSRequestManager.h"
#import "QSRequestTaskDataModel.h"
#import "UIImageView+CacheImage.h"
#import "FontHeader.h"

@interface QSWMerchantIndexViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *foodImageView;    //!<菜品图片
@property (weak, nonatomic) IBOutlet UIButton *sharkButton; //!<摇一摇按钮
@property (weak, nonatomic) IBOutlet UIButton *packageButton;   //!<美味套餐按钮
@property (weak, nonatomic) IBOutlet UIButton *carButton;   //!<车车在哪儿按钮
@property (weak, nonatomic) IBOutlet UIButton *customButton;    //!<客服按钮
@property (weak, nonatomic) IBOutlet UIButton *moreButton;  //!<更多按钮
@property (weak, nonatomic) IBOutlet UILabel *specialsLabel;    //!<第日优惠菜品优惠价label
@property (strong, nonatomic)UICollectionView *collectionView; //!<每日优惠菜品窗体

@property (strong,nonatomic)NSString *distictID;    //!<地区ID
@property (strong,nonatomic)NSString *distictName;  //!<地区名称

@property (nonatomic,retain) NSMutableArray *specialDataSource;//!<优惠信息数据源

@end

@implementation QSWMerchantIndexViewController

#pragma mark - 初始化

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

#pragma mark--控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=self.distictName;
    
    [self downloadAspecialInfo];
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    
    ///加载头部view
    [self setupTopView];
    
    ///加载食品列表
    [self setupFoodListView];
    
}

///加载顶部view
-(void)setupTopView
{
    
    _foodImageView.frame=CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SIZE_DEFAULT_HOME_BANNAR_HEIGHT);
    
    CGFloat buttonW=(SIZE_DEVICE_WIDTH-5*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)/4;
    CGFloat buttonH=buttonW*74/78;
    CGFloat buttonY=SIZE_DEFAULT_HOME_BANNAR_HEIGHT+SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    
    _sharkButton.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, buttonY, buttonW, buttonH);
    
    _packageButton.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT*2+buttonW, buttonY, buttonW, buttonH);
    
    _carButton.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT*3+2*buttonW, buttonY, buttonW, buttonH);
    
     _customButton.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT*4+3*buttonW, buttonY, buttonW, buttonH);
    
    _specialsLabel.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT,buttonY+buttonH+SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 180.0f, 20.0f);
    [_specialsLabel setFont:[UIFont systemFontOfSize:20.0f]];
    
    _moreButton.frame=CGRectMake(SIZE_DEVICE_WIDTH-SIZE_DEFAULT_MARGIN_LEFT_RIGHT-30.0f, buttonY+buttonH+SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 30.0f, 20.0f);
    
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
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, self.moreButton.frame.origin.y+20.0f+5.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-self.moreButton.frame.origin.y-20-49.0f-64.0f) collectionViewLayout:flowLayout];
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
    //注册Cell，必须要有
    [self.collectionView registerClass:[QSWMerchantIndexCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [self.view addSubview:self.collectionView];
    
}

#pragma mark -- UICollectionViewDataSource数据源方法

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.specialDataSource count];
    
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
    
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    
    QSWMerchantIndexCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell==nil) {
        
        cell=[[QSWMerchantIndexCell alloc]init];
    
    }
    
    ///获取模型
    QSAspecialDataModel *tempModel = self.specialDataSource[indexPath.row];
   
    cell.foodImageView.image=[UIImage imageNamed:@"home_bannar"];
    cell.foodNameLabel.text= tempModel.goodsName;
    cell.priceMarkImageView.image=[UIImage imageNamed:@"home_pricemark"];
    [cell.foodImageView loadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://admin.9dxz.com/files/%@",tempModel.goodsImage]] placeholderImage:[UIImage imageNamed:@"home_bannar"]];
    cell.priceLabel.text= tempModel.specialPrice;
    return cell;
    
}

#pragma mark --UICollectionViewDelegate代理方法

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
    
}

#pragma mark --按钮点击事件
- (IBAction)sharkButtonClick:(id)sender
{
    
    QSPShakeFoodView *shakeFoodView = [QSPShakeFoodView getShakeFoodView];
    [self.tabBarController.view addSubview:shakeFoodView];
    [shakeFoodView updateFoodData:nil];
    [shakeFoodView showShakeFoodView];
    
}

- (IBAction)packageButtonClick:(id)sender
{
   
    [self.tabBarController setSelectedIndex:1];
    
}

- (IBAction)carButtonClick:(id)sender {
    
    QSMapNavigationViewController *VC=[[QSMapNavigationViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (IBAction)customButtonClick:(id)sender {
    
    
    
}
- (IBAction)moreButtonClick:(id)sender {
    
     [self.tabBarController setSelectedIndex:1];
    
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    NSLog(@"触发摇一摇");
    QSPShakeFoodView *shakeFoodView = [QSPShakeFoodView getShakeFoodView];
    [self.tabBarController.view addSubview:shakeFoodView];
    [shakeFoodView updateFoodData:nil];
    [shakeFoodView showShakeFoodView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark--每日特价网络信息请求
///街道查询信息请求
- (void)downloadAspecialInfo
{
    //街道搜索信息请求参数
    NSDictionary *dict = @{@"type" : @"1", @"key" : @"",@"goods_tag":@"4"};
    
    [QSRequestManager requestDataWithType:rRequestTypeAspecial andParams:dict andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///模型转换
            QSAspecialReturnData *tempModel = resultData;
            
            ///设置页码：当前页码/最大页码
            
            ///清空的数据源
            [self.specialDataSource removeAllObjects];
            
            ///保存数据源
            [self.specialDataSource addObjectsFromArray:tempModel.aspecialHeaderData.specialList];
            
            ///结束刷新动画
            
            
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
