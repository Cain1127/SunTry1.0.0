//
//  QSAllGoodsReturnData.m
//  suntry
//
//  Created by CoolTea on 15/3/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAllGoodsReturnData.h"

@implementation QSAllGoodsReturnData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"allGoodsList" withMapping:[QSAllGoodsDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
