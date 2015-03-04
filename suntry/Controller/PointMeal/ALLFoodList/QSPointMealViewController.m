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
#import "QSAllGoodsReturnData.h"

#define FOOD_TYPE_TABLEVIEW_BACKGROUND_COLOR  [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.]
#define FOOD_INFOLIST_TABLEVIEW_BACKGROUND_COLOR  [UIColor whiteColor]

#define FOOD_TYPE_TABLEVIEW_CELL_HEIGHT                     50.
#define FOOD_INFOLIST_TABLEVIEW_CELL_HEIGHT                 80.
#define FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_HEIGHT          40.
#define FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_HEIGHT    24.
#define FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_COLOR     FOOD_TYPE_TABLEVIEW_BACKGROUND_COLOR
#define FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_FONT_SIZE 19.
#define FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_SUB_TITLE_FONT_SIZE 17.

enum TableViewType{
    
    FoodTypeTable = 1,
    FoodInfoListTable
    
};

typedef enum {
    
    FoodTypeSPecial     = 0,
    FoodTypeHeathy      = 1,
    FoodTypeSoup        = 2,
    FoodTypePackage     = 3
    
} FoodType;

@interface QSPointMealViewController () <QSPShakeFoodViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) UITableView     *foodTypeTableView;
@property(nonatomic,strong) NSMutableArray  *foodTypeList;              //<! 当前有数据类型数组
@property(nonatomic,strong) NSMutableArray  *foodTypeIndexList;         //<! 当前有数据索引数组
@property(nonatomic,strong) NSMutableArray  *foodListHeadTitleList;     //<! 菜品列表标题数组
@property(nonatomic,strong) NSMutableArray  *allFoodDataList;           //<! 所有菜品数据

@property(nonatomic,strong) UITableView     *foodInfoListTableView;
@property(nonatomic,strong) QSPShoppingCarView *shoppingCarView;
@property(nonatomic,strong) QSGoodsStapleFoodHeaderData *allGoodsData;

@end

@implementation QSPointMealViewController

#pragma mark - 进入视图时加载UI
///进入视图时加载UI
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
    
    self.foodTypeList = [NSMutableArray array];
    self.foodTypeIndexList = [NSMutableArray array];
    self.foodListHeadTitleList = [NSMutableArray array];
    self.allFoodDataList = [NSMutableArray arrayWithCapacity:0];
    
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

#pragma mark - 视图已经显示时获取数据
///视图已经显示时获取数据
- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    if ([_shoppingCarView isHidden]) {
        
        [self getAllGoodsData];
        
    }else{
        
        [_shoppingCarView updateShoppingCar];
        [_foodInfoListTableView reloadData];
        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    NSInteger count = 1;
    
    switch (tableView.tag){
            
        case FoodTypeTable:
            
            break;
            
        case FoodInfoListTable:
            
            if (self.allFoodDataList&&[self.allFoodDataList isKindOfClass:[NSArray class]]&&[self.allFoodDataList count]>0) {
                
                count = [self.allFoodDataList count];
                
            }
            
            break;
            
        default:
            
            break;
            
    }
    
    return count;
    
}

#pragma mark - 返回有多少美食列
///返回有多少美食列
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
            
            if (self.allFoodDataList&&[self.allFoodDataList isKindOfClass:[NSArray class]]&&[self.allFoodDataList count]>0) {
                
                NSArray *subArray = [self.allFoodDataList objectAtIndex:section];
                if (subArray&&[subArray isKindOfClass:[NSArray class]]&&[subArray count] > 0.0f) {
                    
                    count = [subArray count];
                    
                }
                
            }
            
            break;
            
        default:
            
            break;
            
    }
    
    return count;
    
}

