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

#import "QSRequestTaskDataModel.h"
#import "QSSelectDataModel.h"
#import "QSSelectReturnData.h"
#import "QSDistrictReturnData.h"
#import "QSSearchHistoryDataModel.h"

#import "QSDatePickerViewController.h"
#import "ASDepthModalViewController.h"

typedef enum {
    
    DistrictListTable= 1,
    SearchListTable
    
}tableViewType;

@interface QSHomeViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL isOpened;
}

@property(nonatomic,strong) NSArray   *districtList;            //!<区选择数据列表
@property(nonatomic,strong) UIButton *districtButton;           //!<区选择按钮

@property (nonatomic,strong) UITextField *inputField;           //!<输入框
@property (nonatomic,strong)UIImageView *chooseImage;           //!<选择图片框

@property(nonatomic,strong) UITableView *searchListTableView;   //!<搜索返回列表view
@property (nonatomic,assign) BOOL isShowDistrictStreetList;     //!<显示当前区的数据
@property(nonatomic,strong) NSArray     *districtStreetList;    //!<搜索返回数据
@property (nonatomic,strong) NSArray *searchHistoryList;        //!<搜索历史数据

@property (nonatomic,strong) QSDatePickerViewController *customPicker;//!<选择框

@end

@implementation QSHomeViewController

#pragma mark - 获取地区数组
///获取区的接口数据
-(NSArray *)districtList
{
    
    if (_districtList==nil) {
        
        ///数据地址
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/districtData"];
        
        ///首先转成data
        NSData *saveData = [NSData dataWithContentsOfFile:path];
        
        ///encode数据
        QSDistrictReturnData *districtData = [NSKeyedUnarchiver unarchiveObjectWithData:saveData];
        self.districtList = [[NSMutableArray alloc] initWithArray:districtData.districtList];
        
    }
    
    return _districtList;
    
}

#pragma mark - 获取搜索历史数据
///获取搜索历史数据
- (NSArray *)searchHistoryList
{
    
    if (nil == _searchHistoryList) {
        
        ///数据地址
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/searchHistory"];
        ///首先转成data
        NSData *saveData = [NSData dataWithContentsOfFile:path];
        
        ///encode数据
        NSArray *selectData = [NSKeyedUnarchiver unarchiveObjectWithData:saveData];
        _searchHistoryList = [[NSArray alloc] initWithArray:selectData];
        
    }
    
    return _searchHistoryList;
    
}

#pragma mark - 获取本地位置的区信息
///获取本地位置的区信息
-(NSArray *)districtStreetList
{
    
    if (_districtStreetList==nil) {
        
        ///数据地址
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/selectData"];
        ///首先转成data
        NSData *saveData = [NSData dataWithContentsOfFile:path];
        
        ///encode数据
        QSSelectReturnData *selectData = [NSKeyedUnarchiver unarchiveObjectWithData:saveData];
        _districtStreetList = [[NSArray alloc] initWithArray:selectData.selectList];
        
    }
    
    return _districtStreetList;
    
}

