//
//  QSPOrderDeliveryTimeView.h
//  suntry
//
//  Created by CoolTea on 15/2/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    DeliveryTimeTypeNoSelected = -1,
    DeliveryTimeTypeTodayAM  = 0,
    DeliveryTimeTypeTodayPM = 1,
    DeliveryTimeTypeTomorrowAM,
    DeliveryTimeTypeTomorrowPM,
}DeliveryTimeType;

@interface QSPOrderDeliveryTimeView : UIView

- (instancetype)initOrderDeliveryTimeView;

- (DeliveryTimeType)getSelectedDeliveryTime;

@end