#pragma mark - 返回不同的美食信息cell高度
///返回不同的美食信息cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    CGFloat height = 0;
    
    switch (tableView.tag){
            
        case FoodTypeTable:
            
            break;
            
        case FoodInfoListTable:
            
            height = FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_HEIGHT + 10.0f;
            
            if (self.foodListHeadTitleList && [self.foodListHeadTitleList isKindOfClass:[NSArray class]] && [self.foodListHeadTitleList count] > section)
            {
                
                NSDictionary *headDic = [self.foodListHeadTitleList objectAtIndex:section];
                if (headDic && [headDic isKindOfClass:[NSDictionary class]]) {
                    NSString *topTitle = [headDic objectForKey:@"topTitle"];
                    NSString *subTitle = [headDic objectForKey:@"subTitle"];
                    if (subTitle && ![subTitle isEqualToString:@""]) {
                        
                        if (section == 0) {
                            
                            height = FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_HEIGHT * 2.0f;
                            
                        } else {
                            
                            NSString *lastTopTitle = [[self.foodListHeadTitleList objectAtIndex:section - 1] objectForKey:@"topTitle"];
                            if (![lastTopTitle isEqualToString:topTitle]) {
                                
                                height = FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_HEIGHT * 2.0f + 8.0f;
                                
                            }
                            
                        }
                    }
                }
            }
            
            break;
            
        default:
            
            break;
            
    }
    
    return height;
    
}

#pragma mark - 返回餐单标题栏的高度
///返回餐单标题栏的高度
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

#pragma mark - 返回餐单头信息view
///返回餐单头信息view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_HEIGHT)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    UIView *titleBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_HEIGHT-FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_HEIGHT, tableView.frame.size.width - 10.0f * 2.0f, FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_HEIGHT)];
    [titleBackgroundView setBackgroundColor:FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_COLOR];
    [headerView addSubview:titleBackgroundView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, titleBackgroundView.frame.size.width, titleBackgroundView.frame.size.height)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_FONT_SIZE]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleBackgroundView addSubview:titleLabel];
    
    if (self.foodListHeadTitleList&&[self.foodListHeadTitleList isKindOfClass:[NSArray class]]&&[self.foodListHeadTitleList count]>section)
    {
        
        NSDictionary *headDic = [self.foodListHeadTitleList objectAtIndex:section];
        if (headDic&&[headDic isKindOfClass:[NSDictionary class]]) {
            
            NSString *topTitle = [headDic objectForKey:@"topTitle"];
            NSString *subTitle = [headDic objectForKey:@"subTitle"];
            
            if (subTitle&&![subTitle isEqualToString:@""]) {
                
                if (section == 0) {
                    
                    [titleBackgroundView setFrame:CGRectMake(10.0f, 0.0f, tableView.frame.size.width - 10.0f * 2.0f, 30.0f)];
                    [titleLabel setFont:[UIFont boldSystemFontOfSize:FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_FONT_SIZE]];
                    [titleLabel setTextAlignment:NSTextAlignmentLeft];
                    [titleLabel setText:topTitle];
                    
                    UIView *subTitleBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, titleBackgroundView.frame.origin.y+titleBackgroundView.frame.size.height + 4.0f, titleBackgroundView.frame.size.width, FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_HEIGHT + 10.0f)];
                    
                    ///修改背景颜色
                    [subTitleBackgroundView setBackgroundColor:FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_COLOR];
                    [headerView addSubview:subTitleBackgroundView];
                    //
                    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5.0f, titleLabel.frame.size.width, FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_HEIGHT)];
                    [subTitleLabel setFont:[UIFont boldSystemFontOfSize:FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_SUB_TITLE_FONT_SIZE]];
                    [subTitleLabel setBackgroundColor:[UIColor clearColor]];
                    [subTitleBackgroundView addSubview:subTitleLabel];
                    [subTitleLabel setText:subTitle];
                    [subTitleLabel setTextAlignment:NSTextAlignmentLeft];
                    [headerView setFrame:CGRectMake(headerView.frame.origin.x,headerView.frame.origin.y, subTitleBackgroundView.frame.size.width, subTitleBackgroundView.frame.origin.y+subTitleBackgroundView.frame.size.height)];
                    
                } else {
                    
                    NSString *lastTopTitle = [[self.foodListHeadTitleList objectAtIndex:section - 1] objectForKey:@"topTitle"];
                    if (![lastTopTitle isEqualToString:topTitle]) {
                        
                        [titleBackgroundView setFrame:CGRectMake(10.0f, 15.0f, tableView.frame.size.width - 10.0f * 2.0f, 30.0f)];
                        titleBackgroundView.backgroundColor = [UIColor whiteColor];
                        [titleLabel setFont:[UIFont boldSystemFontOfSize:FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_FONT_SIZE]];
                        [titleLabel setTextAlignment:NSTextAlignmentLeft];
                        [titleLabel setText:topTitle];
                    
                        UIView *subTitleBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, titleBackgroundView.frame.origin.y + titleBackgroundView.frame.size.height + 9.0f, titleBackgroundView.frame.size.width, FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_HEIGHT + 10.0f)];
                        
                        ///背景颜色
                        [subTitleBackgroundView setBackgroundColor:FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_COLOR];
                        [headerView addSubview:subTitleBackgroundView];
                        //
                        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 5.0f, titleLabel.frame.size.width, FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_HEIGHT)];
                        [subTitleLabel setFont:[UIFont boldSystemFontOfSize:FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_SUB_TITLE_FONT_SIZE]];
                        [subTitleLabel setBackgroundColor:[UIColor clearColor]];
                        [subTitleBackgroundView addSubview:subTitleLabel];
                        [subTitleLabel setText:subTitle];
                        [subTitleLabel setTextAlignment:NSTextAlignmentLeft];
                        [headerView setFrame:CGRectMake(headerView.frame.origin.x,headerView.frame.origin.y, subTitleBackgroundView.frame.size.width, subTitleBackgroundView.frame.origin.y+subTitleBackgroundView.frame.size.height)];
                        
                    } else {
                        
                        [titleBackgroundView setFrame:CGRectMake(10.0f, FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_HEIGHT-FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_HEIGHT, tableView.frame.size.width - 10.0f * 2.0f, FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_HEIGHT + 10.0f)];
                        [titleLabel setFont:[UIFont boldSystemFontOfSize:FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_SUB_TITLE_FONT_SIZE]];
                        [titleLabel setText:subTitle];
                        titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, 5.0f, titleLabel.frame.size.width, titleLabel.frame.size.height);
                        [titleLabel setTextAlignment:NSTextAlignmentLeft];
                        
                    }
                    
                }
                
            } else {
                
                [titleBackgroundView setFrame:CGRectMake(10.0f, 15.0f, tableView.frame.size.width - 10.0f * 2.0f, 30.0f)];
                titleBackgroundView.backgroundColor = [UIColor whiteColor];
                [titleLabel setFont:[UIFont boldSystemFontOfSize:FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_TITLE_FONT_SIZE]];
                [titleLabel setTextAlignment:NSTextAlignmentLeft];
                [titleLabel setText:topTitle];
                
            }
            
        }
        
    }
    
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
                
