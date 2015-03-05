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
#import "CommonHeader.h"
#import "ImageHeader.h"

#import "QSDatePickerViewController.h"
#import "ASDepthModalViewController.h"
#import "QSSelectReturnData.h"
#import "QSSelectDataModel.h"
#import "QSBannerReturnData.h"
#import "QSBannerDataModel.h"
#import "QSAutoScrollView.h"

#import "QSHomeViewController.h"
#import "QSAdvertDetailViewController.h"
#import "QSWLoginViewController.h"

#import <objc/runtime.h>

#import "QSBlockButton.h"

#import "QSNoNetworkingViewController.h"

#import "MBProgressHUD.h"

#define kCallAlertViewTag 111

///关联
static char titleLabelKey;//!<标题key

@interface QSWMerchantIndexViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate,QSPShakeFoodViewDelegate,QSAutoScrollViewDelegate>

@property (nonatomic,strong) QSAutoScrollView *advertView;          //!<广告页
@property (weak, nonatomic) IBOutlet UIButton *sharkButton;         //!<摇一摇按钮
@property (weak, nonatomic) IBOutlet UIButton *packageButton;       //!<美味套餐按钮
@property (weak, nonatomic) IBOutlet UIButton *carButton;           //!<车车在哪儿按钮
@property (weak, nonatomic) IBOutlet UIButton *customButton;        //!<客服按钮
@property (weak, nonatomic) IBOutlet UIButton *moreButton;          //!<更多按钮
@property (weak, nonatomic) IBOutlet UILabel *specialsLabel;        //!<第日优惠菜品优惠价label
@property (strong, nonatomic)UICollectionView *collectionView;      //!<每日优惠菜品窗体

@property (strong,nonatomic)NSString *distictID;                    //!<地区ID
@property (strong,nonatomic)NSString *distictName;                  //!<地区名称

@property (nonatomic,retain) NSMutableArray *specialDataSource;     //!<优惠信息数据源
@property (nonatomic,retain) NSMutableArray *streetList;            //!<街道数据源
@property (nonatomic,strong) QSDatePickerViewController *customPicker;    //!<选择器

@property (nonatomic,strong) NSMutableArray *BannerList;            //!<广告数据
@property (nonatomic,strong) NSString *bannerImage;                 //!<广告图片

@property (nonatomic, copy) NSString *phoneNumber;                  //!<电话号码

@property (nonatomic, strong) UIButton  *shakeView;     //摇一摇界面
@property (nonatomic, assign) NSInteger  randRequestID;
@property (nonatomic, assign) NSInteger  randResultID;

@end

@implementation QSWMerchantIndexViewController

#pragma mark - 初始化
///初始化
- (instancetype)initWithID:(NSString *)distictID andDistictName:(NSString *)districtName
{
    
    if (self = [super init]) {
        
        _randRequestID = 0;
        _randResultID = _randRequestID;
        
        self.distictID = distictID ? distictID : ([[NSUserDefaults standardUserDefaults] objectForKey:@"streetID"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"streetID"] : @"299");
        self.distictName = districtName ? districtName : ([[NSUserDefaults standardUserDefaults] objectForKey:@"street"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"street"] : @"体育西路");
        
        ///初始化数据源数组
        self.specialDataSource = [[NSMutableArray alloc] init];
        self.BannerList = [[NSMutableArray alloc] init];
        
        ///初始化街道数据
        [self getDistrictStreetList];
        
    }
    
    return self;
    
}

#pragma mark - 获取本地位置的区信息
///获取本地位置的区信息
-(void)getDistrictStreetList
{
    
    ///数据地址
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/selectData"];
    
    ///首先转成data
    NSData *saveData = [NSData dataWithContentsOfFile:path];
    
    ///encode数据
    QSSelectReturnData *selectData = [NSKeyedUnarchiver unarchiveObjectWithData:saveData];
    _streetList = [[NSMutableArray alloc] initWithArray:selectData.selectList];
    
}

