//
//  QSAspecialDataModel.m
//  suntry
//
//  Created by 王树朋 on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAspecialDataModel.h"

@implementation QSAspecialDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"id" : @"goodsID",
                                  @"goods_name" : @"goodsName",
                                  @"mer_id":@"merID",
                                  @"pice":@"goodsPrice",
                                  @"banner":@"goodsImage",
                                  @"begin_time":@"beginTime",
                                  @"over_time":@"overTime",
                                  @"discount_price":@"specialPrice"};
    
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    return shared_mapping;
    
}
@end
