//
//  QSPOrderViewController.m
//  suntry
//
//  Created by CoolTea on 15/2/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderViewController.h"
#import "ImageHeader.h"
#import "QSBlockButton.h"
#import "QSLabel.h"
#import "DeviceSizeHeader.h"
#import "NSString+Calculation.h"
#import "QSPOrderPaymentView.h"
#import "QSWMySendAdsViewController.h"
#import "QSPOrderSubmitedStateViewController.h"
#import "QSPOrderRemarkViewController.h"
#import "QSWMyCouponViewController.h"
#import "QSGoodsDataModel.h"
#import "QSUserInfoDataModel.h"
#import "QSPPayForOrderViewController.h"

#define ORDERVIEWCONTROLLER_SHIP_BT_BG_COLOR    [UIColor colorWithRed:0.709 green:0.653 blue:0.543 alpha:1.000]
#define ORDERVIEWCONTROLLER_TITLE_FONT_SIZE     17.
#define ORDERVIEWCONTROLLER_ORDER_COUNT_INFO_MARGIN_RIGHT   12.
#define ORDERVIEWCONTROLLER_LINE_COLOR             [UIColor colorWithRed:206/255. green:208/255. blue:210/255. alpha:1]
#define ORDER_VIEW_SPECIAL_CELL_TITLE_FONT_SIZE     17.
#define ORDER_VIEW_SPECIAL_CELL_TEXT_COLOR          [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]


@interface QSPOrderViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) QSLabel *shipToPersonName;
@property (nonatomic, strong) QSLabel *shipToAddress;

@property (nonatomic, strong) UIView  *hadOrderFrameView;
@property (nonatomic, strong) QSLabel *hadOrderTotalCountTip;
@property (nonatomic, strong) QSLabel *hadOrderTotalTip;
@property (nonatomic, strong) QSLabel *hadOrderTotalUnitTip;

@property (nonatomic, strong) UIView  *specialOfferFrameView;
@property (nonatomic, strong) QSLabel *specialOfferTotalCountTip;
@property (nonatomic, strong) QSLabel *specialOfferTotalTip;
@property (nonatomic, strong) QSLabel *specialOfferTotalUnitTip;

@property (nonatomic, strong) UIView  *remarkFrameView;
@property (nonatomic, strong) QSPOrderPaymentView *paymentView;

@property(nonatomic,strong) QSPShoppingCarView *shoppingCarView;

@end

@implementation QSPOrderViewController

//@synthesize foodSelectedList;