//                NSArray *tempArray = nil;
//                
//                if (_allGoodsData) {
//                    
//                    NSNumber *foodType = _foodTypeList[indexPath.section];
//                    switch (foodType.intValue) {
//                        case FoodTypeSPecial:
//                            if (_allGoodsData.specialList&&[_allGoodsData.specialList isKindOfClass:[NSArray class]]&&[_allGoodsData.specialList count]>indexPath.row)
//                            {
//                                tempArray = _allGoodsData.specialList;
//                            }
//                            
//                            break;
//                        case FoodTypeHeathy:
//                            if (_allGoodsData.healthyList&&[_allGoodsData.healthyList isKindOfClass:[NSArray class]]&&[_allGoodsData.healthyList count]>indexPath.row)
//                            {
//                                tempArray = _allGoodsData.healthyList;
//                            }
//                            break;
//                        case FoodTypeSoup:
//                            if (_allGoodsData.soupList&&[_allGoodsData.soupList isKindOfClass:[NSArray class]]&&[_allGoodsData.soupList count]>indexPath.row)
//                            {
//                                tempArray = _allGoodsData.soupList;
//                            }
//                            
//                            break;
//                        case FoodTypePackage:
//                            if (_allGoodsData.menuPackeList&&[_allGoodsData.menuPackeList isKindOfClass:[NSArray class]]&&[_allGoodsData.menuPackeList count]>indexPath.row)
//                            {
//                                tempArray = _allGoodsData.menuPackeList;
//                            }
//                            break;
//                        default:
//                            break;
//                    }
//                }
//                
//                if (tempArray){
//                    [cell updateFoodData:tempArray[indexPath.row] withIndex:indexPath.row];
//                }
                //////////////////////////////////////////
                
                if (_allFoodDataList) {
                    id subList = [_allFoodDataList objectAtIndex:indexPath.section];
                    if (subList&&[subList isKindOfClass:[NSArray class]]) {
                        id data = [(NSArray*)subList objectAtIndex:indexPath.row];
                        [cell updateFoodData:data withIndex:indexPath.row];
                    }
                }
                
                //////////////////////////////////////////
                
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
                if (self.foodTypeIndexList && [self.foodTypeIndexList isKindOfClass:[NSArray class]] && [self.foodTypeIndexList count] > indexPath.row) {
                    
                    NSInteger selectRow = [[self.foodTypeIndexList objectAtIndex:indexPath.row] integerValue];
                    if (selectRow < [self.foodInfoListTableView numberOfSections]) {
                        
                        [self.foodInfoListTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectRow] animated:YES scrollPosition:UITableViewScrollPositionTop];
                        
                    }
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
        
        CGFloat sectionHeaderHeight = FOOD_INFOLIST_TABLEVIEW_CELL_HEADER_HEIGHT*2;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            
        }
        
        NSInteger currentSectionIdx = 0;
        
        NSArray *visbleIndexPath = [self.foodInfoListTableView indexPathsForVisibleRows];
        
        if ([visbleIndexPath count]>1) {
            
            NSIndexPath *second = visbleIndexPath[0];
            
            if (second) {
                
                currentSectionIdx = second.section;
            
            }
            
            if (scrollView&&[scrollView isKindOfClass:[UITableView class]]) {
                
                if (self.foodTypeIndexList&&[self.foodTypeIndexList isKindOfClass:[NSArray class]]) {
                    
                    for (int i=0;i<[self.foodTypeIndexList count];i++) {
                        NSNumber *indexNumber = [self.foodTypeIndexList objectAtIndex:i];
                        if (currentSectionIdx <= indexNumber.integerValue) {
                            
                            [self.foodTypeTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                            break;
                        }
                    }
                }
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
        
    } else {
        
        QSPOrderViewController *orderVc = [[QSPOrderViewController alloc] init];
        [self.navigationController pushViewController:orderVc animated:YES];
        
    }
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

/**
 *  2015-03-03 新需求接口
 */
- (void)getAllGoodsData
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_shoppingCarView setHidden:YES];
    [_foodTypeTableView setHidden:YES];
    [_foodInfoListTableView setHidden:YES];
    
//    [QSRequestManager requestDataWithType:rRequestTypeAllGoodsData andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {   //测试接口
        [QSRequestManager requestDataWithType:rRequestTypeAllGoods andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
    
        
        ///判断是否请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///模型转换
            QSAllGoodsReturnData *tempModel = resultData;
            
            NSLog(@"tempModel %@",tempModel);
            
            [self.allFoodDataList removeAllObjects];
            [self.foodTypeList removeAllObjects];
            [self.foodTypeIndexList removeAllObjects];
            [self.foodListHeadTitleList removeAllObjects];
            
            NSMutableArray *specialList = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *healthyList = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *soupList = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *menuPackeList = [NSMutableArray arrayWithCapacity:0];
            
            NSMutableArray *specialHeadList = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *healthyHeadList = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *soupHeadList = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *menuPackeHeadList = [NSMutableArray arrayWithCapacity:0];
            
            if (tempModel.allGoodsList && [tempModel.allGoodsList isKindOfClass:[NSArray class]] && [tempModel.allGoodsList count]>0)
            {
                
                for (int i=0; i<[tempModel.allGoodsList count]; i++)
                {
                    id item = [tempModel.allGoodsList objectAtIndex:i];
                    if (item && [item isKindOfClass:[QSAllGoodsDataModel class]])
                    {
                        QSAllGoodsDataModel *foodItem = (QSAllGoodsDataModel*)item;
                        NSString *topTypeName = foodItem.typeName;
                        
                        if (foodItem.goodsList && [foodItem.goodsList isKindOfClass:[NSArray class]] && [foodItem.goodsList count]>0)
                        {
                            
                            NSMutableDictionary *headDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:topTypeName,@"topTitle", nil];
                            
                            //一级数据
                            if ([topTypeName isEqualToString:@"优惠特价"]) {
                                [specialList addObject:foodItem.goodsList];
                                [specialHeadList addObject:headDic];
                            }else if ([topTypeName isEqualToString:@"健康餐"]) {
                                [healthyList addObject:foodItem.goodsList];
                                [healthyHeadList addObject:headDic];
                            }else if ([topTypeName isEqualToString:@"养生炖汤"]) {
                                [soupList addObject:foodItem.goodsList];
                                [soupHeadList addObject:headDic];
                            }else if ([topTypeName isEqualToString:@"营养套餐"]) {
                                [menuPackeList addObject:foodItem.goodsList];
                                [menuPackeHeadList addObject:headDic];
                            }
                            
                        }else if (foodItem.subGoodsList && [foodItem.subGoodsList isKindOfClass:[NSArray class]] && [foodItem.subGoodsList count]>0)
                        {
                            for (int j=0; j<[foodItem.subGoodsList count]; j++)
                            {
                                id subItem = [foodItem.subGoodsList objectAtIndex:j];
                                if (subItem && [subItem isKindOfClass:[QSAllGoodsSubDataModel class]])
                                {
                                    QSAllGoodsSubDataModel *subFoodItem = (QSAllGoodsSubDataModel*)subItem;
                                    NSString *subTypeName = subFoodItem.typeName;
                                    if (subFoodItem.goodsList&&[subFoodItem.goodsList isKindOfClass:[NSArray class]]&&[subFoodItem.goodsList count]>0)
                                    {
                                        NSMutableDictionary *subHeadDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:topTypeName,@"topTitle", subTypeName,@"subTitle",nil];
                                        //二级列表数据
                                        if ([topTypeName isEqualToString:@"优惠特价"]) {
                                            [specialList addObject:subFoodItem.goodsList];
                                            [specialHeadList addObject:subHeadDic];
                                        }else if ([topTypeName isEqualToString:@"健康餐"]) {
                                            [healthyList addObject:subFoodItem.goodsList];
                                            [healthyHeadList addObject:subHeadDic];
                                        }else if ([topTypeName isEqualToString:@"养生炖汤"]) {
                                            [soupList addObject:subFoodItem.goodsList];
                                            [soupHeadList addObject:subHeadDic];
                                        }else if ([topTypeName isEqualToString:@"营养套餐"]) {
                                            [menuPackeList addObject:subFoodItem.goodsList];
                                            [menuPackeHeadList addObject:subHeadDic];
                                        }
                                    }else if (subFoodItem.subGoodsList&&[subFoodItem.subGoodsList isKindOfClass:[NSArray class]]&&[subFoodItem.subGoodsList count]>0) {
                                        //三级…………
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            NSInteger arrayIndex = 0;
            [self.foodTypeIndexList addObject:[NSNumber numberWithInteger:arrayIndex]];
            if ([specialList count]>0)
            {
                [self.foodTypeList addObject:[NSNumber numberWithInt:FoodTypeSPecial]];
                arrayIndex += [specialList count];
                [self.foodTypeIndexList addObject:[NSNumber numberWithInteger:arrayIndex]];
            }
            if ([healthyList count]>0)
            {
                [self.foodTypeList addObject:[NSNumber numberWithInt:FoodTypeHeathy]];
                arrayIndex += [healthyList count];
                [self.foodTypeIndexList addObject:[NSNumber numberWithInteger:arrayIndex]];
            }
            if ([soupList count]>0)
            {
                [self.foodTypeList addObject:[NSNumber numberWithInt:FoodTypeSoup]];
                arrayIndex += [soupList count];
                [self.foodTypeIndexList addObject:[NSNumber numberWithInteger:arrayIndex]];
            }
            if ([menuPackeList count]>0)
            {
                [self.foodTypeList addObject:[NSNumber numberWithInt:FoodTypePackage]];

            }

            
            //最后一组添加空数据
            if ([menuPackeList count]>0)
            {
                NSMutableArray *tempList = [NSMutableArray arrayWithArray:menuPackeList];
                NSArray *lastArray = [NSMutableArray arrayWithArray:[self addNullDataInTheList:tempList.lastObject]];
                [tempList removeLastObject];
                [tempList addObject:lastArray];
                menuPackeList = tempList;
                                       
            }else if ([soupList count]>0)
            {
//                soupList.lastObject  = [NSMutableArray arrayWithArray:[self addNullDataInTheList:soupList.lastObject]];
                NSMutableArray *tempList = [NSMutableArray arrayWithArray:soupList];
                
                NSArray *lastArray = [NSMutableArray arrayWithArray:[self addNullDataInTheList:tempList.lastObject]];
                [tempList removeLastObject];
                [tempList addObject:lastArray];
                soupList = tempList;
                                       
            }else if ([healthyList count]>0)
            {
//                healthyList.lastObject  = [NSMutableArray arrayWithArray:[self addNullDataInTheList:healthyList.lastObject]];
                NSMutableArray *tempList = [NSMutableArray arrayWithArray:healthyList];
                
                NSArray *lastArray = [NSMutableArray arrayWithArray:[self addNullDataInTheList:tempList.lastObject]];
                [tempList removeLastObject];
                [tempList addObject:lastArray];
                healthyList = tempList;
                
            }else if ([specialList count]>0)
            {
//                specialList.lastObject  = [NSMutableArray arrayWithArray:[self addNullDataInTheList:specialList.lastObject]];
                NSMutableArray *tempList = [NSMutableArray arrayWithArray:healthyList];
                
                NSArray *lastArray = [NSMutableArray arrayWithArray:[self addNullDataInTheList:tempList.lastObject]];
                [tempList removeLastObject];
                [tempList addObject:lastArray];
                specialList = tempList;
                
            }
            
            //排序
            [self.allFoodDataList addObjectsFromArray:specialList];
            [self.allFoodDataList addObjectsFromArray:healthyList];
            [self.allFoodDataList addObjectsFromArray:soupList];
            [self.allFoodDataList addObjectsFromArray:menuPackeList];
            
            [self.foodListHeadTitleList addObjectsFromArray:specialHeadList];
            [self.foodListHeadTitleList addObjectsFromArray:healthyHeadList];
            [self.foodListHeadTitleList addObjectsFromArray:soupHeadList];
            [self.foodListHeadTitleList addObjectsFromArray:menuPackeHeadList];
            
            NSLog(@"allFoodDataList %ld :%@",(long)arrayIndex,self.allFoodDataList);

//            //最后一组添加空数据
//            if ([_allGoodsData.menuPackeList count]>0)
//            {
//                _allGoodsData.menuPackeList = [self addNullDataInTheList:_allGoodsData.menuPackeList];
//            }else if ([_allGoodsData.soupList count]>0)
//            {
//                _allGoodsData.soupList = [self addNullDataInTheList:_allGoodsData.soupList];
//            }else if ([_allGoodsData.healthyList count]>0)
//            {
//                _allGoodsData.healthyList = [self addNullDataInTheList:_allGoodsData.healthyList];
//            }else if ([_allGoodsData.specialList count]>0)
//            {
//                _allGoodsData.specialList = [self addNullDataInTheList:_allGoodsData.specialList];
//            }
//
//            [self.foodTypeTableView reloadData];
//            if ([[self.foodTypeTableView visibleCells] count]>0) {
//                [self.foodTypeTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
//            }
//
            [self.foodTypeTableView reloadData];
            [self.foodInfoListTableView reloadData];
            [_shoppingCarView setHidden:NO];
            [_foodTypeTableView setHidden:NO];
            [_foodInfoListTableView setHidden:NO];
            
            if ([[self.foodTypeTableView visibleCells] count]>0) {
                [self.foodTypeTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            }

            
        } else {
            
            NSLog(@"================所有菜品数据请求失败================");
            NSLog(@"error : %@",errorInfo);
            
            ///弹出提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取菜品数据失败，请稍后再试……！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            
            ///显示1秒后移除提示
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                
            });
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
