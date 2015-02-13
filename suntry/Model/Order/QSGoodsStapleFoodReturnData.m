//
//  QSGoodsStapleFoodReturnData.m
//  suntry
//
//  Created by CoolTea on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSGoodsStapleFoodReturnData.h"

@implementation QSGoodsStapleFoodReturnData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"headerMSG" withMapping:[QSGoodsStapleFoodHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSGoodsStapleFoodHeaderData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"special_price" toKeyPath:@"specialList" withMapping:[QSGoodsDataModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"menu_package" toKeyPath:@"menuPackeList" withMapping:[QSGoodsDataModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"rice" toKeyPath:@"healthyList" withMapping:[QSGoodsDataModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"soup" toKeyPath:@"soupList" withMapping:[QSGoodsDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end