#pragma mark - 初始UI搭建
///UI搭建
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    ///添加摇一摇功能
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    
    ///加载食品列表
    [self setupFoodListView];
    
    ///导航栏
    UIImageView *navRootView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 64.0f)];
    navRootView.userInteractionEnabled = YES;
    navRootView.image = [UIImage imageNamed:@"nav_backgroud"];
    [self.view addSubview:navRootView];
    
    ///0.添加导航栏主题view
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 80.0f, 30.0f)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    navTitle.adjustsFontSizeToFitWidth = YES;
    [navTitle setText:self.distictName];
    objc_setAssociatedObject(self, &titleLabelKey, navTitle, OBJC_ASSOCIATION_ASSIGN);
    
    UIImageView *localImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_local"] ];
    localImageView.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
    
    UIImageView *titleImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_arrow_down"] ];
    titleImageView.frame = CGRectMake(110.0f, 0.0f, 30.0f, 30.0f);
    
    UIButton *districtButton = [[UIButton alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 140.0f) / 2.0f, navRootView.frame.size.height - 37.0f, 140.0f, 30.0f)];
    [districtButton addSubview:navTitle];
    [districtButton addSubview:titleImageView];
    [districtButton addSubview:localImageView];
    
    [navRootView addSubview:districtButton];
    [districtButton addTarget:self action:@selector(showStreetPicker) forControlEvents:UIControlEventTouchUpInside];
    
    [self initShakeView];
    
}

/**
 *  初始化摇一摇页面
 */
- (void)initShakeView
{
    //半透明背景层
    QSBlockButtonStyleModel *shakeBtStyle = [[QSBlockButtonStyleModel alloc] init];
    shakeBtStyle.bgColor = SHAKEVIEW_BACKGROUND_COLOR;
    self.shakeView = [UIButton createBlockButtonWithFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT) andButtonStyle:shakeBtStyle andCallBack:^(UIButton *button) {
        
        [button setHidden:YES];
        
    }];
    [self.shakeView setTag:111];
    [self.shakeView setHidden:YES];
    [self.tabBarController.view addSubview:self.shakeView];
    
    UIImageView *iconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_shake_icon"]];
    [iconImgView setCenter:CGPointMake(SIZE_DEVICE_WIDTH/2, iconImgView.frame.size.height/2)];
    UILabel *titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, iconImgView.frame.origin.y+iconImgView.frame.size.height, SIZE_DEVICE_WIDTH, 30)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@"摇一摇查看推荐菜品"];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, iconImgView.frame.size.height+titleLabel.frame.size.height)];
    [contentView addSubview:iconImgView];
    [contentView addSubview:titleLabel];
    [contentView setCenter:self.shakeView.center];
    [self.shakeView addSubview:contentView];
}

///加载食品列表
-(void)setupFoodListView
{
    
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 64.0f-SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 49.0f+SIZE_DEFAULT_MARGIN_LEFT_RIGHT) collectionViewLayout:flowLayout];
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
    ///添加头部刷新
    [self.collectionView addHeaderWithTarget:self action:@selector(downloadAspecialInfo)];
    [self.collectionView headerBeginRefreshing];
    
    //注册Cell，必须要有
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"HeaderCollectionViewCell"];
    
    [self.collectionView registerClass:[QSWMerchantIndexCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - 街道选择
///弹出街道选择窗口
- (void)showStreetPicker
{
    
    ///弹出地区选择窗口
    QSHomeViewController *districtPickVC = [[QSHomeViewController alloc] init];
    districtPickVC.isFirstLaunch = 0;
    [districtPickVC setTitle:@"首页"];
    districtPickVC.districtPickedCallBack = ^(NSString *key,NSString *val){
    
        ///更新标题
        UILabel *titleLabel = objc_getAssociatedObject(self, &titleLabelKey);
        titleLabel.text = val;
        self.distictID = key;
        self.distictName = val;
        
        ///刷新数据
        [self.collectionView headerBeginRefreshing];
    
    };
    [self presentViewController:districtPickVC animated:YES completion:^{
        
    }];
    
}

#pragma mark - 当前特价总数
///定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.specialDataSource count]+1;
    
}

///定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
    
}

