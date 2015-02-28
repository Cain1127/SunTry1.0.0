//
//  QSOrderListReturnData.h
//  suntry
//
//  Created by CoolTea on 15/2/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSOrderListItemDataModel.h"

@class QSOrderListData;
@interface QSOrderListReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSOrderListData *orderListData;//!<msg头信息;

@end

@interface QSOrderListData : QSHeaderDataModel

@property (nonatomic,retain) NSArray    *orderList; //!<订单列表数据
//@property (nonatomic,retain) NSString   *total_num; //!<订单总数量

@end
