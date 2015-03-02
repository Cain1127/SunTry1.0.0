//
//  QSCarPostionReturnData.m
//  suntry
//
//  Created by 王树朋 on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCarPostionReturnData.h"
#import "QSCarPostionDataModel.h"

@implementation QSCarPostionReturnData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    //mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"carPostionList" withMapping:[QSCarPostionDataModel objectMapping]]];
    
    
    return shared_mapping;
    
}

@end
