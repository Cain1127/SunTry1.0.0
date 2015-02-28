//
//  QSDelUserAddressDataModel.m
//  suntry
//
//  Created by 王树朋 on 15/2/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSDelUserAddressDataModel.h"

@implementation QSDelUserAddressDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{
                                  @"msg" : @"msginfo"};
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    return shared_mapping;
    
}

@end
