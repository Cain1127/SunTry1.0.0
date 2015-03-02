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

//+ (instancetype)ConfigInfoDataModel;

- (void)saveConfigInfoData;

@property (nonatomic,retain) NSArray *configList;//!<配置信息数组

@end
