//
//  QSAllGoodsDataModel.m
//  suntry
//
//  Created by CoolTea on 15/3/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAllGoodsDataModel.h"

@implementation QSAllGoodsDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"name":@"typeName"};
    
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"son" toKeyPath:@"subGoodsList" withMapping:[QSAllGoodsSubDataModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"list" toKeyPath:@"goodsList" withMapping:[QSGoodsDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSAllGoodsSubDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"name":@"typeName"
                                  };
    
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"son" toKeyPath:@"subGoodsList" withMapping:[QSAllGoodsSubSubDataModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"list" toKeyPath:@"goodsList" withMapping:[QSGoodsDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSAllGoodsSubSubDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"name":@"typeName"
                                  };
    
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
//    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"son" toKeyPath:@"subGoodsList" withMapping:[QSAllGoodsSubSubSubDataModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"list" toKeyPath:@"goodsList" withMapping:[QSGoodsDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end

