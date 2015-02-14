//
//  QSUserRegisterReturnData.m
//  suntry
//
//  Created by 王树朋 on 15/2/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSUserRegisterReturnData.h"
#import "QSRegisterDataModel.h"

@implementation QSUserRegisterReturnData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    //mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"RegisterList" withMapping:[QSRegisterDataModel objectMapping]]];
    
    
    return shared_mapping;
    
}
@end
