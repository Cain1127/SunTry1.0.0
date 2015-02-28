//
//  QSOrderDetailGoodsDataModel.m
//  suntry
//
//  Created by CoolTea on 15/2/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderDetailGoodsDataModel.h"

@implementation QSOrderDetailGoodsDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"name":@"goodsName",
                                  @"amount" : @"goodsCount",
                                  @"price":@"goodsPrice"
                                  };
    
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"diet" toKeyPath:@"subFoodList" withMapping:[QSOrderDetailGoodsDataSubModel objectMapping]]];
    
    return shared_mapping;
    
}
@end

@implementation QSOrderDetailGoodsDataSubModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"name":@"goodsName",
                                  @"amount" : @"goodsCount",
                                  @"price":@"goodsPrice"
                                  };
    
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    return shared_mapping;
    
}

@end