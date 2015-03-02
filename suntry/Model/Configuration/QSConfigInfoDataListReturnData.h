//
//  QSConfigInfoDataListReturnData.h
//  suntry
//
//  Created by CoolTea on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSConfigInfoDataListModel.h"
#import "QSConfigInfoDataModel.h"

@class QSConfigInfoDataListModel;
@interface QSConfigInfoDataListReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSConfigInfoDataListModel *configListData;//!<msg头信息;

@end