- (void)loadView{
    
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    QSBlockButtonStyleModel *backButtonStyle = [[QSBlockButtonStyleModel alloc] init];
    [backButtonStyle setImagesNormal:IMAGE_NAVIGATIONBAR_BACK_NORMAL];
    [backButtonStyle setImagesHighted:IMAGE_NAVIGATIONBAR_MEINFO_HIGHLIGHTED];
    
    UIButton *backButton = [UIButton createBlockButtonWithFrame:CGRectMake(0, 0, 44, 44) andButtonStyle:backButtonStyle andCallBack:^(UIButton *button) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:ORDERVIEWCONTROLLER_TITLE_FONT_SIZE]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"下单"];
    self.navigationItem.titleView = navTitle;
    
    self.shoppingCarView = [[QSPShoppingCarView alloc] initShakeFoodView];
    [_shoppingCarView setFrame:CGRectMake(0, SIZE_DEVICE_HEIGHT-_shoppingCarView.frame.size.height-20-44, _shoppingCarView.frame.size.width, _shoppingCarView.frame.size.height)];
    [_shoppingCarView setProcessType:ProcessTypeOnSubmitOrder];
    [_shoppingCarView setDelegate:self];
    [_shoppingCarView updateShoppingCar];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-44-20-_shoppingCarView.frame.size.height)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_scrollView];
    
    //配送信息
    QSLabel *shipTip = [[QSLabel alloc] initWithFrame:CGRectMake(12, 15, SIZE_DEVICE_WIDTH-24, 17)];
    [shipTip setFont:[UIFont boldSystemFontOfSize:ORDERVIEWCONTROLLER_TITLE_FONT_SIZE]];
    [shipTip setText:@"配送信息"];
    [shipTip setTextColor:[UIColor blackColor]];
    [_scrollView addSubview:shipTip];
    
    QSBlockButtonStyleModel *shipAddressBtStyle = [[QSBlockButtonStyleModel alloc] init];
    [shipAddressBtStyle setCornerRadio:8.];
    [shipAddressBtStyle setBgColor:ORDERVIEWCONTROLLER_SHIP_BT_BG_COLOR];
    UIButton *shipAddressBt = [UIButton createBlockButtonWithFrame:CGRectMake(12, shipTip.frame.origin.y+shipTip.frame.size.height+6, SIZE_DEVICE_WIDTH-24, 70) andButtonStyle:shipAddressBtStyle andCallBack:^(UIButton *button) {

        QSWMySendAdsViewController *adVc = [[QSWMySendAdsViewController alloc] init];
        [self.navigationController pushViewController:adVc animated:YES];
        
    }];
    UIImageView *arrowMarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_arrow_selected"]];
    [arrowMarkView setFrame:CGRectMake(shipAddressBt.frame.size.width-arrowMarkView.frame.size.width-6, (shipAddressBt.frame.size.height-arrowMarkView.frame.size.height)/2, arrowMarkView.frame.size.width, arrowMarkView.frame.size.height)];
    [shipAddressBt addSubview:arrowMarkView];
    [_scrollView addSubview:shipAddressBt];
    
    self.shipToPersonName = [[QSLabel alloc] initWithFrame:CGRectMake(12, 12, shipAddressBt.frame.size.width-36, 16)];
    [_shipToPersonName setBackgroundColor:[UIColor clearColor]];
    [_shipToPersonName setTextColor:[UIColor whiteColor]];
    [shipAddressBt addSubview:_shipToPersonName];
    
    self.shipToAddress = [[QSLabel alloc] initWithFrame:CGRectMake(12, _shipToPersonName.frame.origin.y+_shipToPersonName.frame.size.height+12, _shipToPersonName.frame.size.width, _shipToPersonName.frame.size.height)];
    [_shipToAddress setBackgroundColor:[UIColor clearColor]];
    [_shipToAddress setTextColor:[UIColor whiteColor]];
    [shipAddressBt addSubview:_shipToAddress];
    
    
    //已点菜单
    self.hadOrderFrameView = [[UIView alloc] initWithFrame:CGRectMake(0, shipAddressBt.frame.origin.y+shipAddressBt.frame.size.height, SIZE_DEVICE_WIDTH, 0)];
    [_hadOrderFrameView setBackgroundColor:[UIColor clearColor]];
    [_hadOrderFrameView setClipsToBounds:YES];
    [_scrollView addSubview:_hadOrderFrameView];
 
    QSLabel *hadOrderTip = [[QSLabel alloc] initWithFrame:CGRectMake(12, 12, SIZE_DEVICE_WIDTH-24, 17)];
    [hadOrderTip setFont:[UIFont boldSystemFontOfSize:ORDERVIEWCONTROLLER_TITLE_FONT_SIZE]];
    [hadOrderTip setText:@"已点菜单"];
    [hadOrderTip setTextColor:[UIColor blackColor]];
    [_hadOrderFrameView addSubview:hadOrderTip];
    
    UIView *lineButtomView = [[UIView alloc] initWithFrame:CGRectMake(12, hadOrderTip.frame.origin.y+hadOrderTip.frame.size.height+12, SIZE_DEVICE_WIDTH-24, 1)];
    [lineButtomView setBackgroundColor:ORDERVIEWCONTROLLER_LINE_COLOR];
    [_hadOrderFrameView addSubview:lineButtomView];
    
    NSString* hadOrderTotalTipStr = @"总计";
    CGFloat hadOrderTotalTipStrWidth = [hadOrderTotalTipStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:ORDERVIEWCONTROLLER_TITLE_FONT_SIZE]+4;
    self.hadOrderTotalTip = [[QSLabel alloc] initWithFrame:CGRectMake(0, hadOrderTip.frame.origin.y, hadOrderTotalTipStrWidth, hadOrderTip.frame.size.height)];
    [_hadOrderTotalTip setFont:[UIFont boldSystemFontOfSize:ORDERVIEWCONTROLLER_TITLE_FONT_SIZE]];
    [_hadOrderTotalTip setText:hadOrderTotalTipStr];
    [_hadOrderTotalTip setTextColor:[UIColor blackColor]];
    [_hadOrderFrameView addSubview:_hadOrderTotalTip];
    
    self.hadOrderTotalCountTip = [[QSLabel alloc] initWithFrame:CGRectMake(_hadOrderTotalTip.frame.origin.x+_hadOrderTotalTip.frame.size.width, _hadOrderTotalTip.frame.origin.y, 0, _hadOrderTotalTip.frame.size.height)];
    [_hadOrderTotalCountTip setFont:[UIFont boldSystemFontOfSize:ORDERVIEWCONTROLLER_TITLE_FONT_SIZE]];
    [_hadOrderTotalCountTip setTextColor:[UIColor colorWithRed:0.503 green:0.183 blue:0.236 alpha:1.000]];
    [_hadOrderFrameView addSubview:_hadOrderTotalCountTip];
    
    NSString* hadOrderTotalUnitStr = @"份";
    CGFloat hadOrderTotalUnitStrWidth = [hadOrderTotalUnitStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:ORDERVIEWCONTROLLER_TITLE_FONT_SIZE]+4;
    self.hadOrderTotalUnitTip = [[QSLabel alloc] initWithFrame:CGRectMake(_hadOrderTotalCountTip.frame.origin.x+_hadOrderTotalCountTip.frame.size.width, _hadOrderTotalCountTip.frame.origin.y, hadOrderTotalUnitStrWidth, _hadOrderTotalCountTip.frame.size.height)];
    [_hadOrderTotalUnitTip setFont:[UIFont boldSystemFontOfSize:ORDERVIEWCONTROLLER_TITLE_FONT_SIZE]];
    [_hadOrderTotalUnitTip setText:hadOrderTotalUnitStr];
    [_hadOrderTotalUnitTip setTextColor:[UIColor blackColor]];
    [_hadOrderFrameView addSubview:_hadOrderTotalUnitTip];

    [_hadOrderFrameView setFrame:CGRectMake(_hadOrderFrameView.frame.origin.x, _hadOrderFrameView.frame.origin.y, _hadOrderFrameView.frame.size.width, lineButtomView.frame.origin.y+lineButtomView.frame.size.height)];
    
    
    //优惠信息
    self.specialOfferFrameView = [[UIView alloc] initWithFrame:CGRectMake(0, _hadOrderFrameView.frame.origin.y+_hadOrderFrameView.frame.size.height, SIZE_DEVICE_WIDTH, 0)];
    [_specialOfferFrameView setBackgroundColor:[UIColor clearColor]];
    [_specialOfferFrameView setClipsToBounds:YES];
    [_scrollView addSubview:_specialOfferFrameView];
    
    QSLabel *specialOfferTip = [[QSLabel alloc] initWithFrame:CGRectMake(12, 12, SIZE_DEVICE_WIDTH-24, 17)];
    [specialOfferTip setFont:[UIFont boldSystemFontOfSize:ORDERVIEWCONTROLLER_TITLE_FONT_SIZE]];
    [specialOfferTip setText:@"优惠信息"];
    [specialOfferTip setTextColor:[UIColor blackColor]];
    [_specialOfferFrameView addSubview:specialOfferTip];
    
    UIView *specialOfferFrameLineButtomView = [[UIView alloc] initWithFrame:CGRectMake(12, specialOfferTip.frame.origin.y+specialOfferTip.frame.size.height+12, SIZE_DEVICE_WIDTH-24, 1)];
    [specialOfferFrameLineButtomView setBackgroundColor:ORDERVIEWCONTROLLER_LINE_COLOR];
    [_specialOfferFrameView addSubview:specialOfferFrameLineButtomView];
    [_specialOfferFrameView setFrame:CGRectMake(_specialOfferFrameView.frame.origin.x, _specialOfferFrameView.frame.origin.y, _specialOfferFrameView.frame.size.width, specialOfferFrameLineButtomView.frame.origin.y+specialOfferFrameLineButtomView.frame.size.height)];
    
    NSString* specialOfferTipStr = @"优惠￥";
    CGFloat specialOfferTipStrWidth = [specialOfferTipStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:ORDERVIEWCONTROLLER_TITLE_FONT_SIZE]+4;
    self.specialOfferTotalTip = [[QSLabel alloc] initWithFrame:CGRectMake(0, specialOfferTip.frame.origin.y, specialOfferTipStrWidth, specialOfferTip.frame.size.height)];
    [_specialOfferTotalTip setFont:[UIFont boldSystemFontOfSize:ORDERVIEWCONTROLLER_TITLE_FONT_SIZE]];
    [_specialOfferTotalTip setText:specialOfferTipStr];
    [_specialOfferTotalTip setTextColor:[UIColor blackColor]];
    [_specialOfferFrameView addSubview:_specialOfferTotalTip];
    
    self.specialOfferTotalCountTip = [[QSLabel alloc] initWithFrame:CGRectMake(_specialOfferTotalTip.frame.origin.x+_specialOfferTotalTip.frame.size.width, _specialOfferTotalTip.frame.origin.y, 0, _specialOfferTotalTip.frame.size.height)];
    [_specialOfferTotalCountTip setFont:[UIFont boldSystemFontOfSize:ORDERVIEWCONTROLLER_TITLE_FONT_SIZE]];
    [_specialOfferTotalCountTip setTextColor:[UIColor colorWithRed:0.503 green:0.183 blue:0.236 alpha:1.000]];
    [_specialOfferFrameView addSubview:_specialOfferTotalCountTip];
    
    NSString* specialOfferTotalUnitStr = @"元";
    CGFloat specialOfferTotalUnitStrWidth = [specialOfferTotalUnitStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:ORDERVIEWCONTROLLER_TITLE_FONT_SIZE]+4;
    self.specialOfferTotalUnitTip = [[QSLabel alloc] initWithFrame:CGRectMake(_specialOfferTotalCountTip.frame.origin.x+_specialOfferTotalCountTip.frame.size.width, _specialOfferTotalCountTip.frame.origin.y, specialOfferTotalUnitStrWidth, _specialOfferTotalCountTip.frame.size.height)];
    [_specialOfferTotalUnitTip setFont:[UIFont boldSystemFontOfSize:ORDERVIEWCONTROLLER_TITLE_FONT_SIZE]];
    [_specialOfferTotalUnitTip setText:specialOfferTotalUnitStr];
    [_specialOfferTotalUnitTip setTextColor:[UIColor blackColor]];
    [_specialOfferFrameView addSubview:_specialOfferTotalUnitTip];
    
    
    //备注信息
    self.remarkFrameView = [[UIView alloc] initWithFrame:CGRectMake(0, _specialOfferFrameView.frame.origin.y+_specialOfferFrameView.frame.size.height, SIZE_DEVICE_WIDTH, 0)];
    [_remarkFrameView setBackgroundColor:[UIColor clearColor]];
    [_remarkFrameView setClipsToBounds:YES];
    [_scrollView addSubview:_remarkFrameView];
    
    QSLabel *remarkTip = [[QSLabel alloc] initWithFrame:CGRectMake(12, 12, SIZE_DEVICE_WIDTH-24, 17)];
    [remarkTip setFont:[UIFont boldSystemFontOfSize:ORDERVIEWCONTROLLER_TITLE_FONT_SIZE]];
    [remarkTip setText:@"备注信息"];
    [remarkTip setTextColor:[UIColor blackColor]];
    [_remarkFrameView addSubview:remarkTip];
    
    UIView *remarkFrameLineButtomView = [[UIView alloc] initWithFrame:CGRectMake(12, remarkTip.frame.origin.y+remarkTip.frame.size.height+12, SIZE_DEVICE_WIDTH-24, 1)];
    [remarkFrameLineButtomView setBackgroundColor:ORDERVIEWCONTROLLER_LINE_COLOR];
    [_remarkFrameView addSubview:remarkFrameLineButtomView];

    QSBlockButtonStyleModel *remarkBtStyle = [[QSBlockButtonStyleModel alloc] init];
    [remarkBtStyle setCornerRadio:8.];
    [remarkBtStyle setBgColor:[UIColor clearColor]];
    UIButton *remarkBt = [UIButton createBlockButtonWithFrame:CGRectMake(12, remarkFrameLineButtomView.frame.origin.y+remarkFrameLineButtomView.frame.size.height, SIZE_DEVICE_WIDTH-24, 45) andButtonStyle:remarkBtStyle andCallBack:^(UIButton *button) {
//        NSLog(@"remarkBt");
        QSPOrderRemarkViewController *orVC = [[QSPOrderRemarkViewController alloc] init];
        [self.navigationController pushViewController:orVC animated:YES];
    }];
    UIImageView *remarkArrowMarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_arrow_normal"]];
    [remarkArrowMarkView setFrame:CGRectMake(remarkBt.frame.size.width-remarkArrowMarkView.frame.size.width-6, (remarkBt.frame.size.height-remarkArrowMarkView.frame.size.height)/2, arrowMarkView.frame.size.width, remarkArrowMarkView.frame.size.height)];
    [remarkBt addSubview:remarkArrowMarkView];
    [_remarkFrameView addSubview:remarkBt];
    
    QSLabel *remarkLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0, (remarkBt.frame.size.height-17)/2, remarkBt.frame.size.width-32, 17)];
    [remarkLabel setFont:[UIFont systemFontOfSize:ORDER_VIEW_SPECIAL_CELL_TITLE_FONT_SIZE]];
    [remarkLabel setBackgroundColor:[UIColor clearColor]];
    [remarkLabel setText:@"备注信息"];
    [remarkLabel setTextColor:ORDER_VIEW_SPECIAL_CELL_TEXT_COLOR];
    [remarkBt addSubview:remarkLabel];
    
    UIView *remarkLineButtomView = [[UIView alloc] initWithFrame:CGRectMake(12, remarkBt.frame.origin.y+remarkBt.frame.size.height-1, SIZE_DEVICE_WIDTH-24, 1)];
    [remarkLineButtomView setBackgroundColor:ORDERVIEWCONTROLLER_LINE_COLOR];
    [_remarkFrameView addSubview:remarkLineButtomView];
    
    [_remarkFrameView setFrame:CGRectMake(_remarkFrameView.frame.origin.x, _remarkFrameView.frame.origin.y, _remarkFrameView.frame.size.width, remarkLineButtomView.frame.origin.y+remarkLineButtomView.frame.size.height)];
    
    self.paymentView = [[QSPOrderPaymentView alloc] initOrderItemView];
    CGRect payFrame = _paymentView.frame;
    payFrame.origin.y = _remarkFrameView.frame.origin.y+_remarkFrameView.frame.size.height;
    _paymentView.frame = payFrame;
    [_scrollView addSubview:_paymentView];
    
    [self.view addSubview:_shoppingCarView];
    
    [self updateView];
    
}

