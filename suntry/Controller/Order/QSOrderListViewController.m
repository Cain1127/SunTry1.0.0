//
//  QSOrderListViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderListViewController.h"
#import "QSBlockButton.h"
#import "ImageHeader.h"
#import "QSLabel.h"
#import "DeviceSizeHeader.h"
#import "QSOrderListTableViewCell.h"
#import "QSOrderDetailViewController.h"
#import "QSUserInfoDataModel.h"

#import "MJRefresh.h"

#define ORDER_LIST_VIEWCONTROLLER_NAV_TITLE_FONT_SIZE   17.
#define ORDER_LIST_VIEWCONTROLLER_CONTENT_COLOR         [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]
#define ORDER_LIST_VIEWCONTROLLER_CONTENT_FONT_SIZE     17.

@interface QSOrderListViewController ()

@property (nonatomic, strong) UIView *nodataView;                   //!<暂无记录view
@property(nonatomic,strong) UITableView     *orderListTableView;    //!<订单列表
@property(nonatomic,strong) NSMutableArray  *orderList;             //!<订单列表数据源

@end

@implementation QSOrderListViewController

#pragma mark - UI搭建
- (void)loadView{
    
    [super loadView];
    
    self.orderList = [NSMutableArray arrayWithCapacity:0];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:ORDER_LIST_VIEWCONTROLLER_NAV_TITLE_FONT_SIZE]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"外卖订单"];
    self.navigationItem.titleView = navTitle;
    
    //没有数据时的显示
    self.nodataView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_nodataView];
    
    UIImageView *nodataImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_list_no_data_logo"]];
    [nodataImgView setCenter:self.view.center];
    [nodataImgView setFrame:CGRectMake(nodataImgView.frame.origin.x, 110/667.*SIZE_DEVICE_HEIGHT, nodataImgView.frame.size.width, nodataImgView.frame.size.height)];
    [_nodataView addSubview:nodataImgView];
    
    QSLabel *infoLabel = [[QSLabel alloc] initWithFrame:CGRectMake(20, nodataImgView.frame.origin.y+nodataImgView.frame.size.height+5, SIZE_DEVICE_WIDTH-40, 50)];
    [infoLabel setFont:[UIFont boldSystemFontOfSize:ORDER_LIST_VIEWCONTROLLER_CONTENT_FONT_SIZE]];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [infoLabel setNumberOfLines:2];
    [infoLabel setTextAlignment:NSTextAlignmentCenter];
    [infoLabel setText:@"您现在还没有订单，马上点一份"];
    [infoLabel setTextColor:ORDER_LIST_VIEWCONTROLLER_CONTENT_COLOR];
    [_nodataView addSubview:infoLabel];
    
    QSBlockButtonStyleModel *submitBtStyleModel = [QSBlockButtonStyleModel alloc];
    submitBtStyleModel.bgColor  = [UIColor colorWithRed:0.471 green:0.176 blue:0.224 alpha:1.000];;
    submitBtStyleModel.title    = @"赶紧点一份";
    submitBtStyleModel.titleNormalColor = [UIColor whiteColor];
    submitBtStyleModel.cornerRadio = 6.;
    UIButton *submitBt = [UIButton createBlockButtonWithFrame:CGRectMake((SIZE_DEVICE_WIDTH-245./375.*SIZE_DEVICE_WIDTH)/2, infoLabel.frame.origin.y+infoLabel.frame.size.height+5, 245./375.*SIZE_DEVICE_WIDTH, 44) andButtonStyle:submitBtStyleModel andCallBack:^(UIButton *button) {
        
        [self.tabBarController setSelectedIndex:1];
        
    }];
    [_nodataView addSubview:submitBt];
    
    //有数据显示
    [_nodataView setHidden:YES];
    self.orderListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 24, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-44-20-24)];
    [self.orderListTableView setDelegate:self];
    [self.orderListTableView setDataSource:self];
    [self.orderListTableView setShowsVerticalScrollIndicator:NO];
    [self.orderListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.orderListTableView];
    
    ///添加刷新事件
    [self.orderListTableView addHeaderWithTarget:self action:@selector(getUserOrderHeaderList)];
    [self.orderListTableView addFooterWithTarget:self action:@selector(getUserOrderFooterList)];
    
    ///一开始就进行网络请求
    [self.orderListTableView headerBeginRefreshing];
    
}

#pragma mark - 返回当前有多少个订单
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger count = 0;
    count = [self.orderList count];
    return count;
    
}

#pragma mark - 返回每一项cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = ORDER_LIST_CELL_HEIGHT;
    return height;
    
}

#pragma mark - 返回每一个订单的信息cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *foodTypeTableViewIdentifier = @"FoodTypeTableCell";
    QSOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:foodTypeTableViewIdentifier];
    
    if (cell == nil) {
        
        cell = [[QSOrderListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:foodTypeTableViewIdentifier];
        
    }
    if (indexPath.row==0) {
        
        [cell showTopLine:YES];
        
    } else {
        
        [cell showTopLine:NO];
        
    }
    [cell updateFoodData:nil];
    
    return cell;
    
}

#pragma mark - 点击某一个订单后进入订单详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id data = [_orderList objectAtIndex:indexPath.row];
    QSOrderDetailViewController *odvc = [[QSOrderDetailViewController alloc] init];
    [odvc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:odvc animated:YES];
    
}

- (void)getUserOrderHeaderList
{
    //请求所需参数
    NSMutableDictionary *tempParams = [[NSMutableDictionary alloc] init];
    /*  user_id 用户id 必填
        search_key 查找的关键字
        page_num 每页的数量 默认 10 
        now_page 当前第几页 默认 1 
        status 状态，对应的何种类型的订单
    */
    
    //用户信息模型
    QSUserInfoDataModel *userModel = [QSUserInfoDataModel userDataModel];
    //user_id 用户id 必填
    [tempParams setObject:userModel.userID forKey:@"user_id"];
    
}

- (void)getUserOrderFooterList
{

    

}

@end
