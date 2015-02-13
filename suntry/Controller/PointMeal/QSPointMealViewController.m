//
//  QSPointMealViewController.m
//  SunTry
//
//  Created by 王树朋 on 15/1/31.
//  Copyright (c) 2015年 wangshupeng. All rights reserved.
//

#import "QSPointMealViewController.h"
#import "DeviceSizeHeader.h"
#import "QSPShakeFoodView.h"
#import "QSPFoodTypeTableViewCell.h"
#import "QSAppDelegate.h"
#import "ImageHeader.h"
#import "QSBlockButton.h"
#import "QSPFoodPackageView.h"
#import "QSPOrderViewController.h"
#import "MBProgressHUD.h"
#import "QSRequestManager.h"
#import "QSGoodsStapleFoodReturnData.h"

#define FOOD_TYPE_TABLEVIEW_BACKGROUND_COLOR  [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.]
#define FOOD_INFOLIST_TABLEVIEW_BACKGROUND_COLOR  [UIColor whiteColor]

#define FOOD_TYPE_TABLEVIEW_CELL_HEIGHT                     50.
#define FOOD_INFOLIST_TABLEVIEW_CELL_HEIGHT                 80.
#define FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_HEIGHT          40.
#define FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_HEIGHT    24.
#define FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_COLOR     FOOD_TYPE_TABLEVIEW_BACKGROUND_COLOR


enum TableViewType{
    FoodTypeTable = 1,
    FoodInfoListTable
};

//typedef enum {
//    FoodType    = 0,
//    FoodType    = 1,
//    FoodType    = 2,
//    FoodType         = 3,
//} FoodType;

@interface QSPointMealViewController ()

@property(nonatomic,strong) UITableView *foodTypeTableView;
@property(nonatomic,strong) NSArray     *foodTypeList;
@property(nonatomic,strong) UITableView *foodInfoListTableView;
@property(nonatomic,strong) NSArray     *foodInfoList;
@property(nonatomic,strong) QSPShoppingCarView *shoppingCarView;
@property(nonatomic,strong) QSGoodsStapleFoodHeaderData *allGoodsData;

@end

@implementation QSPointMealViewController

