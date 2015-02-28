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
#import "QSRequestManager.h"
#import "MBProgressHUD.h"
#import "QSOrderListReturnData.h"

#define ORDER_LIST_VIEWCONTROLLER_NAV_TITLE_FONT_SIZE   17.
#define ORDER_LIST_VIEWCONTROLLER_CONTENT_COLOR         [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]
#define ORDER_LIST_VIEWCONTROLLER_CONTENT_FONT_SIZE     17.

@interface QSOrderListViewController ()

@property (nonatomic, strong) UIView *nodataView;
@property (nonatomic, strong) UITableView     *orderListTableView;
@property (nonatomic, strong) NSMutableArray  *orderList;
@property (nonatomic, assign) NSInteger pageNum;


@end

@implementation QSOrderListViewController


- (void)loadView{
    
    [super loadView];
    _pageNum = 1;
    self.orderList = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];//[NSMutableArray arrayWithCapacity:0];
    
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
    self.orderListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-44-20-49)];
    [self.orderListTableView setDelegate:self];
    [self.orderListTableView setDataSource:self];
    [self.orderListTableView setShowsVerticalScrollIndicator:NO];
    [self.orderListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.orderListTableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [_nodataView setHidden:YES];
    
    [self getMyOrderList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    count = [self.orderList count];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = ORDER_LIST_CELL_HEIGHT;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *foodTypeTableViewIdentifier = @"FoodTypeTableCell";
    QSOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:foodTypeTableViewIdentifier];
    
    if (cell == nil) {
        
        cell = [[QSOrderListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:foodTypeTableViewIdentifier];
        
    }
    if (indexPath.row==0) {
        [cell showTopLine:YES];
    }else{
        [cell showTopLine:NO];
    }
    
    [cell updateFoodData:[_orderList objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QSOrderDetailViewController *odvc = [[QSOrderDetailViewController alloc] init];
    id data = [_orderList objectAtIndex:indexPath.row];
    if (data && [data isKindOfClass:[QSOrderDetailDataModel class]]) {
        [odvc setOrderData:data];
    }
    [odvc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:odvc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getMyOrderList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //请求所需参数
    NSMutableDictionary *tempParams = [[NSMutableDictionary alloc] init];
    /*  user_id 用户id 必填
        search_key 查找的关键字
        page_num 每页的数量 默认 10 
        now_page 当前第几页 默认 1 
        order 传 t.add_time desc
        except 不读取到某些类型的,5是储蓄卡购买支付的类型，
        status 状态，对应的何种类型的订单
     
    */
    
    //用户信息模型
    QSUserInfoDataModel *userModel = [QSUserInfoDataModel userDataModel];
    //user_id 用户id 必填
    [tempParams setObject:userModel.userID forKey:@"user_id"];
    //search_key 查找的关键字
    [tempParams setObject:@"" forKey:@"search_key"];
    //page_num 每页的数量 默认 10
    [tempParams setObject:@"20" forKey:@"page_num"];
    //now_page 当前第几页 默认 1
    NSString *pageNumStr = @"1";//[NSString stringWithFormat:@"%ld",(long)_pageNum++]
    [tempParams setObject:pageNumStr forKey:@"now_page"];
    //status 状态，对应的何种类型的订单
    [tempParams setObject:@"" forKey:@"status"];
    //order 传 t.add_time desc
    [tempParams setObject:@"t.add_time desc" forKey:@"order"];
    //except 不读取到某些类型的,5是储蓄卡购买支付的类型，
    [tempParams setObject:@"" forKey:@"except"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderListData andParams:tempParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        
        //成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSOrderListReturnData *tempReturnModel = resultData;
            
            NSLog(@"tempReturnModel:%@",tempReturnModel.orderListData.orderList);
            self.orderList = [NSMutableArray arrayWithArray:tempReturnModel.orderListData.orderList];
            
            [_orderListTableView reloadData];
            
        }
        
        //隐藏HUD
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
