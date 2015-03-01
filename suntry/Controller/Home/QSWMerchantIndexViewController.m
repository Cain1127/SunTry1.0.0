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

#import "QSDatePickerViewController.h"
#import "ASDepthModalViewController.h"
#import "QSSelectReturnData.h"
#import "QSSelectDataModel.h"

#import <objc/runtime.h>

#import "QSBlockButton.h"

#define kCallAlertViewTag 111

///关联
static char titleLabelKey;//!<标题key

@interface QSWMerchantIndexViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *foodImageView;    //!<菜品图片
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

@property (nonatomic, copy) NSString *phoneNumber;                  //!<电话号码

@property (nonatomic, strong) UIButton  *shakeView;     //摇一摇界面

@end

@implementation QSWMerchantIndexViewController

#pragma mark - 初始化
///初始化
- (instancetype)initWithID:(NSString *)distictID andDistictName:(NSString *)districtName
{
    
    if (self = [super init]) {
        
        self.distictID = distictID ? distictID : ([[NSUserDefaults standardUserDefaults] objectForKey:@"streetID"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"streetID"] : @"299");
        self.distictName = districtName ? districtName : ([[NSUserDefaults standardUserDefaults] objectForKey:@"street"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"street"] : @"体育西路");
        
        ///初始化数据源数组
        self.specialDataSource = [[NSMutableArray alloc] init];
        
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
    [navTitle setTextAlignment:NSTextAlignmentRight];
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
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 64.0f-SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 49.0f) collectionViewLayout:flowLayout];
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
    
    ///标题
    __block UILabel *titleLabel = objc_getAssociatedObject(self, &titleLabelKey);
    
    ///创建选择框
    self.customPicker = [[QSDatePickerViewController alloc] init];
    self.customPicker.pickerType = kPickerType_Item;
    
    ///转换数据模型
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    if (nil == self.streetList || 0 >= self.streetList) {
        
        [self getDistrictStreetList];
        
    }
    
    for (int i = 0; i < [self.streetList count]; i++) {
        
        ///获取地区模型
        QSSelectDataModel *streetModel = self.streetList[i];
        
        if ([streetModel.isSend intValue] == 1) {
            
            [tempArray addObject:streetModel.streetName];
            
        }
        
    }
    
    self.customPicker.dataSource = tempArray;
    
    ///点击取消时的回调
    self.customPicker.onCancelButtonHandler = ^{
        
        [ASDepthModalViewController dismiss];
        
    };
    
    ///self的弱引用
    __weak QSWMerchantIndexViewController *weakSelf = self;
    
    ///点击确认时的回调
    self.customPicker.onItemConfirmButtonHandler = ^(NSInteger index,NSString *item){
        
        ///改变标题
        titleLabel.text = item;
        
        ///刷新数据
        [weakSelf.collectionView headerBeginRefreshing];
        
        [ASDepthModalViewController dismiss];
        
    };
    
    [ASDepthModalViewController presentView:self.customPicker.view];
    
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
        
        if (cell==nil) {
            
            cell=[[UICollectionViewCell alloc]init];
            
        }
        
        _foodImageView.frame=CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEFAULT_HOME_BANNAR_HEIGHT);
        
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
        
        [cell.contentView addSubview:_foodImageView];
        [cell.contentView addSubview:_sharkButton];
        [cell.contentView addSubview:_packageButton];
        [cell.contentView addSubview:_carButton];
        [cell.contentView addSubview:_customButton];
        [cell.contentView addSubview: _specialsLabel];
        [cell.contentView addSubview:_moreButton];
        return cell;
        
    }
    else{
        static NSString * CellIdentifier = @"UICollectionViewCell";
        
        QSWMerchantIndexCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell==nil) {
            
            cell=[[QSWMerchantIndexCell alloc] init];
            
        }
        
        ///获取模型
        QSGoodsDataModel *tempModel = self.specialDataSource[indexPath.row-1];
        
        cell.foodImageView.image=[UIImage imageNamed:@"home_bannar"];
        cell.foodNameLabel.text= tempModel.goodsName;
        cell.priceMarkImageView.image=[UIImage imageNamed:@"home_pricemark"];
        [cell.foodImageView loadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://admin.9dxz.com/files/%@",tempModel.goodsImageUrl]] placeholderImage:[UIImage imageNamed:@"home_bannar"]];
        cell.priceLabel.text= tempModel.goodsSpecialPrice;
        return cell;
    }
    
    return nil;
    
}

#pragma mark --代理方法

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
    
    if (indexPath.row==0) {
        
        return;
        
    }
    
    QSGoodsDataModel *goodsItem = _specialDataSource[indexPath.row - 1];
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
    
    UIView *shakeView = [self.tabBarController.view viewWithTag:111];
    if (!shakeView) {
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
    
    QSMapNavigationViewController *VC=[[QSMapNavigationViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    
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

#pragma mark --IOS7打电话
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
    //FIXME: 需要完善逻辑，预防网络慢时同时触发调用的问题。
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
                [shakeFoodView setCurrentViewType:FoodDetailPopViewTypeShake];
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
        
    }];
    
}

@end