- (void)loadView{
    
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"美食餐单"];
    self.navigationItem.titleView = navTitle;
    
    QSBlockButtonStyleModel *backButtonStyle = [[QSBlockButtonStyleModel alloc] init];
    [backButtonStyle setImagesNormal:IMAGE_NAVIGATIONBAR_BACK_NORMAL];
    [backButtonStyle setImagesHighted:IMAGE_NAVIGATIONBAR_MEINFO_HIGHLIGHTED];
 
    UIButton *backButton = [UIButton createBlockButtonWithFrame:CGRectMake(0, 0, 44, 44) andButtonStyle:backButtonStyle andCallBack:^(UIButton *button) {
        [self.tabBarController setSelectedIndex:0];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.shoppingCarView = [[QSPShoppingCarView alloc] initShakeFoodView];
    [_shoppingCarView setFrame:CGRectMake(0, SIZE_DEVICE_HEIGHT-_shoppingCarView.frame.size.height-20-44, _shoppingCarView.frame.size.width, _shoppingCarView.frame.size.height)];
    [_shoppingCarView setProcessType:ProcessTypeOnSelectedFood];
    [_shoppingCarView setDelegate:self];
    [_shoppingCarView updateShoppingCar];
    
//    self.foodTypeList = [NSArray arrayWithObjects:@"优惠特价",@"健康餐",@"养生炖汤",@"营养套餐", nil];
//    self.foodInfoList = [NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
    self.foodTypeList = [NSArray array];
    self.foodInfoList = [NSArray array];
    
    self.foodTypeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FOOD_TYPE_TABLEVIEW_WIDTH, SIZE_DEVICE_HEIGHT-44-20-_shoppingCarView.frame.size.height)];
    [self.foodTypeTableView setDelegate:self];
    [self.foodTypeTableView setDataSource:self];
    [self.foodTypeTableView setBounces:YES];
    [self.foodTypeTableView setShowsVerticalScrollIndicator:NO];
    [self.foodTypeTableView setTag:FoodTypeTable];
    [self.foodTypeTableView setBackgroundColor:FOOD_TYPE_TABLEVIEW_BACKGROUND_COLOR];
    [self.foodTypeTableView setTableFooterView:[[UIView alloc] init]];
    [self.foodTypeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.foodTypeTableView];
    
    self.foodInfoListTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.foodTypeTableView.frame.origin.x+self.foodTypeTableView.frame.size.width, 0, SIZE_DEVICE_WIDTH-self.foodTypeTableView.frame.size.width, SIZE_DEVICE_HEIGHT-44-20-_shoppingCarView.frame.size.height)];
    [self.foodInfoListTableView setDelegate:self];
    [self.foodInfoListTableView setDataSource:self];
    [self.foodInfoListTableView setBounces:YES];
    [self.foodInfoListTableView setShowsVerticalScrollIndicator:NO];
    [self.foodInfoListTableView setTag:FoodInfoListTable];
    [self.foodInfoListTableView setBackgroundColor:FOOD_INFOLIST_TABLEVIEW_BACKGROUND_COLOR];
    [self.foodInfoListTableView setTableFooterView:[[UIView alloc] init]];
    [self.foodInfoListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.foodInfoListTableView];
    
    [self.view addSubview:_shoppingCarView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[self.foodTypeTableView visibleCells] count]>0) {
        [self.foodTypeTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self getGoodsData];
        
    });
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    NSInteger count = 1;
    
    switch (tableView.tag){
            
        case FoodTypeTable:
            
            break;
            
        case FoodInfoListTable:
            
            if (_foodTypeList&&[_foodTypeList count]>0) {
                count = [_foodTypeList count];
            }
            
            break;
        default:
            break;
            
    }
    
    return count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger count = 0;
    
    switch (tableView.tag){
            
        case FoodTypeTable:
            
            if (_foodTypeList&&[_foodTypeList count]>0) {
                count = [_foodTypeList count];
            }
            
            break;
            
#if 0
        case FoodInfoListTable:
            
            if (_allGoodsData) {
                
                switch (section) {
                    case 0:
                        if (_allGoodsData.specialList && [_allGoodsData.specialPriceGoodsList isKindOfClass:[NSArray class]])
                        {
                            
                            count = [_allGoodsData.specialPriceGoodsList count];
                            
                        }
                        break;
                    case 1:
                        if (_allGoodsData.riceGoodsList&&[_allGoodsData.riceGoodsList isKindOfClass:[NSArray class]])
                        {
                            count = [_allGoodsData.riceGoodsList count];
                        }
                        break;
                    case 2:
                        if (_allGoodsData.soupGoodsList&&[_allGoodsData.soupGoodsList isKindOfClass:[NSArray class]])
                        {
                            count = [_allGoodsData.soupGoodsList count];
                        }
                        break;
                    case 3:
                        if (_allGoodsData.menuPackageGoodsList&&[_allGoodsData.menuPackageGoodsList isKindOfClass:[NSArray class]])
                        {
                            count = [_allGoodsData.menuPackageGoodsList count];
                        }
                        break;
                    default:
                        break;
                }
                
            }
#endif
            
            break;
        default:
            break;
            
    }
    
    return count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    CGFloat height = 0;
    
    switch (tableView.tag){
            
        case FoodTypeTable:
            
            break;
            
        case FoodInfoListTable:
            
            height = FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_HEIGHT;
            
            break;
        default:
            break;
            
    }
    
    return height;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = 0;
    
    switch (tableView.tag){
            
        case FoodTypeTable:
            
            height = FOOD_TYPE_TABLEVIEW_CELL_HEIGHT;
            
            break;
            
        case FoodInfoListTable:
            
            height = FOOD_INFOLIST_TABLEVIEW_CELL_HEIGHT;
            
            break;
        default:
            break;
            
    }
    
    return height;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_HEIGHT)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    UIView *titleBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_HEIGHT-FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_HEIGHT, tableView.frame.size.width-10*2, FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_HEIGHT)];
    [titleBackgroundView setBackgroundColor:FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_COLOR];
    [headerView addSubview:titleBackgroundView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, titleBackgroundView.frame.size.width, titleBackgroundView.frame.size.height)];
    
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    if (_foodTypeList&&[_foodTypeList count]>0&&[_foodTypeList count]>section) {
        [titleLabel setText:_foodTypeList[section]];
    }
    
    [titleBackgroundView addSubview:titleLabel];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
