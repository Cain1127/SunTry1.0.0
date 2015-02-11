//
//  QSDistrictReturnData.m
//  suntry
//
//  Created by 王树朋 on 15/2/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSDistrictReturnData.h"
#import "QSDistrictDataModel.h"

@implementation QSDistrictReturnData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    //mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"districtList" withMapping:[QSDistrictDataModel objectMapping]]];
    
    
    return shared_mapping;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{

    if (self = [super initWithCoder:aDecoder]) {
        
        self.districtList = [aDecoder decodeObjectForKey:@"districtList"];
        
    }
    
    return self;

}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:self.districtList forKey:@"districtList"];

}

@end
