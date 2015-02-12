//
//  QSGoodsListReturnData.m
//  suntry
//
//  Created by CoolTea on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSGoodsListReturnData.h"
#import "QSGoodsDataModel.h"


@implementation QSGoodsListAllData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"goodsList" withMapping:[QSGoodsDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end


@implementation QSGoodsListReturnData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"goodsListAllData" withMapping:[QSGoodsListAllData objectMapping]]];
    
    return shared_mapping;
    
}

@end