- (void)updateView
{
    
    [self updateAddress];
    [self updateHadOrderFoodList];
    [self updateHadOrderCount];
    [self updateSpecialOfferCount];
    
    CGRect tempFrame = _remarkFrameView.frame;
    tempFrame.origin.y = _specialOfferFrameView.frame.origin.y+_specialOfferFrameView.frame.size.height;
    [_remarkFrameView setFrame:tempFrame];
    
    CGRect payFrame = _paymentView.frame;
    payFrame.origin.y = _remarkFrameView.frame.origin.y+_remarkFrameView.frame.size.height;
    _paymentView.frame = payFrame;
    [_scrollView addSubview:_paymentView];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _paymentView.frame.origin.y+_paymentView.frame.size.height+15)];
}

- (void)updateAddress
{
    QSUserInfoDataModel *userData = [QSUserInfoDataModel userDataModel];
    
    if (userData && userData.address) {
        BOOL hasAddress = ![userData.address isEqualToString:@""];
        if (hasAddress) {
            
//            [_shipToPersonName setText:@"李先生    18688888888"];
//            [_shipToAddress setText:@"地址：广州市天河区体育西路城建大厦五楼"];
            [_shipToPersonName setText:[NSString stringWithFormat:@"%@  %@",userData.receidName, userData.phone]];
            [_shipToAddress setText:userData.address];
            
        }else{
            
            QSPOrderAddNewAddressView *addNewAddView = [QSPOrderAddNewAddressView getAddNewAddressView];
            [self.navigationController.view addSubview:addNewAddView];
            [addNewAddView setDelegate:self];
            [addNewAddView showAddNewAddressView];
            
        }
    }else{
        //没有用户数据
        
    }
}