#pragma mark - 返回的第一行
///每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
        static NSString * CellIdentifier = @"HeaderCollectionViewCell";
        
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            
            cell = [[UICollectionViewCell alloc]init];
            
        }
        
        ///创建广告页
        _advertView = [[QSAutoScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEFAULT_HOME_BANNAR_HEIGHT) andDelegate:self andScrollDirectionType:aAutoScrollDirectionTypeRightToLeft andShowPageIndex:NO andShowTime:3.0f andTapCallBack:^(id params) {
            
            ///判断是否是有效的广告地址
            if ([params valueForKey:@"url"]) {
                
                ///进入广告详情页
                QSAdvertDetailViewController *advertVC = [[QSAdvertDetailViewController alloc] initWithDetailURL:[params valueForKey:@"url"] andTitle:[params valueForKey:@"title"]];
                advertVC.navigationController.navigationBar.hidden = YES;
                advertVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:advertVC animated:YES];
                
            }
            
        }];
        [cell.contentView addSubview:_advertView];
        
        CGFloat buttonW = (SIZE_DEVICE_WIDTH - 5.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 4.0f;
        CGFloat buttonH = buttonW * 74.0f / 78.0f;
        CGFloat buttonY = SIZE_DEFAULT_HOME_BANNAR_HEIGHT + SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
        
        _sharkButton.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, buttonY, buttonW, buttonH);
        _packageButton.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 2.0f + buttonW, buttonY, buttonW, buttonH);
        _carButton.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 3.0f + 2.0f * buttonW, buttonY, buttonW, buttonH);
        _customButton.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 4.0f + 3.0f * buttonW, buttonY, buttonW, buttonH);
        _specialsLabel.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT,buttonY+buttonH+SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 180.0f, 20.0f);
        [_specialsLabel setFont:[UIFont systemFontOfSize:20.0f]];
        
        _moreButton.frame=CGRectMake(SIZE_DEVICE_WIDTH-SIZE_DEFAULT_MARGIN_LEFT_RIGHT - 30.0f, buttonY+buttonH+SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 30.0f, 20.0f);
        
        [cell.contentView addSubview:_sharkButton];
        [cell.contentView addSubview:_packageButton];
        [cell.contentView addSubview:_carButton];
        [cell.contentView addSubview:_customButton];
        [cell.contentView addSubview: _specialsLabel];
        [cell.contentView addSubview:_moreButton];
        
        return cell;
        
    } else {
        
        static NSString * CellIdentifier = @"UICollectionViewCell";
        
        QSWMerchantIndexCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell==nil) {
            
            cell=[[QSWMerchantIndexCell alloc] init];
            
        }
        
        ///获取模型
        QSGoodsDataModel *tempModel = self.specialDataSource[indexPath.row-1];
        
        cell.foodImageView.image = [UIImage imageNamed:@"home_bannar"];
        cell.foodNameLabel.text= tempModel.goodsName;
        cell.priceMarkImageView.image=[UIImage imageNamed:@"home_pricemark"];
        [cell.foodImageView loadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_SERVER_URL,tempModel.goodsImageUrl]] placeholderImage:[UIImage imageNamed:@"home_bannar"]];
        cell.priceLabel.text= [tempModel.goodsSpecialPrice floatValue] > 0.0f ? tempModel.goodsSpecialPrice : tempModel.goodsPrice;
        return cell;
        
    }
    
    return nil;
    
}

#pragma mark - 代理方法
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        return CGSizeMake(SIZE_DEVICE_WIDTH, _moreButton.frame.origin.y+_moreButton.frame.size.height);
        
    }
    
    CGFloat viewW = (SIZE_DEVICE_WIDTH - 3.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) * 0.5;
    CGFloat viewH = viewW * 289.0f / 335.0f;
    CGSize itemSize = CGSizeMake(viewW, viewH);
    
    return itemSize;
    
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MARGIN_LEFT_RIGHT);
}

#pragma mark - 点击某一个特价，进入点餐页面
///点击某一个特价，进入点餐页面
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        return;
        
    }
    
    QSGoodsDataModel *goodsItem = _specialDataSource[indexPath.row - 1];
    QSPShakeFoodView *foodDetalPopView = [QSPShakeFoodView getShakeFoodView];
    [foodDetalPopView setDelegate:self];
    [self.tabBarController.view addSubview:foodDetalPopView];
    NSArray *array = [self.tabBarController.view subviews];
    [foodDetalPopView updateFoodData:goodsItem];
    [self.tabBarController.view bringSubviewToFront:foodDetalPopView];
    [foodDetalPopView showShakeFoodView];
    
}

