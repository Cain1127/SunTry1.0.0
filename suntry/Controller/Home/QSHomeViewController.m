//
//  QSHomeViewController.m
//  SunTry
//
//  Created by 王树朋 on 15/1/31.
//  Copyright (c) 2015年 wangshupeng. All rights reserved.
//

#import "QSHomeViewController.h"
#import "UITextField+CustomField.h"
#import "DeviceSizeHeader.h"
#import "ColorHeader.h"
#import "QSMapManager.h"
#import "QSWMerchantIndexViewController.h"
#import "QSBlockButton.h"
#import "QSRequestManager.h"
#import "MBProgressHUD.h"
#import "QSTabBarViewController.h"

#import "ChineseInclude.h"
#import "PinYinForObjc.h"

#import "QSRequestTaskDataModel.h"
#import "QSSelectDataModel.h"
#import "QSSelectReturnData.h"
#import "QSDistrictReturnData.h"
#import "QSSearchHistoryDataModel.h"

#import "QSDatePickerViewController.h"
#import "ASDepthModalViewController.h"

#import "QSNoNetworkingViewController.h"

typedef enum {
    
    DistrictListTable= 1,
    SearchListTable
    
}tableViewType;

@interface QSHomeViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSArray   *districtList;            //!<区选择数据列表
@property(nonatomic,strong) UIButton *districtButton;           //!<区选择按钮

@property (nonatomic,strong) UISearchBar *searchBar;            //!<搜索框
@property (nonatomic,strong)UIImageView *chooseImage;           //!<选择图片框

@property(nonatomic,strong) UITableView *searchListTableView;   //!<搜索返回列表view
@property (nonatomic,assign) BOOL isShowDistrictStreetList;     //!<显示当前区的数据
@property (nonatomic,assign) BOOL isShowSearchStreetList;       //!<是否显示搜索结果
@property(nonatomic,strong) NSMutableArray *tempStreetList;     //!<临时搜索返回数据
@property(nonatomic,strong) NSArray     *districtStreetList;    //!<搜索返回数据
@property (nonatomic,strong) NSMutableArray *searchHistoryList; //!<搜索历史数据

@property (nonatomic,strong) QSDatePickerViewController *customPicker;//!<选择框

@property (nonatomic,strong) MBProgressHUD *hud;                //!<hud

@end

@implementation QSHomeViewController

#pragma mark - 初始化
- (instancetype)init
{
    
    if (self = [super init]) {
        
        ///初始化数据
        self.isShowDistrictStreetList = NO;
        self.isShowSearchStreetList = NO;
        
        [self getSearchHistoryList];
        
    }
    
    return self;
    
}

#pragma mark - 获取地区数组
///获取区的接口数据
-(void)getDistrictList
{
    
    ///数据地址
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/districtData"];
    
    ///首先转成data
    NSData *saveData = [NSData dataWithContentsOfFile:path];
    
    ///encode数据
    QSDistrictReturnData *districtData = [NSKeyedUnarchiver unarchiveObjectWithData:saveData];
    
    ///遍历获取可配送区
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (QSDistrictDataModel *obj in districtData.districtList) {
        
        if ([obj.status intValue] == 1) {
            
            [tempArray addObject:obj];
            
        }
        
    }
    
    ///判断是否为空的数组
    if ([tempArray count] <= 0) {
        
        QSDistrictDataModel *defaultDistrict = [[QSDistrictDataModel alloc] init];
        defaultDistrict.districtID = @"3";
        defaultDistrict.val = @"天河区";
        defaultDistrict.status = @"1";
        [tempArray addObject:defaultDistrict];
        
    }
    
    self.districtList = [[NSMutableArray alloc] initWithArray:tempArray];
    
}

#pragma mark - 获取搜索历史数据
///获取搜索历史数据
- (void)getSearchHistoryList
{
    
    ///数据地址
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/searchHistory"];
    
    ///首先转成data
    NSData *saveData = [NSData dataWithContentsOfFile:path];
    
    ///encode数据
    NSArray *selectData = [NSKeyedUnarchiver unarchiveObjectWithData:saveData];
    self.searchHistoryList = [[NSMutableArray alloc] initWithArray:selectData];
    
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
    _districtStreetList = [[NSArray alloc] initWithArray:selectData.selectList];
    
}