- (void)updateHadOrderCount
{
    NSInteger selectedTotalCount = 0;
    if (self.foodSelectedList&&[self.foodSelectedList isKindOfClass:[NSArray class]])
    {
        NSArray *array = self.foodSelectedList;
        
        for (int i=0; i<[array count]; i++) {
            NSDictionary *dic = array[i];
            NSNumber *count = [dic objectForKey:@"count"];
            if (count) {
                
                selectedTotalCount += count.integerValue;
                
                QSGoodsDataModel *food = [dic objectForKey:@"goods"];
                if (food&&[food isKindOfClass:[QSGoodsDataModel class]]) {
                    
                    [_shoppingCarView changeGoods:food withCount:count.longValue];
                    
                }
            }
        }
    }
    
    //计算宽度
    NSString* hadOrderTotalCountStr = [NSString stringWithFormat:@"%ld",(long)selectedTotalCount];
    CGFloat hadOrderTotalCountStrWidth = [hadOrderTotalCountStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:ORDERVIEWCONTROLLER_TITLE_FONT_SIZE]+4;
    [_hadOrderTotalCountTip setFrame:CGRectMake(_hadOrderTotalCountTip.frame.origin.x, _hadOrderTotalCountTip.frame.origin.y, hadOrderTotalCountStrWidth, _hadOrderTotalCountTip.frame.size.height)];
    [_hadOrderTotalCountTip setText:hadOrderTotalCountStr];
    
    //设置位置
    CGRect tempFrame = _hadOrderTotalTip.frame;
    tempFrame.origin.x = _hadOrderFrameView.frame.size.width-ORDERVIEWCONTROLLER_ORDER_COUNT_INFO_MARGIN_RIGHT-_hadOrderTotalTip.frame.size.width-_hadOrderTotalCountTip.frame.size.width-_hadOrderTotalUnitTip.frame.size.width;
    [_hadOrderTotalTip setFrame:tempFrame];
    
    tempFrame = _hadOrderTotalCountTip.frame;
    tempFrame.origin.x = _hadOrderTotalTip.frame.origin.x+_hadOrderTotalTip.frame.size.width;
    [_hadOrderTotalCountTip setFrame:tempFrame];
    
    tempFrame = _hadOrderTotalUnitTip.frame;
    tempFrame.origin.x = _hadOrderTotalCountTip.frame.origin.x+_hadOrderTotalCountTip.frame.size.width;
    [_hadOrderTotalUnitTip setFrame:tempFrame];
    
    
}

