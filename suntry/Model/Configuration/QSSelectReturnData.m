//
//  QSSelectReturnData.m
//  suntry
//
//  Created by 王树朋 on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSSelectReturnData.h"
#import "QSSelectDataModel.h"

@implementation QSSelectReturnData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    //mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"selectList" withMapping:[QSSelectDataModel objectMapping]]];
    
    
    return shared_mapping;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        self.selectList = [aDecoder decodeObjectForKey:@"selectList"];
        
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.selectList forKey:@"selectList"];
    
}

@end
