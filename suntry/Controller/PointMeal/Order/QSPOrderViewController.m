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
#import "QSWLoginViewController.h"
#import "QSRequestManager.h"
#import "QSUserCouponListReturnData.h"
#import "MBProgressHUD.h"
#import "QSAddOrderReturnData.h"
#import "QSOrderInfoDataModel.h"
#import "QSAlixPayManager.h"
#import "QSUserAddressDataModel.h"
#import "QSPOrderDeliveryTimeView.h"
#import "QSWMyCouponViewController.h"
#import "QSCouponInfoDataModel.h"

#define ORDERVIEWCONTROLLER_SHIP_BT_BG_COLOR    [UIColor colorWithRed:0.709 green:0.653 blue:0.543 alpha:1.000]
#define ORDERVIEWCONTROLLER_TITLE_FONT_SIZE     17.
#define ORDERVIEWCONTROLLER_ORDER_COUNT_INFO_MARGIN_RIGHT   12.
#define ORDERVIEWCONTROLLER_LINE_COLOR             [UIColor colorWithRed:206/255. green:208/255. blue:210/255. alpha:1]
#define ORDER_VIEW_SPECIAL_CELL_TITLE_FONT_SIZE     17.
#define ORDER_VIEW_SPECIAL_CELL_TEXT_COLOR          [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]


@interface QSPOrderViewController ()<QSPOrderViewHadOrderCellDelegate,QSPShoppingCarViewDelegate, QSPOrderAddNewAddressViewDelegate, QSPOrderPaymentViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) QSLabel *shipToPersonName;
@property (nonatomic, strong) QSLabel *shipToAddress;
@property (nonatomic, strong) QSPOrderAddNewAddressView *addNewAddView;

@property (nonatomic, strong) UIView  *hadOrderFrameView;
@property (nonatomic, strong) QSLabel *hadOrderTotalCountTip;
@property (nonatomic, strong) QSLabel *hadOrderTotalTip;
@property (nonatomic, strong) QSLabel *hadOrderTotalUnitTip;

@property (nonatomic, strong) UIView  *specialOfferFrameView;
@property (nonatomic, strong) QSLabel *specialOfferTotalCountTip;
@property (nonatomic, strong) QSLabel *specialOfferTotalTip;
@property (nonatomic, strong) QSLabel *specialOfferTotalUnitTip;
@property (nonatomic, strong) QSLabel *couponBtLabel;

@property (nonatomic, strong) QSPOrderDeliveryTimeView *deliveryTimeView;

@property (nonatomic, strong) UIView  *remarkFrameView;
@property (nonatomic, strong) QSLabel *remarkLabel;
@property (nonatomic, strong) QSPOrderPaymentView *paymentView;

@property (nonatomic, strong) QSPShoppingCarView *shoppingCarView;

@property (nonatomic, strong) NSString *orderName;      //下单名字
@property (nonatomic, strong) NSString *orderAddress;   // 地址
@property (nonatomic, strong) NSString *orderPhone;     //下单电话

@property (nonatomic, strong) NSArray  *couponList;

@end

@implementation QSPOrderViewController

- (void)loadView{
    
    [super loadView];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KEY_ORDER_USER_REMARK_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.couponList = [NSArray array];
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
    
    CGFloat offetY = 0;
    if ([[UIDevice currentDevice].systemVersion doubleValue] == 7.0) {
        offetY = 64;
    }
    
    self.shoppingCarView = [[QSPShoppingCarView alloc] initShakeFoodView];
    [_shoppingCarView setFrame:CGRectMake(0, SIZE_DEVICE_HEIGHT-_shoppingCarView.frame.size.height-20-44+offetY, _shoppingCarView.frame.size.width, _shoppingCarView.frame.size.height)];
    [_shoppingCarView setProcessType:ProcessTypeOnSubmitOrder];
    [_shoppingCarView setDelegate:self];
    [_shoppingCarView updateShoppingCar];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-44-20-_shoppingCarView.frame.size.height+offetY)];
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

        //判断有没有地址
        if (!self.orderName || !self.orderAddress || !self.orderPhone || [self.orderName isEqualToString:@""] || [self.orderAddress isEqualToString:@""] || [self.orderPhone isEqualToString:@""]) {
            
            [self showAddNewAddressView];
            
        }else{
            QSWMySendAdsViewController *adVc = [[QSWMySendAdsViewController alloc] init];
            [self.navigationController pushViewController:adVc animated:YES];
        }
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
    
    UIView *specialOfferTipLineButtomView = [[UIView alloc] initWithFrame:CGRectMake(12, specialOfferTip.frame.origin.y+specialOfferTip.frame.size.height+12, SIZE_DEVICE_WIDTH-24, 1)];
    [specialOfferTipLineButtomView setBackgroundColor:ORDERVIEWCONTROLLER_LINE_COLOR];
    [_specialOfferFrameView addSubview:specialOfferTipLineButtomView];
    [_specialOfferFrameView setFrame:CGRectMake(_specialOfferFrameView.frame.origin.x, _specialOfferFrameView.frame.origin.y, _specialOfferFrameView.frame.size.width, specialOfferTipLineButtomView.frame.origin.y+specialOfferTipLineButtomView.frame.size.height)];
    
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
    