- (void)updateHadOrderFoodList
{
    
    for (UIView *view in [_hadOrderFrameView subviews]) {
        if ([view isKindOfClass:[QSPOrderViewHadOrderCell class]]) {
            [view removeFromSuperview];
        }
    }
    if (self.foodSelectedList&&[self.foodSelectedList isKindOfClass:[NSArray class]])
    {
        NSArray *array = self.foodSelectedList;
        for (int i=0; i<[array count]; i++) {
            NSDictionary *dic = array[i];
            id foodData = [dic objectForKey:@"goods"];
            if (foodData&&[foodData isKindOfClass:[QSGoodsDataModel class]]) {
                NSNumber *count = [dic objectForKey:@"count"];
                
                QSPOrderViewHadOrderCell *cell = [[QSPOrderViewHadOrderCell alloc] initOrderItemViewWithData:(QSGoodsDataModel*)foodData withCount:count.integerValue];
                [cell setFrame:CGRectMake(0, _hadOrderTotalTip.frame.origin.y+_hadOrderTotalTip.frame.size.height+12 + i *cell.frame.size.height, cell.frame.size.width, cell.frame.size.height)];
                [cell setDelegate:self];
                [_hadOrderFrameView addSubview:cell];
                [_hadOrderFrameView setFrame:CGRectMake(_hadOrderFrameView.frame.origin.x, _hadOrderFrameView.frame.origin.y, _hadOrderFrameView.frame.size.width, cell.frame.origin.y+cell.frame.size.height)];
            }
        }
    }
    
 }

