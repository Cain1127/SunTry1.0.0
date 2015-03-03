//
//  QSPOrderSubmitedStateViewController.h
//  suntry
//
//  Created by CoolTea on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSOrderDetailDataModel.h"

@interface QSPOrderSubmitedStateViewController : UIViewController

@property (nonatomic, assign) BOOL paymentSate;                 //设置显示成功（YES）或者失败界面（NO）
@property (nonatomic, strong) QSOrderDetailDataModel *orderData; //订单ID

@end