///返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
    
}

#pragma mark - 广告页总页数
- (int)numberOfScrollPage:(QSAutoScrollView *)autoScrollView
{
    
    if (self.BannerList.count > 0) {
        
        return (int)[self.BannerList count];
        
    }
    
    return 1;

}

#pragma mark - 返回当前广告页
- (UIView *)autoScrollViewShowView:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index
{
    
    if ([self.BannerList count] > 0) {
        
        QSBannerDataModel *tempModel = self.BannerList[index];
        UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, autoScrollView.frame.size.width, autoScrollView.frame.size.height)];
        [tempView loadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_SERVER_URL,tempModel.bannerUrl]] placeholderImage:[UIImage imageNamed:@"home_bannar"]];
        
        return tempView;
        
    }

    UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, autoScrollView.frame.size.width, autoScrollView.frame.size.height)];
    tempView.image = [UIImage imageNamed:@"home_bannar"];
    
    return tempView;

}

#pragma mark - 点击广告栏时的回调参数
- (id)autoScrollViewTapCallBackParams:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index
{

    ///获取当前广告模型
    QSBannerDataModel *advertModel = self.BannerList[index];
    NSDictionary *tempParams = advertModel.url ? @{@"url" : advertModel.url,@"title" : advertModel.goodsName} : nil;
    return tempParams ? tempParams : @"";

}

#pragma mark - 摇一摇
///点击摇一摇功能按钮
- (IBAction)sharkButtonClick:(id)sender
{
    
    UIView *shakeView = [self.tabBarController.view viewWithTag:111];
    if (!shakeView)
    {
        if(!self.shakeView)
        {
            [self initShakeView];
        }
        [self.tabBarController.view addSubview:self.shakeView];
    }
    [self.shakeView setHidden:NO];
    
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
    
    ///判断是否已经登录
    int isLogin = [[[NSUserDefaults standardUserDefaults] valueForKey:@"is_login"] intValue];
    
    if (1 == isLogin) {
        
        
        QSMapNavigationViewController *VC=[[QSMapNavigationViewController alloc]init];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
    } else {
        
        ///弹出登录框
        QSWLoginViewController *loginVC = [[QSWLoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
    
}

#pragma mark - 客服热线
///客服热线
- (IBAction)customButtonClick:(id)sender
{
    
    [self makeCall:@"02037302282"];
    
}

- (void)makeCall:(NSString *)number
{
    
    if (iOS7) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:[NSString stringWithFormat:@"呼叫 %@",number] delegate:self
                                                  cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
        alertView.tag = kCallAlertViewTag;
        self.phoneNumber = number;
        [alertView show];
        return;
        
    }
    
    ///电话弹出框
    __block UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"呼叫 %@",number] preferredStyle:UIAlertControllerStyleAlert];
    
    ///确认事件
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        ///打电话
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",number]]];
        
        ///隐藏确认框
        [alertVC dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    ///取消事件
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        ///移聊提示
        [alertVC dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }];
    
    ///添加事件
    [alertVC addAction:cancelAction];
    [alertVC addAction:confirmAction];
    
    ///弹出说明框
    [self presentViewController:alertVC animated:YES completion:^{}];
    
}

#pragma mark - IOS7打电话
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == kCallAlertViewTag) {
        
        if (buttonIndex == 1) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phoneNumber]]];
            
        }
        
    }
    
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
    
    if (![self.shakeView isHidden]) {
        
        NSLog(@"摇一摇");
        [self getRandomGoods];
        
    }
    
}

#pragma mark - 每日特价网络信息请求
///每日特价查询信息请求
- (void)downloadAspecialInfo
{
    
    //每日特价信息请求参数
    NSDictionary *dict = @{@"type" : @"1", @"key" : @"",@"goods_tag":@"4",@"send_district_id" : self.distictID};
    
    ///广告栏请求
    [self getBannerInfo];
    
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
            
//            QSNoNetworkingViewController *networkingErrorVC=[[QSNoNetworkingViewController alloc] init];
//            [self.navigationController pushViewController:networkingErrorVC animated:YES];
            
        }
        
    }];
    
}