#if 0
    
    switch (tableView.tag) {
            
        case FoodTypeTable:
            {
                
                static NSString *foodTypeTableViewIdentifier = @"FoodTypeTableCell";
                QSPFoodTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:foodTypeTableViewIdentifier];
                
                if (cell == nil) {
                    
                    cell = [[QSPFoodTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:foodTypeTableViewIdentifier];
                    
                }
                
                [cell setFoodTypeName:@""];
                if (_foodTypeList&&[_foodTypeList count]>indexPath.row) {
                    [cell setFoodTypeName:_foodTypeList[indexPath.row]];
                }
                return cell;
                
            }
            break;
        case FoodInfoListTable:
            {
                
                static NSString *foodInfoListTableViewIdentifier = @"foodInfoListTableCell";
                QSPFoodInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:foodInfoListTableViewIdentifier];
                
                if (cell == nil) {
                    
                    cell = [[QSPFoodInfoListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:foodInfoListTableViewIdentifier];
                    [cell setDelegate:self];
                    
                }
                
                [cell setSlelectedCount:0];
                
                NSArray *tempArray = nil;
                
                if (_allGoodsData) {
                    
                    switch (indexPath.section) {
                        case 0:
                            if (_allGoodsData.specialPriceGoodsList&&[_allGoodsData.specialPriceGoodsList isKindOfClass:[NSArray class]]&&[_allGoodsData.specialPriceGoodsList count]>indexPath.row)
                            {
                                tempArray = _allGoodsData.specialPriceGoodsList;
                            }
                            break;
                        case 1:
                            if (_allGoodsData.riceGoodsList&&[_allGoodsData.riceGoodsList isKindOfClass:[NSArray class]]&&[_allGoodsData.riceGoodsList count]>indexPath.row)
                            {
                                tempArray = _allGoodsData.riceGoodsList;
                            }
                            break;
                        case 2:
                            if (_allGoodsData.soupGoodsList&&[_allGoodsData.soupGoodsList isKindOfClass:[NSArray class]]&&[_allGoodsData.soupGoodsList count]>indexPath.row)
                            {
                                tempArray = _allGoodsData.soupGoodsList;
                            }
                            break;
                        case 3:
                            if (_allGoodsData.menuPackageGoodsList&&[_allGoodsData.menuPackageGoodsList isKindOfClass:[NSArray class]]&&[_allGoodsData.menuPackageGoodsList count]>indexPath.row)
                            {
                                tempArray = _allGoodsData.menuPackageGoodsList;
                            }
                            break;
                        default:
                            break;
                    }
                }
                
                if (tempArray){
                    [cell updateFoodData:tempArray[indexPath.row]];
                }

                NSArray *selectedArray = [_shoppingCarView getGoods];
                if (selectedArray&&[selectedArray count]>0) {
                    for (int i=0; i<[selectedArray count]; i++) {
                        NSDictionary *item = selectedArray[i];
                        NSNumber *counNum = [item objectForKey:@"count"];
                        QSGoodsDataModel *goodData = [cell getFoodData];
                        QSGoodsDataModel *food = [item objectForKey:@"goods"];
                        if (food&&[food isKindOfClass:[QSGoodsDataModel class]]&&goodData&&[goodData isKindOfClass:[QSGoodsDataModel class]]) {
                            
                            if ([food.goodsName isEqualToString:((QSGoodsDataModel*)goodData).goodsName]) {
                                
                                [cell setSlelectedCount:[counNum integerValue]];
                                
                            }
                        }
                    }
                }
                
                return cell;
                
            }
            break;
            
        default:
            
            return nil;
            
    }