//    QSBlockButtonStyleModel *specialOfferBtStyle = [[QSBlockButtonStyleModel alloc] init];
//    [specialOfferBtStyle setBgColor:[UIColor clearColor]];
//    UIButton *specialOfferBt = [UIButton createBlockButtonWithFrame:CGRectMake(12, _specialOfferTotalTip.frame.origin.y+_specialOfferTotalTip.frame.size.height+12 + 0 * 45, SIZE_DEVICE_WIDTH-24, 45) andButtonStyle:specialOfferBtStyle andCallBack:^(UIButton *button) {
//        NSLog(@"specialOfferBt");
//        
//        QSWMyCouponViewController *myCouponVc = [[QSWMyCouponViewController alloc] init];
//        [self.navigationController pushViewController:myCouponVc animated:YES];
//        
//    }];
//    UIImageView *specialOfferrrowMarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_arrow_normal"]];
//    [specialOfferrrowMarkView setFrame:CGRectMake(specialOfferBt.frame.size.width-arrowMarkView.frame.size.width-6, (specialOfferBt.frame.size.height-arrowMarkView.frame.size.height)/2, arrowMarkView.frame.size.width, arrowMarkView.frame.size.height)];
//    [specialOfferBt addSubview:specialOfferrrowMarkView];
//    [specialOfferBt setTag:8000];
//    [_specialOfferFrameView addSubview:specialOfferBt];
//    
//    QSLabel *scNameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0, (specialOfferBt.frame.size.height-17)/2, specialOfferBt.frame.size.width-26, 17)];
//    [scNameLabel setFont:[UIFont systemFontOfSize:ORDER_VIEW_SPECIAL_CELL_TITLE_FONT_SIZE]];
//    [scNameLabel setBackgroundColor:[UIColor clearColor]];
//    [scNameLabel setText:@"暂无优惠"];
//    [scNameLabel setTextColor:ORDER_VIEW_SPECIAL_CELL_TEXT_COLOR];
//    [specialOfferBt addSubview:scNameLabel];
//    
//    UIView *specialOfferBtLineButtomView = [[UIView alloc] initWithFrame:CGRectMake(12,specialOfferBt.frame.size.height-1, SIZE_DEVICE_WIDTH-24, 1)];
//    [specialOfferBtLineButtomView setBackgroundColor:ORDERVIEWCONTROLLER_LINE_COLOR];
//    [specialOfferBt addSubview:specialOfferBtLineButtomView];
//    
//    [_specialOfferFrameView setFrame:CGRectMake(_specialOfferFrameView.frame.origin.x, _specialOfferFrameView.frame.origin.y, _specialOfferFrameView.frame.size.width, specialOfferBt.frame.origin.y+specialOfferBt.frame.size.height)];
//    
    //送餐时间
    self.deliveryTimeView = [[QSPOrderDeliveryTimeView alloc] initOrderDeliveryTimeView];
    [self.deliveryTimeView setFrame:CGRectMake(0, _specialOfferFrameView.frame.origin.y+_specialOfferFrameView.frame.size.height, self.deliveryTimeView.frame.size.width, self.deliveryTimeView.frame.size.height)];
    [_scrollView addSubview:_deliveryTimeView];
    
    //备注信息
    self.remarkFrameView = [[UIView alloc] initWithFrame:CGRectMake(0, _deliveryTimeView.frame.origin.y+_deliveryTimeView.frame.size.height, SIZE_DEVICE_WIDTH, 0)];
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
    
    self.remarkLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0, (remarkBt.frame.size.height-17)/2, remarkBt.frame.size.width-32, 17)];
    [self.remarkLabel setFont:[UIFont systemFontOfSize:ORDER_VIEW_SPECIAL_CELL_TITLE_FONT_SIZE]];
    [self.remarkLabel setBackgroundColor:[UIColor clearColor]];
