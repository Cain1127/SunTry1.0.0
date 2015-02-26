//
//  QSAddOrderReturnData.m
//  suntry
//
//  Created by ysmeng on 15/2/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAddOrderReturnData.h"
#import "QSOrderInfoDataModel.h"

@implementation QSAddOrderReturnData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"orderInfoList" withMapping:[QSOrderInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
