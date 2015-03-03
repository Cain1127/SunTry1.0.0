//
//  QSConfigInfoDataListModel.h
//  suntry
//
//  Created by CoolTea on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMSGModel.h"
#import "QSConfigInfoDataModel.h"

@interface QSConfigInfoDataListModel : QSMSGModel

+ (instancetype)ConfigInfoDataModel;

- (void)saveConfigInfoData;

- (CGFloat)getTabkeOutStartPrice;

@property (nonatomic,retain) NSArray *syconfigList;         //!<折扣价格数组
@property (nonatomic,retain) NSArray *orderConfigList;      //!<订单配送的信息数组
@property (nonatomic,retain) NSArray *payconfigList;        //!<获取支付配置信息数组

@end
