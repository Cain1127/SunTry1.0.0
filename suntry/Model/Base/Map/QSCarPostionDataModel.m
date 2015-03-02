//
//  QSCarPostionDataModel.m
//  suntry
//
//  Created by 王树朋 on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCarPostionDataModel.h"

@implementation QSCarPostionDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"id":@"ID",
                                  @"car_name" : @"carName",
                                  @"mer_id":@"merID",
                                  @"status":@"status",
                                  @"car_num" : @"carNum",
                                  @"max_num":@"maxNum"
                                  };
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"carPosition" toKeyPath:@"postionList" withMapping:[QSCarPostionDataSubModel objectMapping]]];
    
    return shared_mapping;
    
}
@end

@implementation QSCarPostionDataSubModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"id":@"carPostionID",
                                  @"car_id" : @"carID",
                                  @"latitude":@"latitude",
                                  @"longitude":@"longitude",
                                  @"time" : @"carTime"
                                  
                                  };
    
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    return shared_mapping;
    
}


@end
