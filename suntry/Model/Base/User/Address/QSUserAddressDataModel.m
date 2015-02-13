//
//  QSUserAddressDataModel.m
//  suntry
//
//  Created by ysmeng on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSUserAddressDataModel.h"

@implementation QSUserAddressDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"id" : @"addressID",
                                  @"user_id" : @"userID",
                                  @"address" : @"address",
                                  @"phone" : @"phone",
                                  @"status" : @"status",
                                  @"is_master" : @"is_master",
                                  @"name" : @"userName",
                                  @"sex" : @"gender"};
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    return shared_mapping;
    
    
}

@end