#pragma mark - 加载控件
///加载控制
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    [navTitle setText:@"天河区"];
    navTitle.tag = 51;
    
    UIImageView *localImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_local"] ];
    localImageView.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
    localImageView.tag = 52;
    
    UIImageView *titleImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_arrow_down"] ];
    titleImageView.frame = CGRectMake(90.0f, 0.0f, 30.0f, 30.0f);
    titleImageView.tag = 50;
    
    _districtButton = [[UIButton alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 120.0f) / 2.0f, navRootView.frame.size.height - 37.0f, 120.0f, 30.0f)];
    [_districtButton addSubview:navTitle];
    [_districtButton addSubview:titleImageView];
    [_districtButton addSubview:localImageView];
    
    [navRootView addSubview:_districtButton];
    [_districtButton addTarget:self action:@selector(showDistrictPicker) forControlEvents:UIControlEventTouchUpInside];
    
    ///1.添加textfield输入框控件
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 72.0f, SIZE_DEFAULT_MAX_WIDTH - 44.0f - 10.0f, 44.0f)];
    self.searchBar.placeholder = @"请输入您的位置";
    self.searchBar.delegate = self;
    self.searchBar.backgroundImage = [UIImage imageNamed:@"home_search_bar_bg"];
    self.searchBar.layer.cornerRadius = 6.0f;
    self.searchBar.layer.borderWidth = 0.25f;
    [self.searchBar setImage:[UIImage imageNamed:@"public_search_normal"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.searchBar.layer.borderColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f] CGColor];
    [self.view addSubview:self.searchBar];
    
    ///2.添加搜索框按钮
    UIButton *searchButton=[[UIButton alloc] initWithFrame:CGRectMake(self.searchBar.frame.origin.x + self.searchBar.frame.size.width + 10.0f, 72.0f, 44.0f, 44.0f)];
    searchButton.backgroundColor=COLOR_CHARACTERS_RED;
    searchButton.layer.cornerRadius = 6.0f;
    [searchButton setImage:[UIImage imageNamed:@"public_search_normal"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(locationSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
    
    ///刷新数据
    [self setupSearchTabbleView];
    
    ///显示HUD
    self.hud = [MBProgressHUD showHUDAddedTo:([UIApplication sharedApplication].keyWindow.rootViewController.view ? [UIApplication sharedApplication].keyWindow.rootViewController.view : (self.tabBarController.view ? self.tabBarController.view : (self.navigationController.view ? self.navigationController.view : self.view))) animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.hud hide:YES];
        [self getDistrictList];
        [self getDistrictStreetList];
        
    });
    
}

#pragma mark - 点击搜索按钮
///点击搜索按钮
- (void)locationSearch:(UIButton *)button
{
    
    ///获取输入框信息
    NSString *searchInfo = self.searchBar.text;
    
    if (nil == searchInfo || 0 >= [searchInfo length]) {
        
        return;
        
    }
    
    ///进行搜索
    [self.searchBar resignFirstResponder];
    
    ///显示HUD
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ///一秒后隐藏
    [self.hud hide:YES afterDelay:1.0f];
    
}

#pragma mark - 弹出地区选择窗口
///弹出地区选择窗口
-(void)showDistrictPicker
{
    
    ///获取图片view
    __block UIImageView *arrowImageView = (UIImageView *)[self.districtButton viewWithTag:50];
    arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    
    ///标题
    __block UILabel *titleLabel = (UILabel *)[self.districtButton viewWithTag:51];
    
    ///创建选择框
    self.customPicker = [[QSDatePickerViewController alloc] init];
    self.customPicker.pickerType = kPickerType_Item;
    
    ///转换数据模型
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    if (nil == self.districtList || 0 >= self.districtList) {
        
        [self getDistrictList];
        
    }
    
    for (int i = 0; i < [self.districtList count]; i++) {
        
        ///获取地区模型
        QSDistrictDataModel *districtModel = self.districtList[i];
        [tempArray addObject:districtModel.val];
        
    }
    
    self.customPicker.dataSource = tempArray;
    
    ///点击取消时的回调
    self.customPicker.onCancelButtonHandler = ^{
        
        [ASDepthModalViewController dismiss];
        
        ///剪头复位
        arrowImageView.transform = CGAffineTransformIdentity;
        
    };
    
    ///点击确认时的回调
    self.customPicker.onItemConfirmButtonHandler = ^(NSInteger index,NSString *item){
        
        ///改变标题
        titleLabel.text = item;
        
        [ASDepthModalViewController dismiss];
        
        ///剪头复位
        arrowImageView.transform = CGAffineTransformIdentity;
        
    };
    
    [ASDepthModalViewController presentView:self.customPicker.view];
    
}