#endif
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (tableView.tag){
            
        case FoodTypeTable:
            {
                NSInteger selectRow = indexPath.row;
                if (selectRow<[self.foodInfoListTableView numberOfSections]) {
                    [self.foodInfoListTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectRow] animated:YES scrollPosition:UITableViewScrollPositionTop];
                }
            }
            break;
            
        case FoodInfoListTable:
            {
                NSArray *tempArray = nil;
                
                if (_allGoodsData) {
                    
#if 0
                    switch (indexPath.section) {
                        case 0:
                            if (_allGoodsData.specialPriceGoodsList&&[_allGoodsData.specialPriceGoodsList isKindOfClass:[NSArray class]]&&[_allGoodsData.specialPriceGoodsList count]>indexPath.row)
                            {
                                tempArray = _allGoodsData.specialPriceGoodsList;
                            }
                            break;
                        case 1:
                            if (_allGoodsData.riceGoodsList&&[_allGoodsData.riceGoodsList isKindOfClass:[NSArray class]]&&[_allGoodsData.riceGoodsList count]>indexPath.row)
                            {
                                tempArray = _allGoodsData.riceGoodsList;
                            }
                            break;
                        case 2:
                            if (_allGoodsData.soupGoodsList&&[_allGoodsData.soupGoodsList isKindOfClass:[NSArray class]]&&[_allGoodsData.soupGoodsList count]>indexPath.row)
                            {
                                tempArray = _allGoodsData.soupGoodsList;
                            }
                            break;
                        case 3:
                            if (_allGoodsData.menuPackageGoodsList&&[_allGoodsData.menuPackageGoodsList isKindOfClass:[NSArray class]]&&[_allGoodsData.menuPackageGoodsList count]>indexPath.row)
                            {
                                tempArray = _allGoodsData.menuPackageGoodsList;
                            }
                            break;
                        default:
                            break;
                    }
#endif
                    
                }
                
                if (tempArray){
                    QSGoodsDataModel *itemData = tempArray[indexPath.row];
                    if (itemData&&[itemData isKindOfClass:[QSGoodsDataModel class]]) {
                        if ([itemData.goodsTypeID integerValue] == 1) {
                            
                            QSPShakeFoodView *shakeFoodView = [QSPShakeFoodView getShakeFoodView];
                            [self.tabBarController.view addSubview:shakeFoodView];
                            [shakeFoodView updateFoodData:itemData];
                            [shakeFoodView showShakeFoodView];
                            
                        }else if ([itemData.goodsTypeID integerValue] == 5) {
                            
                            QSPFoodPackageView *packageView = [QSPFoodPackageView getPackageView];
                            [self.navigationController.view addSubview:packageView];
                            [packageView showPackageView];
                            
                        }
                        
                    }

                }
                
            }
            break;
        default:
            break;
            
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.foodInfoListTableView)
    {
        
        CGFloat sectionHeaderHeight = FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_HEIGHT;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            
        }
        
        NSInteger currentSectionIdx = 0;
        
        NSArray *visbleIndexPath = [self.foodInfoListTableView indexPathsForVisibleRows];
        
        if ([visbleIndexPath count]>1) {
            
            NSIndexPath *second = visbleIndexPath[1];
            
            if (second) {
                
                currentSectionIdx = second.section;
                
            }
            
            if (scrollView&&[scrollView isKindOfClass:[UITableView class]]) {
                [(UITableView*)scrollView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentSectionIdx inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            }

        }
        
    }
    
}

- (void)changedCount:(NSInteger)count withFoodData:(id)foodData
{
    
    NSLog(@"changedCount:%ld withFoodData:%@",(long)count,foodData);
    
    if (_shoppingCarView) {
        [_shoppingCarView changeGoods:foodData withCount:count];
    }
    
}

- (void)orderWithData:(id)foodData
{
    
    NSLog(@"orderWithData:%@",foodData);

    QSPOrderViewController *orderVc = [[QSPOrderViewController alloc] init];
    [orderVc setFoodSelectedList:[NSMutableArray arrayWithArray:foodData]];
    [self.navigationController pushViewController:orderVc animated:YES];
    
}

- (void)getGoodsData
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [QSRequestManager requestDataWithType:rRequestTypeAllGoods andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///模型转换 
            QSGoodsStapleFoodReturnData *tempModel = resultData;
            
            self.allGoodsData = tempModel.headerMSG;
            
            NSLog(@"allGoodsData : %@",_allGoodsData);
            
            
        } else {
            
            NSLog(@"================所有菜品数据请求失败================");
            NSLog(@"error : %@",errorInfo);
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