#pragma mark - 随机菜品网络信息请求
///随机菜品网络信息请求
- (void)getRandomGoods
{
    _randRequestID++;
    [MBProgressHUD showHUDAddedTo:_shakeView animated:YES];
    //随机菜品信息请求参数
    NSDictionary *dict = @{@"num" : @"1"};
    
    [QSRequestManager requestDataWithType:rRequestTypeRandom andParams:dict andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        _randResultID++;
        if (_randResultID != _randRequestID) {
            return ;
        }
        ///判断是否请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///模型转换
            QSGoodsListReturnData *tempModel = resultData;
            NSArray *array = tempModel.goodsListData.goodsList;
            NSLog(@"获取随机菜品成功");
            
            if ([array isKindOfClass:[NSArray class]]&&[array count]>0) {
                
                QSGoodsDataModel *goodsItem = array[0];
                QSPShakeFoodView *shakeFoodView = [QSPShakeFoodView getShakeFoodView];
                [shakeFoodView setCurrentViewType:FoodDetailPopViewTypeShake];
                [shakeFoodView setDelegate:self];
                [self.shakeView addSubview:shakeFoodView];
                [shakeFoodView updateFoodData:goodsItem];
                [shakeFoodView showShakeFoodView];
                
            }
            
            
        } else {
            NSLog(@"================随机菜品信息请求失败================");
            NSLog(@"error : %@",errorInfo);
            ///弹出提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取随机菜品失败，请稍后再试……！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            
            ///显示1秒后移除提示
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                
            });
        }
        [MBProgressHUD hideHUDForView:_shakeView animated:YES];
    }];
    
}

#pragma mark - 广告图片网络信息请求
///随机菜品网络信息请求
- (void)getBannerInfo
{
    
    [QSRequestManager requestDataWithType:rRequestTypeBanner andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            //模型转换
            QSBannerReturnData *tempModel = resultData;
            
            if ([tempModel.headerData.bannerList count] > 0) {
                
                //清空的数据源
                [self.BannerList removeAllObjects];
                
                ///保存数据源
                [self.BannerList addObjectsFromArray:tempModel.headerData.bannerList];
                
                ///reload数据
                [self.collectionView reloadData];
                
            }
            
        } else {
            
            NSLog(@"================今日特价搜索信息请求失败================");
            NSLog(@"error : %@",errorInfo);
            NSLog(@"================今日特价搜索信息请求失败================");
            
//            QSNoNetworkingViewController *networkingErrorVC=[[QSNoNetworkingViewController alloc] init];
//            networkingErrorVC.hidesBottomBarWhenPushed = YES;
//            networkingErrorVC.navigationController.hidesBottomBarWhenPushed = NO;
//            [self.navigationController pushViewController:networkingErrorVC animated:YES];
            
        }
        
    }];
    
}

#pragma mark - 菜品详情弹出View改变菜品数量响应处理
///菜品详情弹出View改变菜品数量响应处理
- (void)changedWithData:(id)foodData inView:(QSPShakeFoodView*)popFoodView
{
    if (foodData&&[foodData isKindOfClass:[QSGoodsDataModel class]]) {
        QSGoodsDataModel *food = (QSGoodsDataModel*)foodData;
        if (food.goodsInstockNum.integerValue > 0) {
            [self.tabBarController setSelectedIndex:1];
            if (popFoodView.superview.tag == 111) {
                //隐藏摇一摇界面
                [popFoodView.superview setHidden:YES];
            }

            [popFoodView setHidden:YES];
            [popFoodView removeFromSuperview];
            return;
        }
    }
    ///弹出提示
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"该菜品已售罄，请换一下口味吧！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    ///显示1秒后移除提示
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        
    });
    
}

#pragma mark - 当前页面将要显示时隐藏navigationBar
- (void)viewWillAppear:(BOOL)animated
{

    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];

}

@end