#pragma mark - 搜索框的UITableView搭建
///加载返回的搜索tabbleview
-(void)setupSearchTabbleView
{
    
    CGRect rect=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 120.0f, SIZE_DEFAULT_MAX_WIDTH, SIZE_DEVICE_HEIGHT - 120.0f - 49.0f);
    _searchListTableView=[[UITableView alloc]initWithFrame:rect];
    _searchListTableView.delegate = self;
    _searchListTableView.dataSource = self;
    [self.view addSubview:_searchListTableView];
    
    ///取消选择样式
    _searchListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ///取消滚动条
    _searchListTableView.showsHorizontalScrollIndicator = NO;
    _searchListTableView.showsVerticalScrollIndicator = NO;
    
}

#pragma mark - 返回有多少个区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

///返回搜索历史有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    ///如果进行搜索，则刷新搜索
    if (self.isShowSearchStreetList) {
        
        return [self.tempStreetList count];
        
    }
    
    if (self.isShowDistrictStreetList) {
        
        return [self.districtStreetList count];
        
    }
    
    if (self.searchHistoryList && [self.searchHistoryList count] > 0) {
        
        return [self.searchHistoryList count];
        
    }
    
    return 1;
    
}

///返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0f;
    
}

#pragma mark - 头标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (self.isShowSearchStreetList || self.isShowDistrictStreetList) {
     
        return 44.0f;
        
    }
    return 0.0f;

}

#pragma mark - 返回头标题
///如果是搜索的时候，显示提示头信息
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (self.isShowSearchStreetList || self.isShowDistrictStreetList) {
        
        ///提示信息
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 44.0f)];
        NSArray *tempArray = self.isShowDistrictStreetList ? self.districtStreetList : (self.isShowSearchStreetList ? self.tempStreetList : nil);
        NSString *tips = [tempArray count] > 0 ? @"可配送区域" : @"您搜索的区域暂无配送";
        tipsLabel.text = tips;
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        tipsLabel.textColor = COLOR_CHARACTERS_RED;
        return tipsLabel;
        
    } else {
    
        return nil;
    
    }

}

