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
//#import "QSPOrderViewController.h"

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

@interface QSPointMealViewController ()

@property(nonatomic,strong) UITableView *foodTypeTableView;
@property(nonatomic,strong) NSArray     *foodTypeList;
@property(nonatomic,strong) UITableView *foodInfoListTableView;
@property(nonatomic,strong) NSArray     *foodInfoList;
@property(nonatomic,strong) QSPShoppingCarView *shoppingCarView;


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
    
    self.foodTypeList = [NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
    self.foodInfoList = [NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    
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
    
    [self.foodTypeTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];

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
            
            count = 5;
            
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
            
            count = [self.foodTypeList count];
            
            break;
            
        case FoodInfoListTable:
            
            count = [self.foodInfoList count];
            
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
    [titleLabel setText:@"优惠特价"];
    
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
                
                [cell setFoodTypeName:@"营养套餐"];
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
                
                [cell updateFoodData:[NSString stringWithFormat:@"番茄鸡扒%ld%ld",indexPath.section,indexPath.row]];
                [cell setSlelectedCount:0];
                NSArray *selectedArray = [_shoppingCarView getGoods];
                if (selectedArray&&[selectedArray count]>0) {
                    for (int i=0; i<[selectedArray count]; i++) {
                        NSDictionary *item = selectedArray[i];
                        NSNumber *counNum = [item objectForKey:@"count"];
                        if ([[cell getFoodData] isEqualToString:[item objectForKey:@"foodName"]]) {
                            [cell setSlelectedCount:[counNum integerValue]];
                            break;
                        }
                    }
                }
                
                return cell;
                
            }
            break;
            
        default:
            return nil;
            
    }
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
//                QSPFoodPackageView *packageView = [QSPFoodPackageView getPackageView];
//                [self.navigationController.view addSubview:packageView];
//                [packageView showPackageView];
                
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
        }
        
        [self.foodTypeTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentSectionIdx inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        
    }
    
}

- (void)changedCount:(NSInteger)count withFoodData:(id)foodData
{
    
    NSLog(@"changedCount:%ld withFoodData:%@",count,foodData);
    
    if (_shoppingCarView) {
        [_shoppingCarView changeGoods:foodData withCount:count];
    }
    
}

- (void)orderWithData:(id)foodData
{
    
    NSLog(@"orderWithData:%@",foodData);

    //QSPOrderViewController *orderVc = [[QSPOrderViewController alloc] init];
//    [orderVc setFoodSelectedList:[NSMutableArray arrayWithArray:foodData]];
//    [self.navigationController pushViewController:orderVc animated:YES];
    
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