//    [self.remarkLabel setText:@"暂无备注"];
    [self.remarkLabel setTextColor:ORDER_VIEW_SPECIAL_CELL_TEXT_COLOR];
    [remarkBt addSubview:self.remarkLabel];
    
    UIView *remarkLineButtomView = [[UIView alloc] initWithFrame:CGRectMake(12, remarkBt.frame.origin.y+remarkBt.frame.size.height-1, SIZE_DEVICE_WIDTH-24, 1)];
    [remarkLineButtomView setBackgroundColor:ORDERVIEWCONTROLLER_LINE_COLOR];
    [_remarkFrameView addSubview:remarkLineButtomView];
    
    [_remarkFrameView setFrame:CGRectMake(_remarkFrameView.frame.origin.x, _remarkFrameView.frame.origin.y, _remarkFrameView.frame.size.width, remarkLineButtomView.frame.origin.y+remarkLineButtomView.frame.size.height)];
    
    self.paymentView = [[QSPOrderPaymentView alloc] initOrderItemView];
    CGRect payFrame = _paymentView.frame;
    payFrame.origin.y = _remarkFrameView.frame.origin.y+_remarkFrameView.frame.size.height;
    _paymentView.frame = payFrame;
    [_paymentView setDelegate:self];
    [_scrollView addSubview:_paymentView];
    
    [self.view addSubview:_shoppingCarView];
    
    [self updateView];
    
}

- (void)updateView
{
    
    [self updateAddress];
    [self updateHadOrderFoodList];
    [self updateHadOrderCount];
//    [self getUserCouponList];
    [self updateSpecialOfferCount];
    
    [self.deliveryTimeView setFrame:CGRectMake(0, _specialOfferFrameView.frame.origin.y+_specialOfferFrameView.frame.size.height, self.deliveryTimeView.frame.size.width, self.deliveryTimeView.frame.size.height)];
    
    CGRect tempFrame = _remarkFrameView.frame;
    tempFrame.origin.y = _deliveryTimeView.frame.origin.y+_deliveryTimeView.frame.size.height;
    [_remarkFrameView setFrame:tempFrame];
    
    
    CGRect payFrame = _paymentView.frame;
    payFrame.origin.y = _remarkFrameView.frame.origin.y+_remarkFrameView.frame.size.height;
    _paymentView.frame = payFrame;
    [_scrollView addSubview:_paymentView];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _paymentView.frame.origin.y+_paymentView.frame.size.height+45)];
}

- (void)updateAddress
{
    
    self.orderName = @"";
    self.orderAddress = @"";
    self.orderPhone = @"";
    [_shipToPersonName setText:[NSString stringWithFormat:@"%@  %@",self.orderName, self.orderPhone]];
    [_shipToAddress setText:self.orderAddress];
    
    QSUserInfoDataModel *userData = [QSUserInfoDataModel userDataModel];
    
    if (userData) {
        
        if (userData.address && ![userData.address isEqualToString:@""]) {

            self.orderName = userData.receidName;
            self.orderAddress = userData.address;
            self.orderPhone = userData.phone;
            [_shipToPersonName setText:[NSString stringWithFormat:@"%@  %@",self.orderName, self.orderPhone]];
            [_shipToAddress setText:self.orderAddress];
            return;
        }else if(userData.address && [userData.address isEqualToString:@""]){
            ///获取本地数据
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/user_send_address"];
            NSData *tempData = [NSData dataWithContentsOfFile:path];
            NSArray *tempList = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
            if (tempList && [tempList count] > 0) {
                QSUserAddressDataModel* addressDic = (QSUserAddressDataModel*)(tempList[0]);
                self.orderName = addressDic.userName;
                self.orderAddress = addressDic.address;
                self.orderPhone = addressDic.phone;
                [_shipToPersonName setText:[NSString stringWithFormat:@"%@  %@",self.orderName, self.orderPhone]];
                [_shipToAddress setText:self.orderAddress];
                return;
            }else{
                [self showAddNewAddressView];
            }
        }
        
    }else{
        [self showAddNewAddressView];
    }

}