#pragma mark - 返回搜索项内容
///返回搜索项内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///显示搜索记录列表
    if (self.isShowSearchStreetList) {
        
        static NSString *searchDistrictStreetCell=@"searchDistrictStreetCell";
        UITableViewCell *cellSearchDistrictStree=[tableView dequeueReusableCellWithIdentifier:searchDistrictStreetCell];
        
        if (cellSearchDistrictStree==nil) {
            
            cellSearchDistrictStree=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchDistrictStreetCell];
            
        }
        
        cellSearchDistrictStree.imageView.image=[UIImage imageNamed:@"public_choose_normal"];
        cellSearchDistrictStree.selectionStyle=UITableViewCellSelectionStyleNone;
        QSSelectDataModel *tempModel = self.tempStreetList[indexPath.row];
        cellSearchDistrictStree.textLabel.text=tempModel.streetName;
        
        ///取消选择样式
        cellSearchDistrictStree.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ///分隔线
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 43.5f, SIZE_DEFAULT_MAX_WIDTH - 20.0f, 0.25f)];
        lineLabel.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f];
        [cellSearchDistrictStree.contentView addSubview:lineLabel];
        
        return cellSearchDistrictStree;
        
    }
    
    ///如果是点击了本地数据
    if (self.isShowDistrictStreetList) {
        
        static NSString *districtStreetCell=@"districtStreetCell";
        UITableViewCell *cellDistrictStree=[tableView dequeueReusableCellWithIdentifier:districtStreetCell];
        
        if (cellDistrictStree == nil) {
            
            cellDistrictStree=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:districtStreetCell];
            
        }
        
        cellDistrictStree.imageView.image = [UIImage imageNamed:@"public_choose_normal"];
        cellDistrictStree.selectionStyle = UITableViewCellSelectionStyleNone;
        QSSelectDataModel *tempModel = self.districtStreetList[indexPath.row];
        cellDistrictStree.textLabel.text = tempModel.streetName;
        
        ///取消选择样式
        cellDistrictStree.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ///分隔线
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 43.5f, SIZE_DEFAULT_MAX_WIDTH - 20.0f, 0.25f)];
        lineLabel.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f];
        [cellDistrictStree.contentView addSubview:lineLabel];
        
        return cellDistrictStree;
        
    }
    
    ///如果当前没有搜索历史
    if (!(self.isShowDistrictStreetList) && [self.searchHistoryList count] <= 0) {
        
        static NSString *localCell=@"localTipsCell";
        UITableViewCell *cellLocal=[tableView dequeueReusableCellWithIdentifier:localCell];
        
        if (cellLocal==nil) {
            
            cellLocal=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:localCell];
            
        }
        
        cellLocal.imageView.image=[UIImage imageNamed:@"public_choose_normal"];
        cellLocal.selectionStyle=UITableViewCellSelectionStyleNone;
        cellLocal.textLabel.text = @"定位当前地址";
        
        ///添加边框样式
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f)];
        lineView.backgroundColor = [UIColor clearColor];
        lineView.layer.cornerRadius = 6.0f;
        lineView.layer.borderColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f] CGColor];
        lineView.layer.borderWidth = 0.5f;
        [cellLocal.contentView addSubview:lineView];
        
        ///取消选择样式
        cellLocal.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cellLocal;
        
    }
    
    ///搜索记录
    static NSString *searchHistoryCell=@"searchHistory";
    UITableViewCell *cellSearchHistory=[tableView dequeueReusableCellWithIdentifier:searchHistoryCell];
    
    if (cellSearchHistory==nil) {
        
        cellSearchHistory=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchHistoryCell];
        
    }
    
    cellSearchHistory.imageView.image=[UIImage imageNamed:@"public_choose_normal"];
    cellSearchHistory.selectionStyle=UITableViewCellSelectionStyleNone;
    QSSearchHistoryDataModel *tempModel = self.searchHistoryList[indexPath.row];
    cellSearchHistory.textLabel.text = tempModel.title;
    
    ///取消选择样式
    cellSearchHistory.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ///分隔线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 43.5f, SIZE_DEFAULT_MAX_WIDTH - 20.0f, 0.25f)];
    lineLabel.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f];
    [cellSearchHistory.contentView addSubview:lineLabel];
    
    return cellSearchHistory;
    
}

#pragma mark - 选择某一个街道
///选择某一个街道
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///通过搜索结果进入
    if (self.isShowSearchStreetList) {
        
        ///保存数据
        QSSearchHistoryDataModel *tempModel = [[QSSearchHistoryDataModel alloc] init];
        QSSelectDataModel *selectedModel = self.tempStreetList[indexPath.row];
        tempModel.title = selectedModel.streetName;
        tempModel.key = selectedModel.streetID;
        [self addSearchHistoryData:tempModel];
        
        ///设置为历史状态
        self.isShowDistrictStreetList = NO;
        self.isShowSearchStreetList = NO;
        [self.searchListTableView reloadData];
        
        [self gotoMainHome:selectedModel.streetName andKey:selectedModel.streetID];
        return;
        
    }
    
    ///判断是否是搜索当前区
    if (self.isShowDistrictStreetList) {
        
        ///保存数据
        QSSearchHistoryDataModel *tempModel = [[QSSearchHistoryDataModel alloc] init];
        QSSelectDataModel *selectedModel = self.districtStreetList[indexPath.row];
        tempModel.title = selectedModel.streetName;
        tempModel.key = selectedModel.streetID;
        [self addSearchHistoryData:tempModel];
        
        ///设置为历史状态
        self.isShowDistrictStreetList = NO;
        self.isShowSearchStreetList = NO;
        [self.searchListTableView reloadData];
        
        [self gotoMainHome:selectedModel.streetName andKey:selectedModel.streetID];
        return;
        
    }
    
    if (nil == self.searchHistoryList || [self.searchHistoryList count] <= 0) {
        
        self.isShowDistrictStreetList = YES;
        [self.searchListTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
        
    } else {
        
        ///获取点击的记录
        QSSearchHistoryDataModel *tempModel = self.searchHistoryList[indexPath.row];
        [self gotoMainHome:(tempModel.title ? tempModel.title : @"体育西路") andKey:(tempModel.key ? tempModel.key :@"299")];
        
    }
    
}

