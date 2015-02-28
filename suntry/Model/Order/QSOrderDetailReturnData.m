//
//  QSOrderDetailReturnData.m
//  suntry
//
//  Created by CoolTea on 15/2/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderDetailReturnData.h"


@implementation QSOrderDetailReturnData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"orderDetailData" withMapping:[QSOrderDetailDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
