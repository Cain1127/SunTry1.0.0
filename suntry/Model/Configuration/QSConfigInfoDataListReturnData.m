//
//  QSConfigInfoDataListReturnData.m
//  suntry
//
//  Created by CoolTea on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSConfigInfoDataListReturnData.h"

@implementation QSConfigInfoDataListReturnData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"configListData" withMapping:[QSConfigInfoDataListModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
