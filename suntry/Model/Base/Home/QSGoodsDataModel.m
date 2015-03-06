//
//  QSGoodsDataModel.m
//  suntry
//
//  Created by CoolTea on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSGoodsDataModel.h"

@implementation QSGoodsDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"mer_id":@"shopkeeperID",
                                  @"id" : @"goodsID",
                                  @"expant_2_title":@"goodsTypeName",
                                  @"type":@"goodsTypeID",
                                  @"goods_name" : @"goodsName",
                                  @"pice":@"goodsPrice",
                                  @"discount_price":@"goodsSpecialPrice",
                                  @"banner":@"goodsImageUrl",
                                  @"goods_num":@"goodsInstockNum",
                                  @"begin_time":@"beginTime",
                                  @"over_time":@"overTime",
                                  @"expant_3":@"presentPrice"
                                  };
    
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"staple_food" toKeyPath:@"stapleFoodList" withMapping:[QSGoodsDataSubModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"soup" toKeyPath:@"ingredientList" withMapping:[QSGoodsDataSubModel objectMapping]]];
    
    return shared_mapping;
    
}


/**
 *  返回菜品价格
 *
 *  菜品原价不四舍五入，只显示小数点后一位
 *  折扣价只显示小数点后一位,进行五内递增
 *
 *  @return 菜品价格
 */
- (NSString*)getOnsalePrice
{
    NSString *price      = _goodsPrice;
    NSString *specialPrice  = _goodsSpecialPrice;
    
    if (price&&[price isKindOfClass:[NSString class]]) {
        
        price = [NSString stringWithFormat:@"%.1f",price.floatValue];
        
    }
    
    if (specialPrice&&[specialPrice isKindOfClass:[NSString class]]) {
        
        specialPrice = [self computePriceWith5:specialPrice];
        
    }
    
    NSString* currentPrice =@"";
    if (nil == specialPrice) {
        currentPrice = (nil==price?@"":price);
    }else if (nil == price){
        currentPrice = (nil==specialPrice?@"":specialPrice);
    }else{
        currentPrice = ([specialPrice isEqualToString:@"-1.0"] ? price:specialPrice);
    }
    
    return currentPrice;
    
}

@end

@implementation QSGoodsDataSubModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"mer_id":@"shopkeeperID",
                                  @"id" : @"goodsID",
                                  @"expant_2_title":@"goodsTypeName",
                                  @"type":@"goodsTypeID",
                                  @"goods_name" : @"goodsName",
                                  @"pice":@"goodsPrice",
                                  @"discount_price":@"goodsSpecialPrice",
                                  @"banner":@"goodsImageUrl",
                                  @"goods_num":@"goodsInstockNum",
                                  @"begin_time":@"beginTime",
                                  @"over_time":@"overTime"
                                  
                                  };
    
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    return shared_mapping;
    
}

- (NSString*)getOnsalePrice
{
    NSString* price =@"";
    if (nil == _goodsSpecialPrice) {
        price = nil==_goodsPrice?@"":_goodsPrice;
    }else if (nil == _goodsPrice){
        price = nil==_goodsSpecialPrice?@"":_goodsSpecialPrice;;
    }else{
        price = [_goodsSpecialPrice isEqualToString:@"-1"] ? _goodsPrice:_goodsSpecialPrice;
    }
    return price;
    
}

@end