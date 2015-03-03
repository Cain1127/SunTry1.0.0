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
#import "QSWLoginViewController.h"
#import "QSNoNetworkingViewController.h"

#define FOOD_TYPE_TABLEVIEW_BACKGROUND_COLOR  [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.]
#define FOOD_INFOLIST_TABLEVIEW_BACKGROUND_COLOR  [UIColor whiteColor]

#define FOOD_TYPE_TABLEVIEW_CELL_HEIGHT                     50.
#define FOOD_INFOLIST_TABLEVIEW_CELL_HEIGHT                 80.
#define FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_HEIGHT          40.
#define FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_HEIGHT    24.
#define FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_COLOR     FOOD_TYPE_TABLEVIEW_BACKGROUND_COLOR
#define FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_FONT_SIZE 17.

enum TableViewType{
    FoodTypeTable = 1,
    FoodInfoListTable
};

typedef enum {
    FoodTypeSPecial     = 0,
    FoodTypeHeathy      = 1,
    FoodTypeSoup        = 2,
    FoodTypePackage     = 3,
} FoodType;

@interface QSPointMealViewController ()<QSPShakeFoodViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) UITableView     *foodTypeTableView;
@property(nonatomic,strong) NSMutableArray  *foodTypeList;
@property(nonatomic,strong) UITableView     *foodInfoListTableView;
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
        
        if ([QSPShoppingCarData getTotalFoodCount]==0) {
            [self.tabBarController setSelectedIndex:0];
            return ;
        }
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否清空购物车？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [av show];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    CGFloat offetY = 0;
    if ([[UIDevice currentDevice].systemVersion doubleValue] == 7.0) {
        offetY = 64;
    }
    
    self.shoppingCarView = [[QSPShoppingCarView alloc] initShakeFoodView];
    [_shoppingCarView setFrame:CGRectMake(0, SIZE_DEVICE_HEIGHT-_shoppingCarView.frame.size.height-20-44+offetY, _shoppingCarView.frame.size.width, _shoppingCarView.frame.size.height)];
    [_shoppingCarView setProcessType:ProcessTypeOnSelectedFood];
    [_shoppingCarView setDelegate:self];
    [_shoppingCarView updateShoppingCar];
    
//    self.foodTypeList = [NSArray arrayWithObjects:@"优惠特价",@"健康餐",@"养生炖汤",@"营养套餐", nil];
//    self.foodInfoList = [NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
    self.foodTypeList = [NSMutableArray array];
    
    self.foodTypeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, offetY, FOOD_TYPE_TABLEVIEW_WIDTH, SIZE_DEVICE_HEIGHT-44-20-_shoppingCarView.frame.size.height)];
    [self.foodTypeTableView setDelegate:self];
    [self.foodTypeTableView setDataSource:self];
    [self.foodTypeTableView setBounces:YES];
    [self.foodTypeTableView setShowsVerticalScrollIndicator:NO];
    [self.foodTypeTableView setTag:FoodTypeTable];
    [self.foodTypeTableView setBackgroundColor:FOOD_TYPE_TABLEVIEW_BACKGROUND_COLOR];
    [self.foodTypeTableView setTableFooterView:[[UIView alloc] init]];
    [self.foodTypeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.foodTypeTableView];
    
    self.foodInfoListTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.foodTypeTableView.frame.origin.x+self.foodTypeTableView.frame.size.width, self.foodTypeTableView.frame.origin.y, SIZE_DEVICE_WIDTH-self.foodTypeTableView.frame.size.width, SIZE_DEVICE_HEIGHT-44-20-_shoppingCarView.frame.size.height)];
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
    [_shoppingCarView setHidden:YES];
    [_foodTypeTableView setHidden:YES];
    [_foodInfoListTableView setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self getGoodsData];
