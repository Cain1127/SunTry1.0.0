//
//  QSStoredCardDataModel.m
//  suntry
//
//  Created by 王树朋 on 15/2/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSStoredCardDataModel.h"

@implementation QSStoredCardDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"user_id" : @"userID",                        
                                  @"remark" : @"remark",
                                  @"amount" : @"amount",
                                  @"create_time" : @"createTime",
                                  @"mer_id" : @"merID",
                                  @"type" : @"type",
                                  @"historybalance" : @"historybalance"
                                  };
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    return shared_mapping;
    
}

@end
