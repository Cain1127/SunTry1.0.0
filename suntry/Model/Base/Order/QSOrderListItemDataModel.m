//
//  QSOrderListItemDataModel.m
//  suntry
//
//  Created by CoolTea on 15/2/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderListItemDataModel.h"

@implementation QSOrderListItemDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"id" : @"order_id",
                                  @"order_num" : @"order_num",
                                  @"bill_id" : @"bill_id",
                                  @"status" : @"order_status",
                                  @"total_money" : @"total_money",
                                  @"add_time" : @"add_time",
                                  @"name" : @"order_name",
                                  @"address" : @"order_address",
                                  @"phone" : @"order_phone",
                                  @"desc" : @"order_desc",
                                  @"expand_4" : @"order_payment",
                                  @"diet_num" : @"diet_num",
                                  @"is_pay" : @"is_pay"
                                  };
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    return shared_mapping;
    
}


@end