- (void)updateSpecialOfferCount
{
    
    //计算宽度
    NSString* specialOfferTotalCountStr = [NSString stringWithFormat:@"%ld",(long)8];
    CGFloat specialOfferTotalCountStrWidth = [specialOfferTotalCountStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:ORDERVIEWCONTROLLER_TITLE_FONT_SIZE]+4;
    [_specialOfferTotalCountTip setFrame:CGRectMake(_specialOfferTotalCountTip.frame.origin.x, _specialOfferTotalCountTip.frame.origin.y, specialOfferTotalCountStrWidth, _specialOfferTotalCountTip.frame.size.height)];
    [_specialOfferTotalCountTip setText:specialOfferTotalCountStr];
    
    //设置位置
    CGRect tempFrame = _specialOfferTotalTip.frame;
    tempFrame.origin.x = _scrollView.frame.size.width-ORDERVIEWCONTROLLER_ORDER_COUNT_INFO_MARGIN_RIGHT-_specialOfferTotalTip.frame.size.width-_specialOfferTotalCountTip.frame.size.width-_specialOfferTotalUnitTip.frame.size.width;
    [_specialOfferTotalTip setFrame:tempFrame];
    
    tempFrame = _specialOfferTotalCountTip.frame;
    tempFrame.origin.x = _specialOfferTotalTip.frame.origin.x+_specialOfferTotalTip.frame.size.width;
    [_specialOfferTotalCountTip setFrame:tempFrame];
    
    tempFrame = _specialOfferTotalUnitTip.frame;
    tempFrame.origin.x = _specialOfferTotalCountTip.frame.origin.x+_specialOfferTotalCountTip.frame.size.width;
    [_specialOfferTotalUnitTip setFrame:tempFrame];
    
    tempFrame = _specialOfferFrameView.frame;
    tempFrame.origin.y = _hadOrderFrameView.frame.origin.y+_hadOrderFrameView.frame.size.height;
    [_specialOfferFrameView setFrame:tempFrame];
    
    //TODO: 用户的优惠券设置
    NSArray *specialOfferList = [NSArray array];//[NSArray arrayWithObjects:@"", nil];
    
    for (UIView *view in [_specialOfferFrameView subviews]) {
        if (view.tag>=8000&&view.tag<8009) {
            [view removeFromSuperview];
        }
    }
    for (int i=0; i<[specialOfferList count]; i++) {
        
        QSBlockButtonStyleModel *specialOfferBtStyle = [[QSBlockButtonStyleModel alloc] init];
        [specialOfferBtStyle setBgColor:[UIColor clearColor]];
        UIButton *specialOfferBt = [UIButton createBlockButtonWithFrame:CGRectMake(12, _specialOfferTotalTip.frame.origin.y+_specialOfferTotalTip.frame.size.height+12 + i * 45, SIZE_DEVICE_WIDTH-24, 45) andButtonStyle:specialOfferBtStyle andCallBack:^(UIButton *button) {
            NSLog(@"specialOfferBt");
            
            QSWMyCouponViewController *myCouponVc = [[QSWMyCouponViewController alloc] init];
            [self.navigationController pushViewController:myCouponVc animated:YES];
            
        }];
        UIImageView *arrowMarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_arrow_normal"]];
        [arrowMarkView setFrame:CGRectMake(specialOfferBt.frame.size.width-arrowMarkView.frame.size.width-6, (specialOfferBt.frame.size.height-arrowMarkView.frame.size.height)/2, arrowMarkView.frame.size.width, arrowMarkView.frame.size.height)];
        [specialOfferBt addSubview:arrowMarkView];
        [specialOfferBt setTag:8000+i];
        [_specialOfferFrameView addSubview:specialOfferBt];
        
        QSLabel *scNameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0, (specialOfferBt.frame.size.height-17)/2, specialOfferBt.frame.size.width-26, 17)];
        [scNameLabel setFont:[UIFont systemFontOfSize:ORDER_VIEW_SPECIAL_CELL_TITLE_FONT_SIZE]];
        [scNameLabel setBackgroundColor:[UIColor clearColor]];
        [scNameLabel setText:@"超级业界良心劲爆奖赏新人红包8元恭喜发财大优惠"];
        [scNameLabel setTextColor:ORDER_VIEW_SPECIAL_CELL_TEXT_COLOR];
        [specialOfferBt addSubview:scNameLabel];
        
        UIView *lineButtomView = [[UIView alloc] initWithFrame:CGRectMake(12, specialOfferBt.frame.origin.y+specialOfferBt.frame.size.height-1, SIZE_DEVICE_WIDTH-24, 1)];
        [lineButtomView setBackgroundColor:ORDERVIEWCONTROLLER_LINE_COLOR];
        [_specialOfferFrameView addSubview:lineButtomView];
        
        [_specialOfferFrameView setFrame:CGRectMake(_specialOfferFrameView.frame.origin.x, _specialOfferFrameView.frame.origin.y, _specialOfferFrameView.frame.size.width, lineButtomView.frame.origin.y+lineButtomView.frame.size.height)];
        
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  响应增加减少菜品操作
 *
 *  @param count    修改后的数量
 *  @param foodData 修改的菜品
 */
