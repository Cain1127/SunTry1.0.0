//
//  QSDistrictDataModel.m
//  suntry
//
//  Created by 王树朋 on 15/2/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSDistrictDataModel.h"

@implementation QSDistrictDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"id" : @"districtID", @"zone" : @"val"};
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    [shared_mapping addAttributeMappingsFromArray:@[@"id_"]];
    
    return shared_mapping;
    
}

@end
