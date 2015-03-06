//
//  QSOrderDetailViewController.m
//  suntry
//
//  Created by CoolTea on 15/2/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderDetailViewController.h"
#import "QSBlockButton.h"
#import "ImageHeader.h"
#import "QSLabel.h"
#import "DeviceSizeHeader.h"
#import "NSString+Calculation.h"
#import "MBProgressHUD.h"
#import "QSRequestManager.h"
#import "QSUserInfoDataModel.h"
#import "QSOrderDetailReturnData.h"
#import "QSOrderDetailDataModel.h"
#import "NSString+Calculation.h"
#import "QSPShoppingCarView.h"
#import "QSPPayForOrderViewController.h"
#import "QSAlixPayManager.h"
#import "QSPOrderSubmitedStateViewController.h"
#import "QRCodeGenerator.h"

#define ORDER_DETAIL_TOP_VIEW_QR_CODE_SIZE              140.
#define ORDER_DETAIL_TOP_VIEW_LINE_COLOR                [UIColor colorWithRed:206/255. green:208/255. blue:210/255. alpha:1]
#define ORDER_DETAIL_TOP_VIEW_BG_COLOR                  [UIColor colorWithRed:0.931 green:0.936 blue:0.936 alpha:1.000]
#define ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR        [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]
#define ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE        15.0
#define ORDER_DETAIL_TOP_VIEW_TOTAL_PRICE_TEXT_FONT_SIZE    17.0
#define ORDER_DETAIL_TOP_VIEW_TITLE_TEXT_COLOR          [UIColor blackColor]
#define ORDER_DETAIL_TOP_VIEW_NUMBER_TEXT_COLOR         [UIColor colorWithRed:0.503 green:0.183 blue:0.236 alpha:1.000]

@interface QSOrderDetailViewController ()

@property(nonatomic,strong) UIScrollView    *scrollView;
@property(nonatomic,strong) QSLabel         *orderNumLabel;
@property(nonatomic,strong) UIImageView     *orderQRCodeImgView;
@property(nonatomic,strong) QSLabel         *shippingStateLabel;

@property (nonatomic, strong) UIView  *hadOrderFrameView;
@property (nonatomic, strong) QSLabel *hadOrderTotalCountLabel;

@property (nonatomic, strong) UIView  *shippingInfoFrameView;
@property (nonatomic, strong) QSLabel *userNameLabel;
@property (nonatomic, strong) QSLabel *phoneLabel;
@property (nonatomic, strong) QSLabel *addressLabel;
@property (nonatomic, strong) QSLabel *companyLabel;
@property (nonatomic, strong) UIView *lineAddressView;
@property (nonatomic, strong) QSLabel *remarkTipLabel;
@property (nonatomic, strong) UIView *lineRemarkView;
@property (nonatomic, strong) UILabel *remarkLabel;

@property (nonatomic, strong) UIView  *payInfoFrameView;
@property (nonatomic, strong) QSLabel *payStateLabel;
@property (nonatomic, strong) QSLabel *paymentLabel;
@property (nonatomic, strong) QSLabel *totalPriceLabel;
@property (nonatomic, strong) UIButton *payBt;

@end

@implementation QSOrderDetailViewController
@synthesize orderData, order_ID;