- (void)changedCount:(NSInteger)count withFoodData:(id)foodData
{
    
    NSLog(@"changedCount:%ld withFoodData:%@",(long)count,foodData);

    BOOL hadGood = NO;
    for (int i=0; i<[self.foodSelectedList count]; i++) {
        NSMutableDictionary *tempDic = self.foodSelectedList[i];
        if (tempDic) {
            
            QSGoodsDataModel *food = [tempDic objectForKey:@"goods"];
            if (food&&[food isKindOfClass:[QSGoodsDataModel class]]&&foodData&&[foodData isKindOfClass:[QSGoodsDataModel class]]) {
                
                if ([food.goodsName isEqualToString:((QSGoodsDataModel*)foodData).goodsName]) {
                    
                    hadGood = YES;
                    [tempDic setObject:[NSNumber numberWithInt:(int)(count)] forKey:@"count"];
                    
                }
            }
        }
    }
    if (NO==hadGood) {
        NSMutableDictionary *itemDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:foodData,@"goods",[NSNumber numberWithInt:(int)count],@"count",nil];
        [self.foodSelectedList addObject:itemDic];
    }
    
    
    [self updateHadOrderCount];
    
}

/**
 *  点击确定下单响应
 *
 *  @param foodData 返回购物车的数据
 */
