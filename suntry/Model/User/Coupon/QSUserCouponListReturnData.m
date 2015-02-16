//
//  QSUserCouponListReturnData.m
//  suntry
//
//  Created by ysmeng on 15/2/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSUserCouponListReturnData.h"
#import "QSCouponInfoDataModel.h"

@implementation QSUserCouponListReturnData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"couponListHeader" withMapping:[QSUserCouponListHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSUserCouponListHeaderData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"couponList" withMapping:[QSCouponInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end