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
@property (nonatomic, strong) QSLabel *remarkLabel;

@property (nonatomic, strong) UIView  *payInfoFrameView;
@property (nonatomic, strong) QSLabel *payStateLabel;
@property (nonatomic, strong) QSLabel *paymentLabel;
@property (nonatomic, strong) QSLabel *totalPriceLabel;
@property (nonatomic, strong) UIButton *payBt;

@end

@implementation QSOrderDetailViewController
@synthesize orderData;

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
        [self.navigationController popViewControllerAnimated:YES];;
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-44-20)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
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
    
    self.orderQRCodeImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH-ORDER_DETAIL_TOP_VIEW_QR_CODE_SIZE)/2, self.orderNumLabel.frame.origin.y+self.orderNumLabel.frame.size.height+4, ORDER_DETAIL_TOP_VIEW_QR_CODE_SIZE, ORDER_DETAIL_TOP_VIEW_QR_CODE_SIZE)];
    [self.orderQRCodeImgView setBackgroundColor:[UIColor clearColor]];
    [topView addSubview:self.orderQRCodeImgView];
    
    self.shippingStateLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0, self.orderQRCodeImgView.frame.origin.y+self.orderQRCodeImgView.frame.size.height+4, SIZE_DEVICE_WIDTH, 20)];
    [self.shippingStateLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [self.shippingStateLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE ]];
    if (orderData) {
        [self.shippingStateLabel setText:@"未配送（未配送无法查看车车在哪里儿）"];
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
//    [self.hadOrderTotalCountLabel setText:@"总共0份"];
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
//    [self.companyLabel setText:@"七升"];
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
    
    self.remarkLabel = [[QSLabel alloc] initWithFrame:CGRectMake(self.remarkTipLabel.frame.origin.x+50, self.remarkTipLabel.frame.origin.y, self.remarkTipLabel.frame.size.width-50, self.remarkTipLabel.frame.size.height)];
    [self.remarkLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
//    [self.remarkLabel setText:@"无备注信息"];
    if (orderData) {
        [self.remarkLabel setText:orderData.order_desc];
    }
    [self.remarkLabel setTextAlignment:NSTextAlignmentRight];
    [self.remarkLabel setNumberOfLines:2];
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
            paymentStr = @"餐到付款";
        }else if ([paymentCode isEqualToString:@"3"])
        {
            paymentStr = @"余额支付";
        }else if ([paymentCode isEqualToString:@"5"])
        {
            paymentStr = @"储蓄卡购买";
        }
        [self.paymentLabel setText:paymentStr];
    }
    [self.paymentLabel setTextAlignment:NSTextAlignmentRight];
    [self.paymentLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [_payInfoFrameView addSubview:self.paymentLabel];
    
    UIView *linePaymentView = [[UIView alloc] initWithFrame:CGRectMake(12, self.paymentLabel.frame.origin.y+self.paymentLabel.frame.size.height, SIZE_DEVICE_WIDTH-24, 1)];
    [linePaymentView setBackgroundColor:ORDER_DETAIL_TOP_VIEW_LINE_COLOR];
    [_payInfoFrameView addSubview:linePaymentView];
    
    QSLabel *couponTipLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, 44+45, SIZE_DEVICE_WIDTH-24, 44)];
    [couponTipLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
    [couponTipLabel setText:@"使用优惠："];
    [couponTipLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [_payInfoFrameView addSubview:couponTipLabel];
    
    QSLabel *couponLabel = [[QSLabel alloc] initWithFrame:couponTipLabel.frame];
    [couponLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
    [couponLabel setText:@"会员优惠30元现金券"];
    [couponLabel setTextAlignment:NSTextAlignmentRight];
    [couponLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [_payInfoFrameView addSubview:couponLabel];
    
    UIView *lineCouponView = [[UIView alloc] initWithFrame:CGRectMake(12, couponLabel.frame.origin.y+couponLabel.frame.size.height, SIZE_DEVICE_WIDTH-24, 1)];
    [lineCouponView setBackgroundColor:ORDER_DETAIL_TOP_VIEW_LINE_COLOR];
    [_payInfoFrameView addSubview:lineCouponView];
    
    
    self.totalPriceLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, 44+2*45, SIZE_DEVICE_WIDTH-24, 44)];
    [self.totalPriceLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_TOTAL_PRICE_TEXT_FONT_SIZE]];
    [self.totalPriceLabel setTextAlignment:NSTextAlignmentRight];
    [self.totalPriceLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
    [_payInfoFrameView addSubview:self.totalPriceLabel];
//    NSString *totalPriceStr = @"98";
//    NSMutableAttributedString *totalPriceString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计 ￥%@",totalPriceStr]];
//    [totalPriceString addAttribute:NSForegroundColorAttributeName value:ORDER_DETAIL_TOP_VIEW_NUMBER_TEXT_COLOR range:NSMakeRange(4,totalPriceStr.length)];
//    [totalPriceString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE] range:NSMakeRange(4, totalPriceStr.length)];
//    [self.totalPriceLabel setAttributedText:totalPriceString];
    
    
    [_payInfoFrameView setFrame:CGRectMake(_payInfoFrameView.frame.origin.x, _payInfoFrameView.frame.origin.y, _payInfoFrameView.frame.size.width, self.totalPriceLabel.frame.origin.y+self.totalPriceLabel.frame.size.height)];
    
    //添加地址按钮
    QSBlockButtonStyleModel *submitBtStyleModel = [QSBlockButtonStyleModel alloc];
    submitBtStyleModel.bgColor  = [UIColor colorWithRed:0.471 green:0.176 blue:0.224 alpha:1.000];;
    submitBtStyleModel.title    = @"马上支付";
    submitBtStyleModel.titleNormalColor = [UIColor whiteColor];
    submitBtStyleModel.cornerRadio = 6.;
    self.payBt = [UIButton createBlockButtonWithFrame:CGRectMake(12, _payInfoFrameView.frame.origin.y+_payInfoFrameView.frame.size.height+30, SIZE_DEVICE_WIDTH-12*2, 44) andButtonStyle:submitBtStyleModel andCallBack:^(UIButton *button) {
        
        NSLog(@"payBt");
        
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
    
    
//    [self updateView];
    
}

- (void)updateView
{
    [self updateHadOrderView];
    [self updateShippingInfoView];
    [self updatePayInfoView];
}

- (void)updatePayInfoView
{
    
    [_payInfoFrameView setFrame:CGRectMake(_payInfoFrameView.frame.origin.x, _shippingInfoFrameView.frame.origin.y+_shippingInfoFrameView.frame.size.height, _payInfoFrameView.frame.size.width, _payInfoFrameView.frame.size.height)];
    
    [_payBt setFrame:CGRectMake(12, _payInfoFrameView.frame.origin.y+_payInfoFrameView.frame.size.height+30, SIZE_DEVICE_WIDTH-12*2, 44)];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _payBt.frame.origin.y+_payBt.frame.size.height+20)];
}

- (void)updateShippingInfoView
{
    
    NSString *nameStr = @"测试先生";
    [self.userNameLabel setText:nameStr];
    NSString *phone = @"13888888888";
    [self.phoneLabel setText:phone];
    
    
    NSString *addressStr = @"广州市天河区体育西路城建大厦";
    NSString *company = @"七升网络科技有限公司";
    [self.addressLabel setText:addressStr];
    if (company && ![company isEqualToString:@""]) {
        [self.companyLabel setHidden:NO];
        [self.companyLabel setText:company];
        [self.lineAddressView setFrame:CGRectMake(self.lineAddressView.frame.origin.x, self.companyLabel.frame.origin.y+self.companyLabel.frame.size.height, self.lineAddressView.frame.size.width, self.lineAddressView.frame.size.height)];
    }else{
        [self.companyLabel setHidden:YES];
        [self.lineAddressView setFrame:CGRectMake(self.lineAddressView.frame.origin.x, self.addressLabel.frame.origin.y+self.addressLabel.frame.size.height, self.lineAddressView.frame.size.width, self.lineAddressView.frame.size.height)];
    }
    
    
    [self.remarkTipLabel setFrame:CGRectMake(self.remarkTipLabel.frame.origin.x, self.lineAddressView.frame.origin.y+self.lineAddressView.frame.size.height, self.remarkTipLabel.frame.size.width, self.remarkTipLabel.frame.size.height)];
    
    [self.remarkLabel setFrame:CGRectMake(self.remarkLabel.frame.origin.x, self.remarkTipLabel.frame.origin.y, self.remarkLabel.frame.size.width, self.remarkLabel.frame.size.height)];
    
    [self.lineRemarkView setFrame:CGRectMake(self.lineRemarkView.frame.origin.x, self.remarkLabel.frame.origin.y+self.remarkLabel.frame.size.height, self.lineRemarkView.frame.size.width, self.lineRemarkView.frame.size.height)];
    
    [_shippingInfoFrameView setFrame:CGRectMake(_shippingInfoFrameView.frame.origin.x, _shippingInfoFrameView.frame.origin.y, _shippingInfoFrameView.frame.size.width, self.lineRemarkView.frame.origin.y+self.lineRemarkView.frame.size.height)];
    
    NSString *remarkStr = @"无备注信息";
    [self.remarkLabel setText:remarkStr];
    
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
    NSArray *foodList = [NSArray arrayWithObjects:@"",@"",@"", nil];
    NSInteger totalCount = 0;
    if ([foodList count]>0) {
        NSInteger countTag = 10001;
        for (int i=0; i<[foodList count]; i++) {
            NSString *foodNameStr = @"番茄炒猪扒";
            NSString *perPriceStr = @"12.3";
            NSString *countStr = @"2";
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
            
            BOOL isPackage = NO;
            if (isPackage) {
                for (int j=0; j<2; j++) {
                    QSLabel *subfoodNameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(foodNameLabel.frame.origin.x+foodNameLabel.frame.size.width+4, 44+i*45+2+j*20, (SIZE_DEVICE_WIDTH*0.7-foodNameStrWidth), 20)];
                    [subfoodNameLabel setFont:[UIFont systemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE]];
                    [subfoodNameLabel setText:@"主食配菜"];
                    [subfoodNameLabel setBackgroundColor:[UIColor clearColor]];
                    [subfoodNameLabel setTextColor:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_COLOR];
                    [subfoodNameLabel setTag:countTag++];
                    [_hadOrderFrameView addSubview:subfoodNameLabel];
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
    
    NSString *totalCountStr = [NSString stringWithFormat:@"%ld",(long)totalCount];
    NSMutableAttributedString *totalString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计%@份",totalCountStr]];
    [totalString addAttribute:NSForegroundColorAttributeName value:ORDER_DETAIL_TOP_VIEW_NUMBER_TEXT_COLOR range:NSMakeRange(2,totalCountStr.length)];
    [totalString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:ORDER_DETAIL_TOP_VIEW_CONTENT_TEXT_FONT_SIZE] range:NSMakeRange(2, totalCountStr.length)];
    [self.hadOrderTotalCountLabel setAttributedText:totalString];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _hadOrderFrameView.frame.origin.y+_hadOrderFrameView.frame.size.height)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