- (void)orderWithData:(id)foodData
{
    NSLog(@"order foodData:%@",foodData);
    
    if ([self checkOrder]) {
        
        PaymentType selectedPayment = [_paymentView getSelectedPayment];
        
        switch (selectedPayment) {
            case PaymentTypePayForAfter:
                {
                    QSPOrderSubmitedStateViewController *ossVc = [[QSPOrderSubmitedStateViewController alloc] init];
                    [ossVc setPaymentSate:YES];
                    [self.navigationController pushViewController:ossVc animated:YES];
                    
                }
                break;
            case PaymentTypeAlipay:
                
                break;
            case PaymentTypePayCrads:
                
                break;
            default:
                break;
        }
    }
    
}

/**
 *  判断是否能够提交订单
 *
 *  @return YES:能提交订单，NO:不能提交。
 */
- (BOOL)checkOrder
{
    
    BOOL flag = YES;
    
    //TODO: 判断有没有地址
    
    PaymentType currentSelectPayment = [_paymentView getSelectedPayment];
    
    if (currentSelectPayment == PaymentTypeNoPayment) {
        
        flag = NO;
        
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择支付方式" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertview show];
        
    }else if (currentSelectPayment == PaymentTypePayCrads) {
        
        QSPPayForOrderViewController *pfovc = [[QSPPayForOrderViewController alloc] init];
        [self.navigationController pushViewController:pfovc animated:YES];
    }
    
    return flag;
    
}

- (void)AddNewAddressWithData:(id)data
{
    NSLog(@"添加新地址：%@",data);
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