#pragma mark - 加载控件
///加载控制
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    isOpened=NO;
    
    ///0.添加导航栏主题view
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70.0f, 30.0f)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentRight];
    [navTitle setText:@"天河区"];
    navTitle.tag = 51;
    
    UIImageView *titleImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_arrow_down"] ];
    titleImageView.tag = 50;
    
    _districtButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 110.0f, 30.0f)];
    [_districtButton addSubview:navTitle];
    [_districtButton addSubview:titleImageView];
    
    self.navigationItem.titleView = _districtButton;
    [_districtButton addTarget:self action:@selector(setupTopTableView) forControlEvents:UIControlEventTouchUpInside];
    
    ///1.添加textfield输入框控件
    self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 72.0f, SIZE_DEFAULT_MAX_WIDTH - 44.0f - 5.0f, 44.0f)];
    self.inputField.placeholder = @"请输入您的位置";
    self.inputField.translatesAutoresizingMaskIntoConstraints=NO;
    self.inputField.returnKeyType=UIReturnKeySearch;
    self.inputField.clearButtonMode=UITextFieldViewModeUnlessEditing;
    self.inputField.delegate=self;
    self.inputField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.inputField];
    
    ///2.添加搜索框按钮
    UIButton *searchButton=[[UIButton alloc] initWithFrame:CGRectMake(self.inputField.frame.origin.x + self.inputField.frame.size.width + 5.0f, 72.0f, 44.0f, 44.0f)];
    searchButton.translatesAutoresizingMaskIntoConstraints=NO;
    searchButton.backgroundColor=COLOR_CHARACTERS_RED;
    searchButton.layer.cornerRadius = 6.0f;
    [searchButton setImage:[UIImage imageNamed:@"public_search_normal"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(locationSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
    
    ///刷新数据
    [self setupSearchTabbleView];
    
}

#pragma mark - 点击搜索按钮
///点击搜索按钮
- (void)locationSearch:(UIButton *)button
{
    
    ///获取输入框信息
    NSString *searchInfo = self.inputField.text;
    
    if (nil == searchInfo || 0 >= [searchInfo length]) {
        
        return;
        
    }
    
    ///进行搜索
    
    
}

#pragma mark - 弹出地区选择窗口
///弹出地区选择窗口
-(void)setupTopTableView
{
    
    // 1.(状态取反)
    isOpened=!isOpened;
    
    if (isOpened) {
        
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
        
    } else {
        
        ///获取图片view
        UIImageView *arrowImageView = (UIImageView *)[self.districtButton viewWithTag:50];
        arrowImageView.transform = CGAffineTransformIdentity;
        [ASDepthModalViewController dismiss];
        
    }
    
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
    
    if (self.searchHistoryList && [self.searchHistoryList count] > 0) {
        
        return [self.searchHistoryList count];
        
    }
    
    if (self.isShowDistrictStreetList) {
        
        return [self.districtStreetList count];
        
    }
    
    return 1;
    
}

///返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0f;
    
}

#pragma mark - 返回搜索项内容
///返回搜索项内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    
    ///如果是点击了本地数据
    if (self.isShowDistrictStreetList) {
        
        static NSString *districtStreetCell=@"districtStreetCell";
        UITableViewCell *cellDistrictStree=[tableView dequeueReusableCellWithIdentifier:districtStreetCell];
        
        if (cellDistrictStree==nil) {
            
            cellDistrictStree=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:districtStreetCell];
            
        }
        
        cellDistrictStree.imageView.image=[UIImage imageNamed:@"public_choose_normal"];
        cellDistrictStree.selectionStyle=UITableViewCellSelectionStyleNone;
        QSSelectDataModel *tempModel = self.districtStreetList[indexPath.row];
        cellDistrictStree.textLabel.text=tempModel.streetName;
        
        ///取消选择样式
        cellDistrictStree.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ///分隔线
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 43.5f, SIZE_DEFAULT_MAX_WIDTH - 20.0f, 0.25f)];
        lineLabel.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f];
        [cellDistrictStree.contentView addSubview:lineLabel];
        
        return cellDistrictStree;
        
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
    cellSearchHistory.textLabel.text=tempModel.title;
    
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
    
    ///判断是否是搜索当前区
    if (self.isShowDistrictStreetList) {
        
        QSWMerchantIndexViewController *VC=[[QSWMerchantIndexViewController alloc] initWithID:@"299" andDistictName:@"体育西"];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    
    if (nil == self.searchHistoryList || [self.searchHistoryList count] <= 0) {
        
        self.isShowDistrictStreetList = YES;
        [self.searchListTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
        
    } else {
        
        QSWMerchantIndexViewController *VC=[[QSWMerchantIndexViewController alloc] initWithID:@"299" andDistictName:@"体育西"];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    
}

///键盘回收
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
    
}

///键盘回收
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITextField *textField = (UITextField *)[self.view viewWithTag:200];
    [textField resignFirstResponder];
    
}

@end