- (void)showAddNewAddressView
{
    if (!self.addNewAddView) {
        self.addNewAddView = [QSPOrderAddNewAddressView getAddNewAddressView];
    }
    [self.addNewAddView setDelegate:self];
    id tempView;
    for (UIView *view in [self.tabBarController.view subviews]) {
        if ([view isKindOfClass:[QSPOrderAddNewAddressView class]]) {
            tempView = view;
            break;
        }
    }
    if (!tempView) {
        [self.tabBarController.view addSubview:self.addNewAddView];
    }else{
        self.addNewAddView = (QSPOrderAddNewAddressView*)tempView;
    }
    [self.tabBarController.view bringSubviewToFront:self.addNewAddView];
    [self.addNewAddView showAddNewAddressView];
}

- (void)updateHadOrderCount
{
    //!!!! : 逻辑需要根据购物车逻辑完善。
    NSInteger selectedTotalCount = 0;

    NSArray *array = [QSPShoppingCarData getShoppingCarDataList];
    
    for (int i=0; i<[array count]; i++) {
        NSDictionary *dic = array[i];
        NSString *countStr = [dic objectForKey:@"num"];
        if (countStr&&[countStr isKindOfClass:[NSString class]]) {
            selectedTotalCount += countStr.integerValue;
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
    
    if (_shoppingCarView) {
        [_shoppingCarView updateShoppingCar];
    }
}

- (void)updateHadOrderFoodList
{
    
    for (UIView *view in [_hadOrderFrameView subviews]) {
        if ([view isKindOfClass:[QSPOrderViewHadOrderCell class]]) {
            [view removeFromSuperview];
        }
    }
    
    NSArray *array = [QSPShoppingCarData getShoppingCarDataList];
    for (int i=0; i<[array count]; i++) {
        NSDictionary *dic = array[i];
            NSString *countStr = [dic objectForKey:@"num"];
        
            QSPOrderViewHadOrderCell *cell = [[QSPOrderViewHadOrderCell alloc] initOrderItemViewWithData:dic withCount:countStr.integerValue];
            [cell setFrame:CGRectMake(0, _hadOrderTotalTip.frame.origin.y+_hadOrderTotalTip.frame.size.height+12 + i *cell.frame.size.height, cell.frame.size.width, cell.frame.size.height)];
            [cell setDelegate:self];
            [_hadOrderFrameView addSubview:cell];
            [_hadOrderFrameView setFrame:CGRectMake(_hadOrderFrameView.frame.origin.x, _hadOrderFrameView.frame.origin.y, _hadOrderFrameView.frame.size.width, cell.frame.origin.y+cell.frame.size.height)];
    }
    
 }

- (void)updateSpecialOfferCount
{
    
    //计算宽度
    NSString* specialOfferTotalCountStr = [NSString stringWithFormat:@"%ld",(long)0];
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
    NSArray *specialOfferList = self.couponList;//[NSArray arrayWithObjects:@"", nil];
    if (!specialOfferList || [specialOfferList count]==0 ) {
        specialOfferList = [NSArray arrayWithObjects:@"暂无优惠", nil];
    }
    
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
        NSString *titleStr = @"";
        id item = [specialOfferList objectAtIndex:i];
        if (item) {
            if ([item isKindOfClass:[NSString class]]) {
                titleStr = item;
            }else if ([item isKindOfClass:[QSCouponInfoDataModel class]]) {
                titleStr = ((QSCouponInfoDataModel*)item).goods_name;
            }
        }
        [scNameLabel setText:titleStr];
        [scNameLabel setTextColor:ORDER_VIEW_SPECIAL_CELL_TEXT_COLOR];
        [specialOfferBt addSubview:scNameLabel];
        
        UIView *lineButtomView = [[UIView alloc] initWithFrame:CGRectMake(0,specialOfferBt.frame.size.height-1, SIZE_DEVICE_WIDTH-24, 1)];
        [lineButtomView setBackgroundColor:ORDERVIEWCONTROLLER_LINE_COLOR];
        [specialOfferBt addSubview:lineButtomView];
        
        [_specialOfferFrameView setFrame:CGRectMake(_specialOfferFrameView.frame.origin.x, _specialOfferFrameView.frame.origin.y, _specialOfferFrameView.frame.size.width, specialOfferBt.frame.origin.y+specialOfferBt.frame.size.height)];
        
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    int isLogin = [[[NSUserDefaults standardUserDefaults] valueForKey:@"is_login"] intValue];
    
    if (isLogin != 1 ) {
        
        QSWLoginViewController *loginVC = [[QSWLoginViewController alloc] init];
        loginVC.loginSuccessCallBack = ^(BOOL flag){
            
            if (flag) {
                
                [self updateView];
            }
            
        };
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }else{
        [self updateView];
    }
    
    NSString *remarkStr = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_ORDER_USER_REMARK_INFO];
    if (!remarkStr || [remarkStr isEqualToString:@""]) {
        [self.remarkLabel setText:@"暂无备注"];
    }else{
        [self.remarkLabel setText:remarkStr];
    }
    
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
    if (foodData&&[foodData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *food = (NSDictionary*)foodData;
        if ([food objectForKey:@"num_instock"]) {
            NSString *numInstockStr = [food objectForKey:@"num_instock"];
            if (count>numInstockStr.integerValue) {
                count = numInstockStr.integerValue;
            }
        }
    }

    [QSPShoppingCarData setShoppingCarDataListWithData:foodData withCount:count AddOrSetPackageData:NO];
    
    if (count==0) {
        [self updateView];
    }else{
        [self updateHadOrderCount];
    }
    
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
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        PaymentType selectedPayment = [_paymentView getSelectedPayment];
        
        //提交订单所需参数
        NSMutableDictionary *tempParams = [[NSMutableDictionary alloc] init];
        /**
         *  user_id 用户id
         *  name 下订名字
         *  address 地址
         *  phone 电话
         *  expand_4 （必传参数，支付类型，3，储蓄卡支付；1在线支付，2餐到付款 ）
         *  mer_id 商家id
         *  total_money 总价
         *  get_time 要求获取的时间,字符串
         *  ortherPhone 其他电话
         *  desc 描述
         *  diet 菜牌的数量 array() or json
         *  promotion 优惠数组 array() or json
         *  coupon 优惠卷 array() or json
         *  status 状态
         *  source_type 来源类型 1 为后台，2为ios手机端，3为android手机端，4为网站端
         *  latitude 经度，（可选）
         *  longitude 纬度（可选）
         *  diet_num 菜品总数
         *  pay_type是否已支付，必传参数，默认传0
         *  run_id 用户id
         *  run_type 操作类型，1代表为后台下单，2代表为线上下单
         */
        
        ///用户信息模型
        QSUserInfoDataModel *userModel = [QSUserInfoDataModel userDataModel];
        
        // user_id用户ID
        [tempParams setObject:userModel.userID forKey:@"user_id"];
        // name 下订名字
        [tempParams setObject:self.orderName forKey:@"name"];
        // address 下单地址
        [tempParams setObject:self.orderAddress forKey:@"address"];
        // expand_4 （必传参数，支付类型，3，储蓄卡支付；1在线支付，2餐到付款 ）
        [tempParams setObject:@"" forKey:@"expand_4"];
        // phone 下单电话
        [tempParams setObject:self.orderPhone forKey:@"phone"];
        // mer_id 商家ID
        [tempParams setObject:@"1" forKey:@"mer_id"];
        // total_money 总价
        [tempParams setObject:[NSString stringWithFormat:@"%.2f",[QSPShoppingCarData getTotalPrice]] forKey:@"total_money"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSString *currentDateStr = @"";
        
        // get_time 送餐的时间,时间戳字符串  上午: 2015-02-28-12：00  下午 2015-02-28-18：00
        DeliveryTimeType currentSelectTime = [self.deliveryTimeView getSelectedDeliveryTime];
        switch (currentSelectTime) {
            case DeliveryTimeTypeTodayAM:
                [dateFormatter setDateFormat:@"yyyy-MM-dd 12:00:00"];
                currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
                break;
            case DeliveryTimeTypeTodayPM:
                [dateFormatter setDateFormat:@"yyyy-MM-dd 18:00:00"];
                currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
                break;
            case DeliveryTimeTypeTomorrowAM:
                [dateFormatter setDateFormat:@"yyyy-MM-dd 12:00:00"];
                currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:24*60*60]];
                break;
            case DeliveryTimeTypeTomorrowPM:
                [dateFormatter setDateFormat:@"yyyy-MM-dd 18:00:00"];
                currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:24*60*60]];
                break;
            default:
                currentDateStr = @"";
                break;
        }
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate* selectedDate = [dateFormatter dateFromString:currentDateStr];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[selectedDate timeIntervalSince1970]];
        NSLog(@"timeSp:%@",timeSp); //时间戳的值
        
        [tempParams setObject:timeSp forKey:@"get_time"];
        // ortherPhone 其他电话
        [tempParams setObject:@"" forKey:@"ortherPhone"];
        // desc 描述，备注信息
        [tempParams setObject:[self.remarkLabel text] forKey:@"desc"];
        // diet 菜牌的数量 array() or json promotion
        [tempParams setObject:[QSPShoppingCarData getShoppingCarDataList] forKey:@"diet"];
        // promotion 优惠数组 array() or json
        [tempParams setObject:[NSArray array] forKey:@"promotion"];
        // coupon 优惠卷 array() or json
        if (!_couponList) {
            _couponList = [NSArray array];
        }
        [tempParams setObject:_couponList forKey:@"coupon"];
        // status 状态
        [tempParams setObject:@"" forKey:@"status"];
        // source_type 来源类型 1 为后台，2为ios手机端，3为android手机端，4为网站端
        [tempParams setObject:@"2" forKey:@"source_type"];
        // latitude 经度，（可选）
        [tempParams setObject:@"" forKey:@"latitude"];
        // longitude 纬度（可选）
        [tempParams setObject:@"" forKey:@"longitude"];
        // diet_num 菜品总数
        [tempParams setObject:[NSString stringWithFormat:@"%ld",(long)[QSPShoppingCarData getTotalFoodCount]] forKey:@"diet_num"];
        // pay_type是否已支付，必传参数，默认传0
        [tempParams setObject:@"0" forKey:@"pay_type"];
        // run_id 用户id
        [tempParams setObject:userModel.userID forKey:@"run_id"];
        // run_type 操作类型，1代表为后台下单，2代表为线上下单
        [tempParams setObject:@"2" forKey:@"run_type"];
        
        switch (selectedPayment) {
            case PaymentTypePayForAfter:
                //支付类型 2餐到付款
                [tempParams setObject:@"2" forKey:@"expand_4"];
                break;
            case PaymentTypeAlipay:
                //支付类型 1在线支付
                [tempParams setObject:@"1" forKey:@"expand_4"];
                break;
            case PaymentTypePayCrads:
                //支付类型 3，储蓄卡支付
                [tempParams setObject:@"3" forKey:@"expand_4"];
                CGFloat totalPrice = [QSPShoppingCarData getTotalPrice];
                CGFloat userBalance = userModel.balance.floatValue;
                if (totalPrice > userBalance) {
                    
                    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的储值卡余额不足以支付当前订单，请选择其他支付方式" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertview show];
                    ///隐藏HUD
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    return;
                }
                
                break;
            default:
                break;
        }
        
        ///生成订单
        [QSRequestManager requestDataWithType:rRequestTypeAddOrder andParams:tempParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///隐藏HUD
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            ///订单生成成功
            if (rRequestResultTypeSuccess == resultStatus) {
                
                ///设置参数
                QSAddOrderReturnData *tempReturnModel = resultData;
                
                QSOrderInfoDataModel *orderFormModel = tempReturnModel.orderInfoList[0];
                NSLog(@"订单ID :%@ 订单号：%@ 提交成功！",orderFormModel.order_id,orderFormModel.order_num);
                
                switch (selectedPayment) {
                    case PaymentTypePayForAfter:
                    {
                        QSPOrderSubmitedStateViewController *ossVc = [[QSPOrderSubmitedStateViewController alloc] init];
                        [ossVc setPaymentSate:YES];
                        QSOrderDetailDataModel *orderResultData = [[QSOrderDetailDataModel alloc] init];
                        orderResultData.order_id = orderFormModel.order_id;
                        orderResultData.order_desc = @"货到付款下单";
                        [ossVc setOrderData:orderResultData];
                        [self.navigationController pushViewController:ossVc animated:YES];
                        //支付类型 2餐到付款
                        [QSPShoppingCarData clearShoopingCar];
                    }
                        break;
                    case PaymentTypeAlipay:
                        //支付类型 1在线支付
                        {
                            //订单标题
                            orderFormModel.orderTitle = [NSString stringWithFormat:@"订单:%@",orderFormModel.order_num];

                            //订单描述
                            orderFormModel.des = [NSString stringWithFormat:@"在线支付订单:%@",orderFormModel.order_num];

                            //支付金额
                            orderFormModel.payPrice = [NSString stringWithFormat:@"%.2f",[QSPShoppingCarData getTotalPrice]];

                            //回调
                            __block NSString *orderID = orderFormModel.order_id;
                            __weak QSPOrderViewController *weakSelf = self;
                            orderFormModel.alixpayCallBack = ^(NSString *payCode,NSString *payInfo){
                                
                                //处理支付宝的回调结果
                                [weakSelf checkPayResultWithCode:payCode andPayResultInfo:payInfo andOrderID:orderID];
                                
                            };

                            //进入支付宝
                            [[QSAlixPayManager shareAlixPayManager] startAlixPay:orderFormModel];
                            
                            [QSPShoppingCarData clearShoopingCar];
                        }
                        break;
                    case PaymentTypePayCrads:
                        //支付类型 3，储蓄卡支付
                        {
                            QSPPayForOrderViewController *pfovc = [[QSPPayForOrderViewController alloc] init];
                            //支付金额
                            orderFormModel.payPrice = [NSString stringWithFormat:@"%.2f",[QSPShoppingCarData getTotalPrice]];
                            orderFormModel.diet_num = [NSString stringWithFormat:@"%ld",(long)[QSPShoppingCarData getTotalFoodCount]];
                            [pfovc setOrderFormModel:orderFormModel];
                            [self.navigationController pushViewController:pfovc animated:YES];
                            [QSPShoppingCarData clearShoopingCar];
                        }
                        break;
                    default:
                        break;
                }
                
            } else {
                
                switch (selectedPayment) {
                    case PaymentTypePayForAfter:
                    {
                        //支付类型 2餐到付款
                    }
                        break;
                    case PaymentTypeAlipay:
                        //支付类型 1在线支付
                        
                        break;
                    case PaymentTypePayCrads:
                        //支付类型 3，储蓄卡支付
                        {
                        }
                        break;
                    default:
                        break;
                }
                
                ///弹出提示
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"提交订单失败，请稍后再试……！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                
                ///显示1秒后移除提示
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [alert dismissWithClickedButtonIndex:0 animated:YES];
                    
                });

            }
            
        }];
        
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
    
    //判断有没有地址
    if (!self.orderName || !self.orderAddress || !self.orderPhone || [self.orderName isEqualToString:@""] || [self.orderAddress isEqualToString:@""] || [self.orderPhone isEqualToString:@""]) {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请添加您的送餐地址" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertview show];
        flag = NO;
        return flag;
    }
    
    DeliveryTimeType currentSelectTime = [self.deliveryTimeView getSelectedDeliveryTime];
    if (currentSelectTime == DeliveryTimeTypeNoSelected) {
        
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择送餐时间" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertview show];
        flag = NO;
        return flag;
    }
    
    PaymentType currentSelectPayment = [_paymentView getSelectedPayment];
    
    if (currentSelectPayment == PaymentTypeNoPayment) {
        
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择支付方式" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertview show];
        flag = NO;
        return flag;
        
    }
    
    return flag;
    
}