- (void)loadView
{
    
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"订单详情"];
    self.navigationItem.titleView = navTitle;
    
    QSBlockButtonStyleModel *backButtonStyle = [[QSBlockButtonStyleModel alloc] init];
    [backButtonStyle setImagesNormal:IMAGE_NAVIGATIONBAR_BACK_NORMAL];
    [backButtonStyle setImagesHighted:IMAGE_NAVIGATIONBAR_MEINFO_HIGHLIGHTED];
    
    UIButton *backButton = [UIButton createBlockButtonWithFrame:CGRectMake(0, 0, 44, 44) andButtonStyle:backButtonStyle andCallBack:^(UIButton *button) {
        
//        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    CGFloat offetY = 0;
    if ([[UIDevice currentDevice].systemVersion doubleValue] == 7.0) {
        offetY = 64;
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-44-20+offetY)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_scrollView];
    
    //顶部
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, 208)];
    [topView setBackgroundColor:ORDER_DETAIL_TOP_VIEW_BG_COLOR];
    [_scrollView addSubview:topView];
    
    self.orderNumLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0, 12, SIZE_DEVICE_WIDTH, 20)];
    [self.orderNumLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [self.orderNumLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE ]];
    if (orderData) {
        
        [self.orderNumLabel setText:[NSString stringWithFormat:@"订单号:%@",orderData.order_num]];
        
    }
    [self.orderNumLabel setBackgroundColor:[UIColor clearColor]];
    [self.orderNumLabel setTextAlignment:NSTextAlignmentCenter];
    [topView addSubview:self.orderNumLabel];
    
    ///二维码
    self.orderQRCodeImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH-ORDER_DETAIL_TOP_VIEW_QR_CODE_SIZE)/2, self.orderNumLabel.frame.origin.y+self.orderNumLabel.frame.size.height+4, ORDER_DETAIL_TOP_VIEW_QR_CODE_SIZE, ORDER_DETAIL_TOP_VIEW_QR_CODE_SIZE)];
    UIImage *image = [QRCodeGenerator qrImageForString:self.orderData.verification imageSize:120];
    self.orderQRCodeImgView.image = image;
    [topView addSubview:self.orderQRCodeImgView];
    
    self.shippingStateLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0, self.orderQRCodeImgView.frame.origin.y+self.orderQRCodeImgView.frame.size.height+4, SIZE_DEVICE_WIDTH, 20)];
    [self.shippingStateLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [self.shippingStateLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE ]];
    if (orderData) {
        [self.shippingStateLabel setText:orderData.order_shippingState];
    }
    [self.shippingStateLabel setBackgroundColor:[UIColor clearColor]];
    [self.shippingStateLabel setTextAlignment:NSTextAlignmentCenter];
    [topView addSubview:self.shippingStateLabel];
    
    //菜单详情
    self.hadOrderFrameView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.frame.origin.y+topView.frame.size.height, SIZE_DEVICE_WIDTH, 45)];
    [_hadOrderFrameView setBackgroundColor:[UIColor clearColor]];
    [_hadOrderFrameView setClipsToBounds:YES];
    [_scrollView addSubview:_hadOrderFrameView];
    
    QSLabel *hadOrderTip = [[QSLabel alloc] initWithFrame:CGRectMake(12, 0, SIZE_DEVICE_WIDTH-24, 44)];
    [hadOrderTip setFont:[UIFont boldSystemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
    [hadOrderTip setText:@"菜单详情"];
    [hadOrderTip setTextColor:[UIColor blackColor]];
    [_hadOrderFrameView addSubview:hadOrderTip];
    
    self.hadOrderTotalCountLabel = [[QSLabel alloc] initWithFrame:hadOrderTip.frame];
    [self.hadOrderTotalCountLabel setFont:[UIFont boldSystemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
    [self.hadOrderTotalCountLabel setTextAlignment:NSTextAlignmentRight];
    [self.hadOrderTotalCountLabel setTextColor:[UIColor blackColor]];
    [_hadOrderFrameView addSubview:self.hadOrderTotalCountLabel];
    NSString *totalCountStr = @"0";
    NSMutableAttributedString *totalString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计%@份",totalCountStr]];
    [totalString addAttribute:NSForegroundColorAttributeName value:ORDER_DETAIL_TOP_VIEW_NUMBER_TEXT_COLOR range:NSMakeRange(2,totalCountStr.length)];
    [totalString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE] range:NSMakeRange(2, totalCountStr.length)];
    [self.hadOrderTotalCountLabel setAttributedText:totalString];
    
    UIView *lineButtomView = [[UIView alloc] initWithFrame:CGRectMake(12, hadOrderTip.frame.origin.y+hadOrderTip.frame.size.height, SIZE_DEVICE_WIDTH-24, 1)];
    [lineButtomView setBackgroundColor:ORDER_DETAIL_TOP_VIEW_LINE_COLOR];
    [_hadOrderFrameView addSubview:lineButtomView];
    
    [_hadOrderFrameView setFrame:CGRectMake(_hadOrderFrameView.frame.origin.x, _hadOrderFrameView.frame.origin.y, _hadOrderFrameView.frame.size.width, lineButtomView.frame.origin.y+lineButtomView.frame.size.height)];
    
    //配送信息
    self.shippingInfoFrameView = [[UIView alloc] initWithFrame:CGRectMake(_hadOrderFrameView.frame.origin.x, _hadOrderFrameView.frame.origin.y+_hadOrderFrameView.frame.size.height, SIZE_DEVICE_WIDTH, 45)];
    [self.shippingInfoFrameView setBackgroundColor:[UIColor clearColor]];
    [self.shippingInfoFrameView setClipsToBounds:YES];
    [_scrollView addSubview:self.shippingInfoFrameView];
    
    QSLabel *shippingTip = [[QSLabel alloc] initWithFrame:CGRectMake(12, 0, SIZE_DEVICE_WIDTH-24, 44)];
    [shippingTip setFont:[UIFont boldSystemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
    [shippingTip setText:@"配送信息"];
    [shippingTip setTextColor:[UIColor blackColor]];
    [_shippingInfoFrameView addSubview:shippingTip];
    
    UIView *lineShippingView = [[UIView alloc] initWithFrame:CGRectMake(12, shippingTip.frame.origin.y+shippingTip.frame.size.height, SIZE_DEVICE_WIDTH-24, 1)];
    [lineShippingView setBackgroundColor:ORDER_DETAIL_TOP_VIEW_LINE_COLOR];
    [_shippingInfoFrameView addSubview:lineShippingView];
    
    QSLabel *userNameTipLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, 44, SIZE_DEVICE_WIDTH-24, 44)];
    [userNameTipLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
    [userNameTipLabel setText:@"联系人："];
    [userNameTipLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [_shippingInfoFrameView addSubview:userNameTipLabel];
    
    self.userNameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(userNameTipLabel.frame.origin.x+70, userNameTipLabel.frame.origin.y, userNameTipLabel.frame.size.width-70, userNameTipLabel.frame.size.height)];
    
    [self.userNameLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
    if (orderData) {
        
        [self.userNameLabel setText:orderData.order_name];
        
    }
    [self.userNameLabel setTextAlignment:NSTextAlignmentRight];
    [self.userNameLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [_shippingInfoFrameView addSubview:self.userNameLabel];
    
    UIView *lineUserNameView = [[UIView alloc] initWithFrame:CGRectMake(12, self.userNameLabel.frame.origin.y+self.userNameLabel.frame.size.height, SIZE_DEVICE_WIDTH-24, 1)];
    [lineUserNameView setBackgroundColor:ORDER_DETAIL_TOP_VIEW_LINE_COLOR];
    [_shippingInfoFrameView addSubview:lineUserNameView];
    
    QSLabel *phoneTipLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, 44+45, SIZE_DEVICE_WIDTH-24, 44)];
    [phoneTipLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
    [phoneTipLabel setText:@"联系电话："];
    [phoneTipLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [_shippingInfoFrameView addSubview:phoneTipLabel];
    
    self.phoneLabel = [[QSLabel alloc] initWithFrame:CGRectMake(phoneTipLabel.frame.origin.x+70, phoneTipLabel.frame.origin.y, phoneTipLabel.frame.size.width-70, phoneTipLabel.frame.size.height)];
    [self.phoneLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
    if (orderData) {
        [self.phoneLabel setText:orderData.order_phone];
    }
    [self.phoneLabel setTextAlignment:NSTextAlignmentRight];
    [self.phoneLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [_shippingInfoFrameView addSubview:self.phoneLabel];
    
    UIView *linePhoneView = [[UIView alloc] initWithFrame:CGRectMake(12, self.phoneLabel.frame.origin.y+self.phoneLabel.frame.size.height, SIZE_DEVICE_WIDTH-24, 1)];
    [linePhoneView setBackgroundColor:ORDER_DETAIL_TOP_VIEW_LINE_COLOR];
    [_shippingInfoFrameView addSubview:linePhoneView];
    
    QSLabel *addressTipLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, 44+2*45, SIZE_DEVICE_WIDTH-24, 44)];
    [addressTipLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
    [addressTipLabel setText:@"送餐地址："];
    [addressTipLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [_shippingInfoFrameView addSubview:addressTipLabel];
    
    self.addressLabel = [[QSLabel alloc] initWithFrame:CGRectMake(addressTipLabel.frame.origin.x+70, addressTipLabel.frame.origin.y, addressTipLabel.frame.size.width-70, addressTipLabel.frame.size.height)];
    [self.addressLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
    if (orderData) {
        [self.addressLabel setText:orderData.order_address];
    }
    [self.addressLabel setTextAlignment:NSTextAlignmentRight];
    [self.addressLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [_shippingInfoFrameView addSubview:self.addressLabel];
    
    self.companyLabel = [[QSLabel alloc] initWithFrame:CGRectMake(self.addressLabel.frame.origin.x, self.addressLabel.frame.origin.y+18, self.addressLabel.frame.size.width, self.addressLabel.frame.size.height)];
    [self.companyLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
    [self.companyLabel setTextAlignment:NSTextAlignmentRight];
    [self.companyLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [_shippingInfoFrameView addSubview:self.companyLabel];
    [self.companyLabel setHidden:YES];
    
    self.lineAddressView = [[UIView alloc] initWithFrame:CGRectMake(12, self.addressLabel.frame.origin.y+self.addressLabel.frame.size.height, SIZE_DEVICE_WIDTH-24, 1)];
    [self.lineAddressView setBackgroundColor:ORDER_DETAIL_TOP_VIEW_LINE_COLOR];
    [_shippingInfoFrameView addSubview:self.lineAddressView];
    
    self.remarkTipLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, self.lineAddressView.frame.origin.y, SIZE_DEVICE_WIDTH-24, 44)];
    [self.remarkTipLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
    [self.remarkTipLabel setText:@"备注："];
    [self.remarkTipLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [_shippingInfoFrameView addSubview:self.remarkTipLabel];
    
    self.remarkLabel = [[UILabel
                         alloc] initWithFrame:CGRectMake(self.remarkTipLabel.frame.origin.x+50, self.remarkTipLabel.frame.origin.y, self.remarkTipLabel.frame.size.width-50, self.remarkTipLabel.frame.size.height)];
    [self.remarkLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
    if (orderData) {
        [self.remarkLabel setText:orderData.order_desc];
    }
    [self.remarkLabel setTextAlignment:NSTextAlignmentRight];
    [self.remarkLabel setNumberOfLines:0];
    [self.remarkLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [_shippingInfoFrameView addSubview:self.remarkLabel];
    
    self.lineRemarkView = [[UIView alloc] initWithFrame:CGRectMake(12, self.remarkLabel.frame.origin.y+self.remarkLabel.frame.size.height, SIZE_DEVICE_WIDTH-24, 1)];
    [self.lineRemarkView setBackgroundColor:ORDER_DETAIL_TOP_VIEW_LINE_COLOR];
    [_shippingInfoFrameView addSubview:self.lineRemarkView];
    
    [_shippingInfoFrameView setFrame:CGRectMake(_shippingInfoFrameView.frame.origin.x, _shippingInfoFrameView.frame.origin.y, _shippingInfoFrameView.frame.size.width, self.lineRemarkView.frame.origin.y+self.lineRemarkView.frame.size.height)];
    
    
    //付款信息
    self.payInfoFrameView = [[UIView alloc] initWithFrame:CGRectMake(_shippingInfoFrameView.frame.origin.x, _shippingInfoFrameView.frame.origin.y+_shippingInfoFrameView.frame.size.height, SIZE_DEVICE_WIDTH, 45)];
    [self.payInfoFrameView setBackgroundColor:[UIColor clearColor]];
    [self.payInfoFrameView setClipsToBounds:YES];
    [_scrollView addSubview:self.payInfoFrameView];
    
    QSLabel *payInfoTip = [[QSLabel alloc] initWithFrame:CGRectMake(12, 0, SIZE_DEVICE_WIDTH-24, 44)];
    [payInfoTip setFont:[UIFont boldSystemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
    [payInfoTip setText:@"付款信息"];
    [payInfoTip setTextColor:[UIColor blackColor]];
    [_payInfoFrameView addSubview:payInfoTip];
    
    self.payStateLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, 0, SIZE_DEVICE_WIDTH-24, 44)];
    [self.payStateLabel setFont:[UIFont boldSystemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
    [self.payStateLabel setTextAlignment:NSTextAlignmentRight];
    [self.payStateLabel setTextColor:ORDER_DETAIL_TOP_VIEW_NUMBER_TEXT_COLOR];
    [_payInfoFrameView addSubview:self.payStateLabel];
    
    UIView *linePayInfoView = [[UIView alloc] initWithFrame:CGRectMake(12, payInfoTip.frame.origin.y+payInfoTip.frame.size.height, SIZE_DEVICE_WIDTH-24, 1)];
    [linePayInfoView setBackgroundColor:ORDER_DETAIL_TOP_VIEW_LINE_COLOR];
    [_payInfoFrameView addSubview:linePayInfoView];
    
    QSLabel *paymentTipLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, 44, SIZE_DEVICE_WIDTH-24, 44)];
    [paymentTipLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
    [paymentTipLabel setText:@"付款方式："];
    [paymentTipLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [_payInfoFrameView addSubview:paymentTipLabel];
    
    self.paymentLabel = [[QSLabel alloc] initWithFrame:paymentTipLabel.frame];
    [self.paymentLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
    if (orderData) {
        NSString *paymentCode = orderData.order_payment;
        //3，余额支付；1在线支付，2餐到付款 ,5 储蓄卡购买的支付类型
        NSString *paymentStr = @"";
        if ([paymentCode isEqualToString:@"1"])
        {
            paymentStr = @"在线支付";
        }else if ([paymentCode isEqualToString:@"2"])
        {
            paymentStr = @"货到付款";
        }else if ([paymentCode isEqualToString:@"3"])
        {
//            paymentStr = @"余额支付";
            paymentStr = @"储值卡支付";
        }else if ([paymentCode isEqualToString:@"5"])
        {
//            paymentStr = @"储蓄卡购买";
            paymentStr = @"在线支付";
        }
        [self.paymentLabel setText:paymentStr];
    }
    [self.paymentLabel setTextAlignment:NSTextAlignmentRight];
    [self.paymentLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [_payInfoFrameView addSubview:self.paymentLabel];
    
    UIView *linePaymentView = [[UIView alloc] initWithFrame:CGRectMake(12, self.paymentLabel.frame.origin.y+self.paymentLabel.frame.size.height, SIZE_DEVICE_WIDTH-24, 1)];
    [linePaymentView setBackgroundColor:ORDER_DETAIL_TOP_VIEW_LINE_COLOR];
    [_payInfoFrameView addSubview:linePaymentView];
    

    self.totalPriceLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, 44+45, SIZE_DEVICE_WIDTH-24, 44)];
    [self.totalPriceLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_TOTAL_PRICE_TEXT_FONT_SIZE]];
    [self.totalPriceLabel setTextAlignment:NSTextAlignmentRight];
    [self.totalPriceLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [_payInfoFrameView addSubview:self.totalPriceLabel];
    if (orderData) {
        
        NSString *totalPriceStr = orderData.total_money;
        NSMutableAttributedString *totalPriceString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计 ￥%@",totalPriceStr]];
        [totalPriceString addAttribute:NSForegroundColorAttributeName value:ORDER_DETAIL_TOP_VIEW_NUMBER_TEXT_COLOR range:NSMakeRange(4,totalPriceStr.length)];
        [totalPriceString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE] range:NSMakeRange(4, totalPriceStr.length)];
        [self.totalPriceLabel setAttributedText:totalPriceString];

    }
    
    [_payInfoFrameView setFrame:CGRectMake(_payInfoFrameView.frame.origin.x, _payInfoFrameView.frame.origin.y, _payInfoFrameView.frame.size.width, self.totalPriceLabel.frame.origin.y+self.totalPriceLabel.frame.size.height)];
    
    //添加地址按钮
    QSBlockButtonStyleModel *submitBtStyleModel = [QSBlockButtonStyleModel alloc];
    submitBtStyleModel.bgColor  = [UIColor colorWithRed:0.471 green:0.176 blue:0.224 alpha:1.000];;
    submitBtStyleModel.title    = @"马上支付";
    submitBtStyleModel.titleNormalColor = [UIColor whiteColor];
    submitBtStyleModel.cornerRadio = 6.;
    self.payBt = [UIButton createBlockButtonWithFrame:CGRectMake(12, _payInfoFrameView.frame.origin.y+_payInfoFrameView.frame.size.height+30, SIZE_DEVICE_WIDTH-12*2, 44) andButtonStyle:submitBtStyleModel andCallBack:^(UIButton *button) {
        
        NSLog(@"payBt");
        [self continueToPay];
        
    }];
    [_scrollView addSubview:self.payBt];
    
    if (orderData) {
        NSString *ispayCode = orderData.is_pay;
        NSString *payStateStr = @"";
        if ([ispayCode isEqualToString:@"0"])
        {
            payStateStr = @"未付款";
            [self.payBt setHidden:NO];
        }else if ([ispayCode isEqualToString:@"1"])
        {
            payStateStr = @"已付款";
            [self.payBt setHidden:YES];
        }
        [self.payStateLabel setText:payStateStr];
    }
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _payBt.frame.origin.y+_payBt.frame.size.height+20)];
    
    [self getDetailData];
    
}

- (void)updateView
{
    [self updateHeadView];
    [self updateHadOrderView];
    [self updateShippingInfoView];
    [self updatePayInfoView];
}

- (void)updateHeadView
{
    if (orderData) {
        
        [self.orderNumLabel setText:[NSString stringWithFormat:@"订单号:%@",orderData.order_num]];
        UIImage *image = [QRCodeGenerator qrImageForString:self.orderData.verification imageSize:120];
        self.orderQRCodeImgView.image = image;
        [self.shippingStateLabel setText:orderData.order_shippingState];
    }
}

- (void)updatePayInfoView
{
    [self.paymentLabel setText:@""];
    [self.payStateLabel setText:@""];
    [self.payBt setHidden:YES];
    
    if (orderData) {
        
        BOOL supportPayOnline = NO;
        NSString *paymentCode = orderData.order_payment;
        //3，余额支付；1在线支付，2餐到付款 ,5 储蓄卡购买的支付类型
        NSString *paymentStr = @"";
        if ([paymentCode isEqualToString:@"1"])
        {
            paymentStr = @"在线支付";
            supportPayOnline = YES;
        }else if ([paymentCode isEqualToString:@"2"])
        {
            paymentStr = @"货到付款";
        }else if ([paymentCode isEqualToString:@"3"])
        {
//            paymentStr = @"余额支付";
            paymentStr = @"储值卡支付";
            supportPayOnline = YES;
        }else if ([paymentCode isEqualToString:@"5"])
        {
//            paymentStr = @"储蓄卡购买";
            paymentStr = @"在线支付";
        }
        [self.paymentLabel setText:paymentStr];
        
        NSString *ispayCode = orderData.is_pay;
        NSString *payStateStr = @"";
        if ([ispayCode isEqualToString:@"0"])
        {
            payStateStr = @"(未付款)";
            if (supportPayOnline) {
                [self.payBt setHidden:NO];
            }
        }else if ([ispayCode isEqualToString:@"1"])
        {
            payStateStr = @"(已付款)";
        }
        
        [self.payStateLabel setText:payStateStr];
        
        NSString *totalPriceStr = orderData.total_money;
        NSMutableAttributedString *totalPriceString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计 ￥%@",totalPriceStr]];
        [totalPriceString addAttribute:NSForegroundColorAttributeName value:ORDER_DETAIL_TOP_VIEW_NUMBER_TEXT_COLOR range:NSMakeRange(4,totalPriceStr.length)];
        [totalPriceString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE] range:NSMakeRange(4, totalPriceStr.length)];
        [self.totalPriceLabel setAttributedText:totalPriceString];
        
        //TODO: 优惠券数据更新
        NSArray *couponList = [NSArray array];
        CGFloat nextItemY = self.paymentLabel.frame.origin.y+self.paymentLabel.frame.size.height+1;
        if ([couponList count]>0) {
            
            QSLabel *couponTipLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, nextItemY, SIZE_DEVICE_WIDTH-24, 44)];
            [couponTipLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
            [couponTipLabel setText:@"使用优惠："];
            [couponTipLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
            [_payInfoFrameView addSubview:couponTipLabel];
            
            for (int i=0; i<[couponList count]; i++) {
                
                QSLabel *couponLabel = [[QSLabel alloc] initWithFrame:CGRectMake(couponTipLabel.frame.origin.x, nextItemY, couponTipLabel.frame.size.width, couponTipLabel.frame.size.height)];
                [couponLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
                [couponLabel setText:@"会员优惠30元现金券"];
                [couponLabel setTextAlignment:NSTextAlignmentRight];
                [couponLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
                [_payInfoFrameView addSubview:couponLabel];
                
                NSString *infoStr = @"(优惠减扣:￥30元)";
                
                if (infoStr&&![infoStr isEqualToString:@""]) {
                    
                    QSLabel *couponInfoLabel = [[QSLabel alloc] initWithFrame:CGRectMake(couponLabel.frame.origin.x, couponLabel.frame.origin.y+18, couponLabel.frame.size.width, couponLabel.frame.size.height)];
                    [couponInfoLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
                    [couponInfoLabel setText:infoStr];
                    [couponInfoLabel setTextAlignment:NSTextAlignmentRight];
                    [couponInfoLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
                    [_payInfoFrameView addSubview:couponInfoLabel];
                }
                nextItemY = couponLabel.frame.origin.y + couponLabel.frame.size.height;
                if ([couponList count]-1==i) {
                    nextItemY += 20;
                }
            }
            
            UIView *lineCouponView = [[UIView alloc] initWithFrame:CGRectMake(12, nextItemY, SIZE_DEVICE_WIDTH-24, 1)];
            [lineCouponView setBackgroundColor:ORDER_DETAIL_TOP_VIEW_LINE_COLOR];
            [_payInfoFrameView addSubview:lineCouponView];
            
            [_totalPriceLabel setFrame:CGRectMake(_totalPriceLabel.frame.origin.x, lineCouponView.frame.origin.y+lineCouponView.frame.size.height, _totalPriceLabel.frame.size.width, _totalPriceLabel.frame.size.height)];
            
            [_payInfoFrameView setFrame:CGRectMake(_payInfoFrameView.frame.origin.x, _payInfoFrameView.frame.origin.y, _payInfoFrameView.frame.size.width, _totalPriceLabel.frame.origin.y+_totalPriceLabel.frame.size.height)];
        }
    }

    [_payInfoFrameView setFrame:CGRectMake(_payInfoFrameView.frame.origin.x, _shippingInfoFrameView.frame.origin.y+_shippingInfoFrameView.frame.size.height, _payInfoFrameView.frame.size.width, _payInfoFrameView.frame.size.height)];
    
    [_payBt setFrame:CGRectMake(12, _payInfoFrameView.frame.origin.y+_payInfoFrameView.frame.size.height+30, SIZE_DEVICE_WIDTH-12*2, 44)];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _payBt.frame.origin.y+_payBt.frame.size.height+20)];
}

- (void)updateShippingInfoView
{
    
    NSString *nameStr = @"";
    [self.userNameLabel setText:nameStr];
    NSString *phone = @"";
    [self.phoneLabel setText:phone];
    
    [self.addressLabel setText:@""];
    
    NSString *company = @"";
    
    if (company && ![company isEqualToString:@""]) {
        [self.companyLabel setHidden:NO];
        [self.companyLabel setText:company];
        [self.lineAddressView setFrame:CGRectMake(self.lineAddressView.frame.origin.x, self.companyLabel.frame.origin.y+self.companyLabel.frame.size.height, self.lineAddressView.frame.size.width, self.lineAddressView.frame.size.height)];
    }else{
        [self.companyLabel setHidden:YES];
        [self.lineAddressView setFrame:CGRectMake(self.lineAddressView.frame.origin.x, self.addressLabel.frame.origin.y+self.addressLabel.frame.size.height, self.lineAddressView.frame.size.width, self.lineAddressView.frame.size.height)];
    }
    
    
    [self.remarkTipLabel setFrame:CGRectMake(self.remarkTipLabel.frame.origin.x, self.lineAddressView.frame.origin.y+self.lineAddressView.frame.size.height, self.remarkTipLabel.frame.size.width, self.remarkTipLabel.frame.size.height)];
    
    [self.remarkLabel setFrame:CGRectMake(self.remarkLabel.frame.origin.x, self.remarkTipLabel.frame.origin.y+12, self.remarkLabel.frame.size.width, 18)];
    
    [self.lineRemarkView setFrame:CGRectMake(self.lineRemarkView.frame.origin.x, self.remarkLabel.frame.origin.y+self.remarkLabel.frame.size.height, self.lineRemarkView.frame.size.width, self.lineRemarkView.frame.size.height)];
    
    [_shippingInfoFrameView setFrame:CGRectMake(_shippingInfoFrameView.frame.origin.x, _shippingInfoFrameView.frame.origin.y, _shippingInfoFrameView.frame.size.width, self.lineRemarkView.frame.origin.y+self.lineRemarkView.frame.size.height)];
    
    [self.remarkLabel setText:@""];
    
    if (orderData) {
        [self.shippingStateLabel setText:orderData.order_shippingState];
        [self.userNameLabel setText:orderData.order_name];
        [self.phoneLabel setText:orderData.order_phone];
        [self.addressLabel setText:orderData.order_address];
        
        NSString *remarkStr = orderData.order_desc;
        CGFloat strHeight = [remarkStr calculateStringDisplayHeightByFixedWidth:self.remarkLabel.frame.size.width andFontSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE];
        
        if (strHeight < self.remarkLabel.frame.size.height) {
            strHeight = self.remarkLabel.frame.size.height;
            [self.remarkLabel setTextAlignment:NSTextAlignmentRight];
        }else{
            [self.remarkLabel setTextAlignment:NSTextAlignmentLeft];
        }
        
        [self.remarkLabel setFrame:CGRectMake(self.remarkLabel.frame.origin.x, self.remarkTipLabel.frame.origin.y+12, self.remarkLabel.frame.size.width, strHeight)];
        
        [self.remarkLabel setText:remarkStr];
        [self.lineRemarkView setFrame:CGRectMake(self.lineRemarkView.frame.origin.x, self.remarkLabel.frame.origin.y+self.remarkLabel.frame.size.height+12, self.lineRemarkView.frame.size.width, self.lineRemarkView.frame.size.height)];
        
        [_shippingInfoFrameView setFrame:CGRectMake(_shippingInfoFrameView.frame.origin.x, _shippingInfoFrameView.frame.origin.y, _shippingInfoFrameView.frame.size.width, self.lineRemarkView.frame.origin.y+self.lineRemarkView.frame.size.height)];
    }
    
    [_shippingInfoFrameView setFrame:CGRectMake(_shippingInfoFrameView.frame.origin.x, _hadOrderFrameView.frame.origin.y+_hadOrderFrameView.frame.size.height, _shippingInfoFrameView.frame.size.width, _shippingInfoFrameView.frame.size.height)];
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _shippingInfoFrameView.frame.origin.y+_shippingInfoFrameView.frame.size.height)];
    
}

- (void)updateHadOrderView
{
    for (UIView *view in [_hadOrderFrameView subviews]) {
        if (view.tag/10000==1) {
            [view removeFromSuperview];
        }
    }
    [_hadOrderFrameView setFrame:CGRectMake(_hadOrderFrameView.frame.origin.x, _hadOrderFrameView.frame.origin.y, _hadOrderFrameView.frame.size.width, 45)];
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _hadOrderFrameView.frame.origin.y+_hadOrderFrameView.frame.size.height)];
    NSArray *foodList = [NSArray array];
    if (orderData) {
        foodList = orderData.goods_list;
    }
    if (!foodList) {
        foodList = [NSArray array];
    }
    NSInteger totalCount = 0;
    if ([foodList count]>0) {
        NSInteger countTag = 10001;
        for (int i=0; i<[foodList count]; i++) {
            QSOrderDetailGoodsDataModel *food = [foodList objectAtIndex:i];
            if (food) {
                NSString *foodNameStr = food.goodsName;
                NSString *perPriceStr = food.goodsPrice;
                NSString *countStr = food.goodsCount;
                totalCount += countStr.integerValue;
                NSString *showNameStr = [NSString stringWithFormat:@"%@ x %@",foodNameStr,countStr];
                CGFloat foodNameStrWidth = [showNameStr calculateStringDisplayWidthByFixedHeight:44. andFontSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]+4;
                QSLabel *foodNameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, 44+i*45, foodNameStrWidth, 44)];
                [foodNameLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
                [foodNameLabel setText:showNameStr];
                [foodNameLabel setBackgroundColor:[UIColor clearColor]];
                [foodNameLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
                [foodNameLabel setTag:countTag++];
                [_hadOrderFrameView addSubview:foodNameLabel];
                
                NSArray *subFoodList = food.subFoodList;
                if (subFoodList&&[subFoodList isKindOfClass:[NSArray class]]) {
                    for (int j=0; j<[subFoodList count]; j++) {
                        QSOrderDetailGoodsDataSubModel *subItem = [subFoodList objectAtIndex:j];
                        if (subItem) {
                            QSLabel *subfoodNameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(foodNameLabel.frame.origin.x+foodNameLabel.frame.size.width+4, 44+i*45+2+j*20, (SIZE_DEVICE_WIDTH*0.7-foodNameStrWidth), 20)];
                            [subfoodNameLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
                            [subfoodNameLabel setText:subItem.goodsName];
                            [subfoodNameLabel setBackgroundColor:[UIColor clearColor]];
                            [subfoodNameLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
                            [subfoodNameLabel setTag:countTag++];
                            [_hadOrderFrameView addSubview:subfoodNameLabel];
                        }
                    }
                }
                
                QSLabel *foodPerPriceLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, 44+i*45, SIZE_DEVICE_WIDTH-24, 44)];
                [foodPerPriceLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
                [foodPerPriceLabel setText:[NSString stringWithFormat:@"￥%@",perPriceStr]];
                [foodPerPriceLabel setTextAlignment:NSTextAlignmentRight];
                [foodPerPriceLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
                [foodPerPriceLabel setTag:countTag++];
                [_hadOrderFrameView addSubview:foodPerPriceLabel];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, foodNameLabel.frame.origin.y+foodNameLabel.frame.size.height, SIZE_DEVICE_WIDTH-24, 1)];
                [lineView setBackgroundColor:ORDER_DETAIL_TOP_VIEW_LINE_COLOR];
                [lineView setTag:countTag++];
                [_hadOrderFrameView addSubview:lineView];
                
                [_hadOrderFrameView setFrame:CGRectMake(_hadOrderFrameView.frame.origin.x, _hadOrderFrameView.frame.origin.y, _hadOrderFrameView.frame.size.width, lineView.frame.origin.y+lineView.frame.size.height)];
            }
        }
    }
    
    NSString *totalCountStr = [NSString stringWithFormat:@"%ld",(long)totalCount];
    NSMutableAttributedString *totalString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计%@份",totalCountStr]];
    [totalString addAttribute:NSForegroundColorAttributeName value:ORDER_DETAIL_TOP_VIEW_NUMBER_TEXT_COLOR range:NSMakeRange(2,totalCountStr.length)];
    [totalString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE] range:NSMakeRange(2, totalCountStr.length)];
    [self.hadOrderTotalCountLabel setAttributedText:totalString];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _hadOrderFrameView.frame.origin.y+_hadOrderFrameView.frame.size.height)];
    
}

- (void)viewWillAppear:(BOOL)animated
{

//    self.navigationController.navigationBar.hidden = NO;
    [super viewWillAppear:animated];

}

- (void)getDetailData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //请求所需参数
    NSMutableDictionary *tempParams = [[NSMutableDictionary alloc] init];

    //用户信息模型
    QSUserInfoDataModel *userModel = [QSUserInfoDataModel userDataModel];
    //user_id 用户id 必填
    [tempParams setObject:userModel.userID forKey:@"user_id"];
    //id  订单id
    [tempParams setObject:@"" forKey:@"id"];
    if (orderData) {
        [tempParams setObject:orderData.order_id forKey:@"id"];
    }else if (order_ID) {
        [tempParams setObject:order_ID forKey:@"id"];
    }else{
        //
        ///弹出提示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取订单详情失败，请稍后再试。" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        
        ///显示1秒后移除提示
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderDetailData andParams:tempParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        
        //成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSOrderDetailReturnData *tempReturnModel = resultData;
            orderData = tempReturnModel.orderDetailData;
            NSLog(@"tempReturnModel %@",orderData);
            
            [self updateView];
        }else{
            ///弹出提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取订单详情失败，请稍后再试……！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            
            ///显示1秒后移除提示
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                
            });
        }
        
        //隐藏HUD
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)continueToPay
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (orderData) {

        NSString *paymentCode = orderData.order_payment;
        //3，余额支付；1在线支付，2餐到付款 ,5 储蓄卡购买的支付类型
        NSString *paymentStr = @"";
        if ([paymentCode isEqualToString:@"1"])
        {
            paymentStr = @"在线支付";//支付宝支付
            
            QSOrderInfoDataModel *orderInfoModel = [[QSOrderInfoDataModel alloc] init];
            //订单标题
            orderInfoModel.orderTitle = [NSString stringWithFormat:@"继续订单:%@",orderData.order_num];
            //订单描述
            orderInfoModel.des = [NSString stringWithFormat:@"继续支付订单:%@",orderData.order_num];
            //支付金额
            orderInfoModel.payPrice =  orderData.total_money;
            
            orderInfoModel.order_id = orderData.order_id;
            orderInfoModel.bill_id = orderData.bill_id;
            orderInfoModel.order_num = orderData.order_num;
            orderInfoModel.bill_num = @"";//订单数据没这个字段。
            
            //回调
            __block NSString *orderID = orderData.order_id;
            __weak QSOrderDetailViewController *weakSelf = self;
            orderInfoModel.alixpayCallBack = ^(NSString *payCode,NSString *payInfo){
                
                //处理支付宝的回调结果
                [weakSelf checkPayResultWithCode:payCode andPayResultInfo:payInfo andOrderID:orderID];
                
            };
            
            //进入支付宝
            [[QSAlixPayManager shareAlixPayManager] startAlixPay:orderInfoModel];
            
        }else if ([paymentCode isEqualToString:@"2"])
        {
            
        }else if ([paymentCode isEqualToString:@"3"])
        {
            paymentStr = @"储值卡支付";//储值卡支付
            
            QSUserInfoDataModel *userModel = [QSUserInfoDataModel userDataModel];
            CGFloat totalPrice = [QSPShoppingCarData getTotalPrice];
            CGFloat userBalance = userModel.balance.floatValue;
            if (totalPrice > userBalance) {
                
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的储值卡余额不足以支付当前订单，请选择其他支付方式" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertview show];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                return;
            } else {
                
                QSPPayForOrderViewController *pfovc = [[QSPPayForOrderViewController alloc] init];
                QSOrderInfoDataModel *orderInfoModel = [[QSOrderInfoDataModel alloc] init];
                orderInfoModel.order_id = orderData.order_id;
                orderInfoModel.bill_id = orderData.bill_id;
                orderInfoModel.order_num = orderData.order_num;
                orderInfoModel.bill_num = @"";//订单数据没这个字段。
                orderInfoModel.payPrice = orderData.total_money;
                orderInfoModel.diet_num = orderData.diet_num;
                [pfovc setOrderFormModel:orderInfoModel];
                [self.navigationController pushViewController:pfovc animated:YES];
            }
            
        }
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
