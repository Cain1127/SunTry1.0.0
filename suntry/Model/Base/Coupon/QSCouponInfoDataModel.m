//
//  QSCouponInfoDataModel.m
//  suntry
//
//  Created by ysmeng on 15/2/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCouponInfoDataModel.h"

@implementation QSCouponInfoDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"type",
                                                    @"goods_name",
                                                    @"parent_id",
                                                    @"pice",
                                                    @"banner",
                                                    @"begin_time",
                                                    @"over_time"]];
    
    return shared_mapping;
    
}

@end
