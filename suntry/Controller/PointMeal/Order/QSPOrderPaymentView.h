//
//  QSPOrderPaymentView.h
//  suntry
//
//  Created by CoolTea on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    PaymentTypeNoPayment  = -1,
    PaymentTypePayForAfter = 0,
    PaymentTypeAlipay,
    PaymentTypePayCrads,
}PaymentType;

@class QSPOrderPaymentView;
@protocol QSPOrderPaymentViewDelegate<NSObject>

- (void)clickedItemWithType:(PaymentType)type WithOrderPaymentView:(QSPOrderPaymentView*)view;

@end

@interface QSPOrderPaymentView : UIView

@property(nonatomic,assign) id<QSPOrderPaymentViewDelegate> delegate;

- (instancetype)initOrderItemView;

- (PaymentType)getSelectedPayment;

- (void)setSelectedPayment:(PaymentType)selected;

@end