#pragma mark - QSPOrderAddNewAddressViewDelegate 响应处理
/**
 *  接受添加地址信息
 *
 *  @param data NSDictionary:
 
 {
 address = 地址;
 company = 公司;
 name = 姓名;
 phone = 电话号码;
 sex = 性别;
 }
 
 */
- (void)AddNewAddressWithData:(NSDictionary *)data
{
    
    NSLog(@"添加新地址：%@",data);
    
    self.orderName = [NSString stringWithFormat:@"%@%@",[data objectForKey:@"name"],[data objectForKey:@"sex"]];
    self.orderAddress = [data objectForKey:@"address"];
    self.orderPhone = [data objectForKey:@"phone"];
    [_shipToPersonName setText:[NSString stringWithFormat:@"%@  %@",self.orderName, self.orderPhone]];
    [_shipToAddress setText:self.orderAddress];
    
}

- (void)closeAddNewAddressView
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 请求优惠券列表
///获取个人优惠券列表
- (void)getUserCouponList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ///请求第一页数据
    [QSRequestManager requestDataWithType:rRequestTypeUserCouponList andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///清空原数据
        self.couponList = [NSArray array];
        ///获取成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///转换模型
            QSUserCouponListReturnData *couponData = resultData;
            
            if ([couponData.couponListHeader.couponList count] > 0) {
                
                self.couponList = [NSArray arrayWithArray:couponData.couponListHeader.couponList];
            }
        }
        
        [self updateSpecialOfferCount];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}


