//
//  QSPOrderPaymentView.m
//  suntry
//
//  Created by CoolTea on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderPaymentView.h"
#import "QSLabel.h"
#import "DeviceSizeHeader.h"
#import "QSBlockButton.h"
#import "NSString+Calculation.h"
#import "QSUserInfoDataModel.h"

#define ORDER_PAYMENT_TITLE_FONT_SIZE       17.
#define ORDER_PAYMENT_CONTENT_FONT_SIZE     17.
#define ORDER_PAYMENT_LINE_COLOR            [UIColor colorWithRed:206/255. green:208/255. blue:210/255. alpha:1]
#define ORDER_PAYMENT_CELL_HEIGHT           44.
#define ORDER_PAYMENT_CONTENT_TEXT_COLOR    [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]
#define ORDER_PAYMENT_BALANCE_TEXT_COLOR    [UIColor colorWithRed:0.709 green:0.653 blue:0.543 alpha:1.000]

@interface QSPOrderPaymentView ()

@property (nonatomic,assign)PaymentType selectedPayment;

@end

@implementation QSPOrderPaymentView

- (instancetype)initOrderItemView
{
    self.selectedPayment = PaymentTypeNoPayment;
    if (self = [super init]) {
        //配送信息
        QSLabel *payTip = [[QSLabel alloc] initWithFrame:CGRectMake(12, 15, SIZE_DEVICE_WIDTH-24, 17)];
        [payTip setFont:[UIFont boldSystemFontOfSize:ORDER_PAYMENT_TITLE_FONT_SIZE]];
        [payTip setText:@"支付方式"];
        [payTip setTextColor:[UIColor blackColor]];
        [self addSubview:payTip];
        
        UIView *lineButtomView = [[UIView alloc] initWithFrame:CGRectMake(12, payTip.frame.origin.y+payTip.frame.size.height+12, SIZE_DEVICE_WIDTH-24, 1)];
        [lineButtomView setBackgroundColor:ORDER_PAYMENT_LINE_COLOR];
        [self addSubview:lineButtomView];
        
        CGFloat bottomY = lineButtomView.frame.origin.y+lineButtomView.frame.size.height;
        
        NSArray *paymentList = [NSArray arrayWithObjects:@"货到付款(送餐签收后付款)",@"在线支付(支付宝支付)",@"储值卡支付", nil];
        
        for (int i=0; i<[paymentList count]; i++) {
            
            NSString *paymentName = paymentList[i];
            QSLabel *paymentItemLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, lineButtomView.frame.origin.y+lineButtomView.frame.size.height+i*45, SIZE_DEVICE_WIDTH-24, ORDER_PAYMENT_CELL_HEIGHT)];
            [paymentItemLabel setFont:[UIFont systemFontOfSize:ORDER_PAYMENT_TITLE_FONT_SIZE]];
            [paymentItemLabel setText:paymentName];
            [paymentItemLabel setTextColor:ORDER_PAYMENT_CONTENT_TEXT_COLOR];
            [self addSubview:paymentItemLabel];
            
            if ([paymentName isEqualToString:@"储值卡支付"]) {
                CGFloat nameWidth = [paymentName calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:ORDER_PAYMENT_TITLE_FONT_SIZE]+4;
                
                CGRect paymentNameFrame = paymentItemLabel.frame;
                paymentNameFrame.size.width = nameWidth;
                paymentItemLabel.frame = paymentNameFrame;
                
                QSUserInfoDataModel *userData = [QSUserInfoDataModel userDataModel];
                
                if (userData && userData.balance) {
                    
                    QSLabel *balanceTip = [[QSLabel alloc] initWithFrame:CGRectMake(paymentItemLabel.frame.origin.x+paymentItemLabel.frame.size.width, paymentItemLabel.frame.origin.y, SIZE_DEVICE_WIDTH-24 -(paymentItemLabel.frame.origin.x+paymentItemLabel.frame.size.width), ORDER_PAYMENT_CELL_HEIGHT)];
                    [balanceTip setFont:[UIFont systemFontOfSize:ORDER_PAYMENT_TITLE_FONT_SIZE]];
                    
                    [balanceTip setText:[NSString stringWithFormat:@"(余额：￥%@)",userData.balance]];
                    [balanceTip setTextColor:ORDER_PAYMENT_BALANCE_TEXT_COLOR];
                    [self addSubview:balanceTip];
                    
                }
            }
            
            QSBlockButtonStyleModel *selectedBtStyle = [[QSBlockButtonStyleModel alloc] init];
            [selectedBtStyle setImagesNormal:@"order_payment_normal_bt"];
            [selectedBtStyle setBgColor:[UIColor clearColor]];
            UIButton *selectedBt = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-44-16, paymentItemLabel.frame.origin.y, 44, 44) andButtonStyle:selectedBtStyle andCallBack:^(UIButton *button) {
            }];
            [selectedBt setTag:8000+i];
            [self addSubview:selectedBt];
            
            QSBlockButtonStyleModel *chlickBtStyle = [[QSBlockButtonStyleModel alloc] init];
            UIButton *chlickBt = [UIButton createBlockButtonWithFrame:CGRectMake(12, lineButtomView.frame.origin.y+lineButtomView.frame.size.height+i*45, SIZE_DEVICE_WIDTH-24, ORDER_PAYMENT_CELL_HEIGHT) andButtonStyle:chlickBtStyle andCallBack:^(UIButton *button) {
                
                for (UIView *view in [self subviews])
                {
                    if ([view isKindOfClass:[UIButton class]]) {
                        if (view.tag>=8000&&view.tag<=8009) {
                            UIButton *bt = (UIButton*)view;
                            [bt setImage:[UIImage imageNamed:@"order_payment_normal_bt"] forState:UIControlStateNormal];
                            if (bt.tag%8000 == button.tag%9000) {
                                [bt setImage:[UIImage imageNamed:@"order_payment_selected_bt"] forState:UIControlStateNormal];
                                self.selectedPayment = button.tag%9000;
                            }
                        }
                    }
                }
            }];
            [chlickBt setTag:9000+i];
            [self addSubview:chlickBt];
            
            UIView *subLineButtomView = [[UIView alloc] initWithFrame:CGRectMake(12, paymentItemLabel.frame.origin.y+paymentItemLabel.frame.size.height, SIZE_DEVICE_WIDTH-24, 1)];
            [subLineButtomView setBackgroundColor:ORDER_PAYMENT_LINE_COLOR];
            [self addSubview:subLineButtomView];
            
            bottomY = subLineButtomView.frame.origin.y+subLineButtomView.frame.size.height;
        }
    
        [self setFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, bottomY)];
        
    }
    
    return self;
    
}

- (PaymentType)getSelectedPayment
{
    return _selectedPayment;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
