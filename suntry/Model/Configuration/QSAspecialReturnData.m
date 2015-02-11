//
//  QSAspecialReturnData.m
//  suntry
//
//  Created by 王树朋 on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAspecialReturnData.h"
#import "QSAspecialDataModel.h"
@implementation QSAspecialReturnData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"aspecialHeaderData" withMapping:[QSAspecialHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSAspecialHeaderData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"specialList" withMapping:[QSAspecialDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end