//        
//    });
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([_shoppingCarView isHidden]) {
        [self getGoodsData];
    }else{
        [_shoppingCarView updateShoppingCar];
        [_foodInfoListTableView reloadData];
    }
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
            
        case FoodInfoListTable:
            
            if (_allGoodsData) {
                
                NSNumber *foodType = _foodTypeList[section];
                
                switch (foodType.intValue) {
                    case FoodTypeSPecial:
                        if (_allGoodsData.specialList && [_allGoodsData.specialList isKindOfClass:[NSArray class]])
                        {
                            count = [_allGoodsData.specialList count];
                        }
                        break;
                    case FoodTypeHeathy:
                        if (_allGoodsData.healthyList && [_allGoodsData.healthyList isKindOfClass:[NSArray class]])
                        {
                            count = [_allGoodsData.healthyList count];
                        }
                        break;
                    case FoodTypeSoup:
                        if (_allGoodsData.soupList && [_allGoodsData.soupList isKindOfClass:[NSArray class]])
                        {
                            count = [_allGoodsData.soupList count];
                        }
                        break;
                    case FoodTypePackage:
                        if (_allGoodsData.menuPackeList && [_allGoodsData.menuPackeList isKindOfClass:[NSArray class]])
                        {
                            count = [_allGoodsData.menuPackeList count];
                        }
                        break;
                    default:
                        break;
                }
            }
            
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
    [titleLabel setFont:[UIFont boldSystemFontOfSize:FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_FONT_SIZE]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    if (_foodTypeList&&[_foodTypeList count]>0&&[_foodTypeList count]>section) {
        NSNumber *foodType = _foodTypeList[section];
        NSString *typeName = @"";
        switch (foodType.intValue) {
            case FoodTypeSPecial:
                typeName = @"优惠特价";
                break;
            case FoodTypeHeathy:
                typeName = @"健康餐";
                break;
            case FoodTypeSoup:
                typeName = @"养生炖汤";
                break;
            case FoodTypePackage:
                typeName = @"营养套餐";
                break;
            default:
                break;
        }
        [titleLabel setText:typeName];
    }
    
    [titleBackgroundView addSubview:titleLabel];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
                    
                    NSNumber *foodType = _foodTypeList[indexPath.row];
                    NSString *typeName = @"";
                    switch (foodType.intValue) {
                        case FoodTypeSPecial:
                            typeName = @"优惠特价";
                            break;
                        case FoodTypeHeathy:
                            typeName = @"健康餐";
                            break;
                        case FoodTypeSoup:
                            typeName = @"养生炖汤";
                            break;
                        case FoodTypePackage:
                            typeName = @"营养套餐";
                            break;
                        default:
                            break;
                    }
                    [cell setFoodTypeName:typeName];
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
                    
                    NSNumber *foodType = _foodTypeList[indexPath.section];
                    switch (foodType.intValue) {
                        case FoodTypeSPecial:
                            if (_allGoodsData.specialList&&[_allGoodsData.specialList isKindOfClass:[NSArray class]]&&[_allGoodsData.specialList count]>indexPath.row)
                            {
                                tempArray = _allGoodsData.specialList;
                            }
                            
                            break;
                        case FoodTypeHeathy:
                            if (_allGoodsData.healthyList&&[_allGoodsData.healthyList isKindOfClass:[NSArray class]]&&[_allGoodsData.healthyList count]>indexPath.row)
                            {
                                tempArray = _allGoodsData.healthyList;
                            }
                            break;
                        case FoodTypeSoup:
                            if (_allGoodsData.soupList&&[_allGoodsData.soupList isKindOfClass:[NSArray class]]&&[_allGoodsData.soupList count]>indexPath.row)
                            {
                                tempArray = _allGoodsData.soupList;
                            }
                            
                            break;
                        case FoodTypePackage:
                            if (_allGoodsData.menuPackeList&&[_allGoodsData.menuPackeList isKindOfClass:[NSArray class]]&&[_allGoodsData.menuPackeList count]>indexPath.row)
                            {
                                tempArray = _allGoodsData.menuPackeList;
                            }
                            break;
                        default:
                            break;
                    }
                }
                
                if (tempArray){
                    [cell updateFoodData:tempArray[indexPath.row] withIndex:indexPath.row];
                }

                NSArray *selectedArray = [QSPShoppingCarData getShoppingCarDataList];
                if (selectedArray&&[selectedArray count]>0) {
                    for (int i=0; i<[selectedArray count]; i++) {
                        NSDictionary *item = selectedArray[i];
                        NSString *counStr = [item objectForKey:@"num"];
                        QSGoodsDataModel *goodData = [cell getFoodData];
                        NSString *foodID = [item objectForKey:@"goods_id"];
                        if (foodID&&[foodID isKindOfClass:[NSString class]]&&goodData&&[goodData isKindOfClass:[QSGoodsDataModel class]]) {
                            
                            if ([foodID isEqualToString:((QSGoodsDataModel*)goodData).goodsID]) {
                                
                                [cell setSlelectedCount:[counStr integerValue]];
                                
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
//                NSArray *tempArray = nil;
//                
//                if (_allGoodsData) {
//                    
//                    switch (indexPath.section) {
//                        case 0:
//                            if (_allGoodsData.soupList&&[_allGoodsData.soupList isKindOfClass:[NSArray class]]&&[_allGoodsData.soupList count]>indexPath.row)
//                            {
//                                tempArray = _allGoodsData.soupList;
//                            }
//                            break;
//                        case 1:
//                            if (_allGoodsData.healthyList&&[_allGoodsData.healthyList isKindOfClass:[NSArray class]]&&[_allGoodsData.healthyList count]>indexPath.row)
//                            {
//                                tempArray = _allGoodsData.healthyList;
//                            }
//                            break;
//                        case 2:
//                            if (_allGoodsData.soupList&&[_allGoodsData.soupList isKindOfClass:[NSArray class]]&&[_allGoodsData.soupList count]>indexPath.row)
//                            {
//                                tempArray = _allGoodsData.soupList;
//                            }
//                            break;
//                        case 3:
//                            if (_allGoodsData.menuPackeList&&[_allGoodsData.menuPackeList isKindOfClass:[NSArray class]]&&[_allGoodsData.menuPackeList count]>indexPath.row)
//                            {
//                                tempArray = _allGoodsData.menuPackeList;
//                            }
//                            break;
//                        default:
//                            break;
//                    }
//                    
//                }
//                
//                if (tempArray){
//                    QSGoodsDataModel *itemData = tempArray[indexPath.row];
//                    if (itemData&&[itemData isKindOfClass:[QSGoodsDataModel class]]) {
//                        if ([itemData.goodsTypeID integerValue] == 1 || [itemData.goodsTypeID integerValue] == 5) {
//                            
//                            QSPShakeFoodView *shakeFoodView = [QSPShakeFoodView getShakeFoodView];
//                            [shakeFoodView setDelegate:self];
//                            [self.tabBarController.view addSubview:shakeFoodView];
//                            [shakeFoodView updateFoodData:itemData];
//                            [shakeFoodView showShakeFoodView];
//                            
//                        }
//                    }
//                }
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
                
                [self.foodTypeTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentSectionIdx inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            }

        }
        
    }
    
}

- (void)changedCount:(NSInteger)count withFoodData:(id)foodData
{
    
    NSLog(@"changedCount:%ld withFoodData:%@",(long)count,foodData);
    
    if (foodData && [foodData isKindOfClass:[QSGoodsDataModel class]]) {
        
        NSMutableDictionary *foodDic = [NSMutableDictionary dictionaryWithCapacity:0];
        QSGoodsDataModel *food = (QSGoodsDataModel*)foodData;
        
        if ([food.goodsTypeID integerValue]==5) {
            //是套餐时
            
            QSPFoodPackageView *packageView = [QSPFoodPackageView getPackageView];
            [self.navigationController.view addSubview:packageView];
            [packageView updateFoodData:food];
            [packageView setDelegate:self];
            [packageView showPackageView];

            return;
        }
        
        [foodDic setObject:food.goodsID forKey:@"goods_id"];
        [foodDic setObject:[food getOnsalePrice] forKey:@"sale_money"];
        [foodDic setObject:food.goodsName forKey:@"name"];
        [foodDic setObject:food.shopkeeperID forKey:@"sale_id"];
        [foodDic setObject:[NSArray array] forKey:@"diet"];
        [foodDic setObject:food.goodsInstockNum forKey:@"num_instock"];
        
        if (_shoppingCarView) {
            NSInteger numInstock = food.goodsInstockNum.integerValue;
            if (count>numInstock) {
                count = numInstock;
            }
            [_shoppingCarView changeGoods:foodDic withCount:count];
        }
    }
    
}

- (void)orderWithData:(id)foodData
{
    
    NSLog(@"orderWithData:%@",foodData);

    int isLogin = [[[NSUserDefaults standardUserDefaults] valueForKey:@"is_login"] intValue];
    if (isLogin != 1 ) {
        QSWLoginViewController *loginVC = [[QSWLoginViewController alloc] init];
        loginVC.loginSuccessCallBack = ^(BOOL flag){
            if (flag) {
                
            }
        };
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }else{
        QSPOrderViewController *orderVc = [[QSPOrderViewController alloc] init];
        [self.navigationController pushViewController:orderVc animated:YES];
    }
}

- (void)getGoodsData
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_shoppingCarView setHidden:YES];
    [_foodTypeTableView setHidden:YES];
    [_foodInfoListTableView setHidden:YES];
    
    [QSRequestManager requestDataWithType:rRequestTypeAllGoods andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        
        ///判断是否请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///模型转换 
            QSGoodsStapleFoodReturnData *tempModel = resultData;
            
            self.allGoodsData = tempModel.headerMSG;
            
            [self.foodTypeList removeAllObjects];
            
            if (self.allGoodsData)
            {
                
                if (_allGoodsData.specialList&&[_allGoodsData.specialList count]>0)
                {
                    [self.foodTypeList addObject:[NSNumber numberWithInt:FoodTypeSPecial]];
                }
                if (_allGoodsData.healthyList&&[_allGoodsData.healthyList count]>0)
                {
                    [self.foodTypeList addObject:[NSNumber numberWithInt:FoodTypeHeathy]];
                }
                if (_allGoodsData.soupList&&[_allGoodsData.soupList count]>0)
                {
                    [self.foodTypeList addObject:[NSNumber numberWithInt:FoodTypeSoup]];
                }
                if (_allGoodsData.menuPackeList&&[_allGoodsData.menuPackeList count]>0)
                {
                    [self.foodTypeList addObject:[NSNumber numberWithInt:FoodTypePackage]];
                }
            }
            
            //最后一组添加空数据
            if ([_allGoodsData.menuPackeList count]>0)
            {
                _allGoodsData.menuPackeList = [self addNullDataInTheList:_allGoodsData.menuPackeList];
            }else if ([_allGoodsData.soupList count]>0)
            {
                _allGoodsData.soupList = [self addNullDataInTheList:_allGoodsData.soupList];
            }else if ([_allGoodsData.healthyList count]>0)
            {
                _allGoodsData.healthyList = [self addNullDataInTheList:_allGoodsData.healthyList];
            }else if ([_allGoodsData.specialList count]>0)
            {
                _allGoodsData.specialList = [self addNullDataInTheList:_allGoodsData.specialList];
            }
            
            [self.foodTypeTableView reloadData];
            if ([[self.foodTypeTableView visibleCells] count]>0) {
                [self.foodTypeTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            }
            
            [self.foodInfoListTableView reloadData];
            [_shoppingCarView setHidden:NO];
            [_foodTypeTableView setHidden:NO];
            [_foodInfoListTableView setHidden:NO];
            
        } else {
            
            NSLog(@"================所有菜品数据请求失败================");
            NSLog(@"error : %@",errorInfo);
            
//            QSNoNetworkingViewController *networkingErrorVC=[[QSNoNetworkingViewController alloc] init];
//            networkingErrorVC.hidesBottomBarWhenPushed = YES;
//            networkingErrorVC.navigationController.hidesBottomBarWhenPushed = NO;
//            [self.navigationController pushViewController:networkingErrorVC animated:YES];
            ///弹出提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取菜品数据失败，请稍后再试……！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            
            ///显示1秒后移除提示
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                
            });
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

