//
//  QSConfigInfoDataModel.h
//  suntry
//
//  Created by CoolTea on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSConfigInfoDataModel : QSBaseModel

@property (nonatomic,copy) NSString *config_id;         //!<配置ID
@property (nonatomic,copy) NSString *tag_name;          //!<配置字段名
@property (nonatomic,copy) NSString *tag_id;            //!<配置分类名
@property (nonatomic,copy) NSString *tag_value;         //!<配置值

@end
