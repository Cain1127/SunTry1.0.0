//
//  QSOrderDetailReturnData.h
//  suntry
//
//  Created by CoolTea on 15/2/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSOrderDetailDataModel.h"

@interface QSOrderDetailReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSOrderDetailDataModel *orderDetailData;//!<订单详情数据

@end
