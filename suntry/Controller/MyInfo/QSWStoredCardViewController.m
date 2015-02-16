//
//  QSWStoredCardViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWStoredCardViewController.h"
#import "DeviceSizeHeader.h"
#import "QSWStoredCardCell.h"
#import "QSStoredCardDataModel.h"
#import "QSUserStoredCardReturnData.h"
#import "QSRequestManager.h"
#import "QSRequestTaskDataModel.h"
#import "MJRefresh.h"
#import "ColorHeader.h"
#import "QSWResetPswController.h"
#import "QSWPayOrderViewController.h"

@interface QSWStoredCardViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *topView;               //!<顶部view
@property (weak, nonatomic) IBOutlet UIView *middleView;            //!<中间view,放充值记录，消费记录按钮
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;         //!<余额文字label
@property (weak, nonatomic) IBOutlet UILabel *balanceCountLabel;    //!<余额数label
@property (weak, nonatomic) IBOutlet UILabel *payPswLabel;          //!<支付密码label
@property (weak, nonatomic) IBOutlet UIButton *chargeButton;        //!<充值按钮
@property (weak, nonatomic) IBOutlet UIButton *resetPswButton;      //!<重置密码按钮
@property (weak, nonatomic) IBOutlet UIButton *chargeRecord;        //!<充值记录按钮
@property (weak, nonatomic) IBOutlet UIButton *consumeRecord;       //!<消费记录按钮
@property (nonatomic, strong) UICollectionView *collectionView;     //!<充值，消费记录view
@property (nonatomic, retain) NSMutableArray *storedCardDataSource; //!<充值卡信息数据源

@end

@implementation QSWStoredCardViewController

- (void)viewDidLoad {
    
    ///自定义返回按钮
    UIBarButtonItem *turnBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(turnBackAction)];
    turnBackButton.tintColor = [UIColor whiteColor];
    
    ///设置返回按钮的颜色
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = turnBackButton;
    
    [super viewDidLoad];
    [self setupTopView];
    [self setupMiddleView];
    [self setupBottomView];
    
}

#pragma mark--控件加载
///加载顶部view
-(void)setupTopView
{

    CGFloat topViewH=SIZE_DEVICE_HEIGHT*240/667;
    _topView.frame=CGRectMake(0, 0, SIZE_DEVICE_WIDTH, topViewH);
    
    _balanceLabel.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0, 150.0f, _topView.frame.size.height*1/4);
    _balanceCountLabel.frame=CGRectMake(SIZE_DEVICE_WIDTH-60.0f-SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0, 60.0f, topViewH*1/4);
    
    _payPswLabel.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, _balanceLabel.frame.origin.y+_balanceLabel.frame.size.height, SIZE_DEVICE_WIDTH-2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, topViewH*1/4);
    
    ///加边框
    UIView *lineTopView = [[UIView alloc] initWithFrame:CGRectMake(_payPswLabel.frame.origin.x, _payPswLabel.frame.origin.y, _payPswLabel.frame.size.width, 0.5f)];
    lineTopView.backgroundColor=[UIColor lightGrayColor];
    
    ///加边框
    UIView *lineBottomView = [[UIView alloc] initWithFrame:CGRectMake(_payPswLabel.frame.origin.x, _payPswLabel.frame.origin.y+_payPswLabel.frame.size.height, _payPswLabel.frame.size.width, 0.5f)];
    [_topView addSubview:lineTopView];
    [_topView addSubview:lineBottomView];
    lineBottomView.backgroundColor=[UIColor lightGrayColor];
    
    _chargeButton.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, _payPswLabel.frame.origin.y+_payPswLabel.frame.size.height+topViewH*1/8,(SIZE_DEVICE_WIDTH-3*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)*0.5, topViewH*1/4);
    _chargeButton.backgroundColor=COLOR_CHARACTERS_RED;
    _chargeButton.layer.cornerRadius=6.0f;
    
    _resetPswButton.frame=CGRectMake(2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT+_chargeButton.frame.size.width, _payPswLabel.frame.origin.y+_payPswLabel.frame.size.height+topViewH*1/8,(SIZE_DEVICE_WIDTH-3*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)*0.5, topViewH*1/4);
    _resetPswButton.backgroundColor=COLOR_CHARACTERS_RED;
    _resetPswButton.layer.cornerRadius=6.0f;
    
    
}

///加载中间view
-(void)setupMiddleView
{
    
    _middleView.frame=CGRectMake(0, _topView.frame.origin.y+_topView.frame.size.height, SIZE_DEVICE_WIDTH, 45.0f);
        _middleView.backgroundColor=[UIColor whiteColor];
    
    _chargeRecord.frame=CGRectMake(0, 0, SIZE_DEVICE_WIDTH*0.5f, 45.0f);
    
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
    
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    ///设置每个cell大小与位置
    CGFloat viewW = SIZE_DEVICE_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    CGFloat viewH = 44.0f;
    CGSize itemSize = CGSizeMake(viewW, viewH);
    flowLayout.itemSize = itemSize;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0, SIZE_DEFAULT_MARGIN_LEFT_RIGHT);
    
    ///初始化collectionView
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, _middleView.frame.origin.y+_middleView.frame.size.height, SIZE_DEVICE_WIDTH-2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT-_middleView.frame.origin.y-_middleView.frame.size.height-49.0f-64.0f) collectionViewLayout:flowLayout];
    ///取消导航条
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.backgroundColor=[UIColor clearColor];
    
    ///注册Cell
    [self.collectionView registerClass:[QSWStoredCardCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
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
    
    QSWStoredCardCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell==nil) {
        
        cell=[[QSWStoredCardCell alloc]init];
        
    }
    
    ///获取模型
    QSStoredCardDataModel *tempModel = self.storedCardDataSource[indexPath.row];
    
    cell.cTimeLabel.text=tempModel.createTime;
    cell.cPrcieLabel.text=[NSString stringWithFormat:@"￥%@",tempModel.amount];
    //cell.cBalanceLabel.text=tempModel.amount;

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

#pragma mark - 返回事件
- (void)turnBackAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark --按钮事件
///点击充值储存卡
- (IBAction)chargeButton:(id)sender
{
    
    QSWPayOrderViewController *VC=[[QSWPayOrderViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

///点击重置密码
- (IBAction)resetPswButton:(id)sender
{
    
    QSWResetPswController *VC=[[QSWResetPswController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

///点击充值记录
- (IBAction)chargeRecord:(id)sender {
    
     [self getChargeRecordList];
    
}

///点击消费记录
- (IBAction)consumeRecord:(id)sender {
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
