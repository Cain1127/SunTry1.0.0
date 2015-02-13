//
//  QSUserAddressListReturnData.m
//  suntry
//
//  Created by ysmeng on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSUserAddressListReturnData.h"

@implementation QSUserAddressListReturnData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    //mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"addressList" withMapping:[QSUserAddressDataModel objectMapping]]];
    
    
    return shared_mapping;
    
}

@end