#pragma mark - 进入首页
- (void)gotoMainHome:(NSString *)title andKey:(NSString *)key
{
    
    ///保存当前选择项
    [[NSUserDefaults standardUserDefaults] setObject:title forKey:@"street"];
    [[NSUserDefaults standardUserDefaults] setObject:key forKey:@"streetID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    ///判断是否是从首页过来的
    if (self.isFirstLaunch == 0) {
        
        ///回调
        if (self.districtPickedCallBack) {
            
            self.districtPickedCallBack(key,title);
            
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        return;
        
    }
    
    ///修改
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isFirstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    QSTabBarViewController *VC = [[QSTabBarViewController alloc] initWithID:key andDistictName:title];
    [UIApplication sharedApplication].keyWindow.rootViewController = VC;
    
}

#pragma mark - 进入搜索框时，列出所有可选区
///进入搜索框时，列出所有可选区
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    self.isShowDistrictStreetList = YES;
    self.isShowSearchStreetList = NO;
    
    if (nil == self.districtStreetList) {
        
        ///先创建数据
        [self getDistrictStreetList];
        
    }
    
    ///0.22秒后刷新数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.searchListTableView reloadData];
        
    });
    return YES;
    
}

///点键键盘上的搜索按钮
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    
    if (searchBar.text || 0 < [searchBar.text length]) {
        
        return;
        
    } else {
        
        self.isShowDistrictStreetList = YES;
        self.isShowSearchStreetList = NO;
        [self.searchListTableView reloadData];
        
    }
    
}

///键盘回收
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.searchBar resignFirstResponder];
    
}

#pragma mark - 搜索框输入内容
///输入框的输入内容不断变化
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    ///获取输入的关键字
    NSString *searchKey = searchText;
    
    ///判断是否清空事件
    if (nil == searchText || 0 >= [searchText length]) {
        
        self.isShowSearchStreetList = NO;
        self.isShowDistrictStreetList = YES;
        [self.searchListTableView reloadData];
        return;
        
    }
    
    ///设置搜索
    self.isShowSearchStreetList = YES;
    self.isShowDistrictStreetList = NO;
    
    if (self.tempStreetList) {
        
        [self.tempStreetList removeAllObjects];
        
    } else {
        
        self.tempStreetList = [[NSMutableArray alloc] init];
        
    }
    
    if (searchKey.length > 0 && ![ChineseInclude isIncludeChineseInString:searchKey]) {
        
        for (int i = 0;i < self.districtStreetList.count;i++) {
            
            ///临时模型
            QSSelectDataModel *tempModel = self.districtStreetList[i];
            
            if ([ChineseInclude isIncludeChineseInString:tempModel.streetName]) {
                
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:tempModel.streetName];
                NSRange titleResult = [tempPinYinStr rangeOfString:searchKey options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    
                    [self.tempStreetList addObject:tempModel];
                    continue;
                    
                }
                
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:tempModel.streetName];
                NSRange titleHeadResult = [tempPinYinHeadStr rangeOfString:searchKey options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length > 0) {
                    
                    [self.tempStreetList addObject:tempModel];
                    
                }
                
            } else {
                
                NSRange titleResult=[tempModel.streetName rangeOfString:searchKey options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    
                    [self.tempStreetList addObject:tempModel];
                    
                }
                
            }
            
        }
        
    } else if (searchKey.length > 0 && [ChineseInclude isIncludeChineseInString:searchKey]) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streetName CONTAINS %@",searchKey];
        [self.tempStreetList addObjectsFromArray:[self.districtStreetList filteredArrayUsingPredicate:predicate]];
        
    }
    
    ///刷新数据
    [self.searchListTableView reloadData];
    
}

#pragma mark - 添加搜索历史
- (void)addSearchHistoryData:(QSSearchHistoryDataModel *)model
{
    
    ///循环原数据，判断是否存在，已存在，则不再保存
    for (QSSearchHistoryDataModel *obj in self.searchHistoryList) {
        
        if ([obj.key isEqualToString:model.key]) {
            
            return;
            
        }
        
    }
    
    ///添加
    [self.searchHistoryList addObject:model];
    
    ///更新本地
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/searchHistory"];
    
    ///首先转成data
    NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:self.searchHistoryList];
    [saveData writeToFile:path atomically:YES];
    
}

@end