#pragma mark - 支付宝支付时的回调处理
/**
 *  @author         yangshengmeng, 15-02-26 14:02:38
 *
 *  @brief          支付宝支付时的回调处理
 *
 *  @param payCode  支付结果的编码
 *  @param payInfo  支付结果说明
 *
 *  @since          1.0.0
 */
- (void)checkPayResultWithCode:(NSString *)payCode andPayResultInfo:(NSString *)payInfo andOrderID:(NSString *)orderID
{
    
    ///将支付回调的代码，转换为整数代码
    int resultCode = [payCode intValue];
    
    /**
     *                  9000---订单支付成功
     *                  8000---正在处理中
     *                  4000---订单支付失败
     *                  6001---用户中途取消
     *                  6002---网络连接出错
     */
    
    ///支付成功回调：进入支付成功页面
    if (resultCode == 9000) {
        
        ///确认参数
        NSDictionary *tempParams = @{@"id" : orderID,
                                     @"type" : @"1",
                                     @"is_pay" : @"1",
                                     @"desc" : @"点餐下单支付确认"};
        
        ///回调服务端确认支付
        [QSRequestManager requestDataWithType:rRequestTypeCommitOrderPayResult andParams:tempParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///移聊HUD
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            QSPOrderSubmitedStateViewController *ossVc = [[QSPOrderSubmitedStateViewController alloc] init];
            [ossVc setPaymentSate:YES];
            QSOrderDetailDataModel *orderResultData = [[QSOrderDetailDataModel alloc] init];
            orderResultData.order_id = [tempParams objectForKey:@"id"];
            orderResultData.order_desc = [tempParams objectForKey:@"desc"];
            [ossVc setOrderData:orderResultData];
            [self.navigationController pushViewController:ossVc animated:YES];
            
        }];
        
        return;
        
    }
    
    ///支付回调：正在处理中
    if (resultCode == 8000) {
        
        ///确认参数
        NSDictionary *tempParams = @{@"id" : orderID,
                                     @"type" : @"1",
                                     @"is_pay" : @"0",
                                     @"desc" : @"点餐下单支付确认"};
        
        ///回调服务端确认支付
        [QSRequestManager requestDataWithType:rRequestTypeCommitOrderPayResult andParams:tempParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///移聊HUD
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            QSPOrderSubmitedStateViewController *ossVc = [[QSPOrderSubmitedStateViewController alloc] init];
            [ossVc setPaymentSate:YES];
            QSOrderDetailDataModel *orderResultData = [[QSOrderDetailDataModel alloc] init];
            orderResultData.order_id = [tempParams objectForKey:@"id"];
            orderResultData.order_desc = [tempParams objectForKey:@"desc"];
            [ossVc setOrderData:orderResultData];
            [self.navigationController pushViewController:ossVc animated:YES];

            
        }];
        
        return;
        
    }
    
    ///移聊HUD
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    ///支付失败
    QSPOrderSubmitedStateViewController *ossVc = [[QSPOrderSubmitedStateViewController alloc] init];
    [ossVc setPaymentSate:NO];
    QSOrderDetailDataModel *orderResultData = [[QSOrderDetailDataModel alloc] init];
    orderResultData.order_id = orderID;
    orderResultData.order_desc = @"点餐下单支付确认";
    [ossVc setOrderData:orderResultData];
    [self.navigationController pushViewController:ossVc animated:YES];
    
}

#pragma mark - 选择支付方式响应
- (void)clickedItemWithType:(PaymentType)type WithOrderPaymentView:(QSPOrderPaymentView*)view
{
    if (type==PaymentTypePayCrads) {
        CGFloat totalPrice = [QSPShoppingCarData getTotalPrice];
        ///用户信息模型
        QSUserInfoDataModel *userModel = [QSUserInfoDataModel userDataModel];
        CGFloat userBalance = userModel.balance.floatValue;
        if (totalPrice > userBalance) {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的储值卡余额不足以支付当前订单，请选择其他支付方式" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertview show];
            [view setSelectedPayment:PaymentTypeNoPayment];
        }
    }
}

#pragma mark - 将要显示时，设置tabbar隐藏
///将要显示时，设置tabbar隐藏
- (void)viewWillAppear:(BOOL)animated
{
    
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:animated];
    
}

@end
