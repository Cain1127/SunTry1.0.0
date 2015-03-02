//
//  QSBannerDataModel.m
//  suntry
//
//  Created by 王树朋 on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBannerDataModel.h"

@implementation QSBannerDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"banner":@"bannerUrl",
                                  @"id":@"bannerID",
                                  @"mer_id":@"merID",
                                  @"goods_name":@"goodsName",
                                  @"pice":@"pice",
                                  @"type":@"type",
                                  @"begin_time":@"beginTime",
                                  @"over_time":@"overTime",
                                  @"status":@"status"
                                  };
    
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];

    return shared_mapping;
    
}


@end
