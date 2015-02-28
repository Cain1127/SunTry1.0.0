//
//  QSOrderListReturnData.m
//  suntry
//
//  Created by CoolTea on 15/2/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderListReturnData.h"

@implementation QSOrderListReturnData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"orderListData" withMapping:[QSOrderListData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSOrderListData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"orderList" withMapping:[QSOrderListItemDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end