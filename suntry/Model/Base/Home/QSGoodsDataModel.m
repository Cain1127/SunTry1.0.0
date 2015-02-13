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
                                  @"over_time":@"overTime"
                                  };
    
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    return shared_mapping;
    
}

- (NSString*)getOnsalePrice
{
    
    NSString* price = [_goodsSpecialPrice isEqualToString:@"-1"] ? _goodsPrice:_goodsSpecialPrice;
    
    return price;
    
}

@end