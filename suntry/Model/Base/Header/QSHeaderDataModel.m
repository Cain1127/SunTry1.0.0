//
//  QSHeaderDataModel.m
//  suntry
//
//  Created by 王树朋 on 15/2/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"

@implementation QSHeaderDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"type" : @"type",@"info" : @"info"};
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    return shared_mapping;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    
    if (self = [super init]) {
        
        
        
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    
    
}

@end