/**
 *  补全空数据以填充全屏
 *
 *  @param beAddedArray 被操作数组
 *
 *  @return 添加空数据后的数组
 */
- (NSArray*)addNullDataInTheList:(NSArray*)beAddedArray
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:beAddedArray];
    if (beAddedArray&&[beAddedArray isKindOfClass:[NSArray class]]) {
        NSInteger itemCountPerScreen = SIZE_DEVICE_HEIGHT/FOOD_INFOLIST_TABLEVIEW_CELL_HEIGHT-1;
        if ([beAddedArray count]<itemCountPerScreen) {
            for (int i=0; i<(itemCountPerScreen-[beAddedArray count]); i++) {
                QSGoodsDataModel *nullData = [[QSGoodsDataModel alloc] init];
                [tempArray addObject:nullData];
            }
        }
    }
    return tempArray;
}

- (void)submitPackageWithData:(id)data
{
    
    NSLog(@"submitWithData :%@",data);
    if (data&&[data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary*)data;
        
        if (_shoppingCarView) {
            [_shoppingCarView changeGoods:dic withCount:1];
        }
        
    }
}

#pragma mark - QSPShakeFoodViewDelegate 菜品详情弹出View改变菜品数量响应处理
///QSPShakeFoodViewDelegate 菜品详情弹出View改变菜品数量响应处理
- (void)changedWithData:(id)foodData inView:(QSPShakeFoodView*)popFoodView
{
    [_foodInfoListTableView reloadData];
    [_shoppingCarView updateShoppingCar];
    [popFoodView setHidden:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [QSPShoppingCarData clearShoopingCar];
    }
    [self.tabBarController setSelectedIndex:0];
}

- (void)clickFoodImgIndex:(NSInteger)index withFoodData:(id)foodData
{
    if (foodData&&[foodData isKindOfClass:[QSGoodsDataModel class]]) {
        QSGoodsDataModel *itemData = (QSGoodsDataModel*)foodData;
        if ([itemData.goodsTypeID integerValue] == 1 || [itemData.goodsTypeID integerValue] == 5) {
            QSPShakeFoodView *detailFoodView = [QSPShakeFoodView getShakeFoodView];
            [detailFoodView setDelegate:self];
            [self.tabBarController.view addSubview:detailFoodView];
            [detailFoodView updateFoodData:itemData];
            [detailFoodView showShakeFoodView];
        }
    }
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
