//
//  QSSelectDataModel.m
//  suntry
//
//  Created by 王树朋 on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSSelectDataModel.h"

@implementation QSSelectDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"id" : @"streetID", @"name" : @"streetName",@"status":@"isSend"};
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    return shared_mapping;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    
    if (self = [super init]) {
        
        self.streetID = [aDecoder decodeObjectForKey:@"id"];
        self.streetName = [aDecoder decodeObjectForKey:@"name"];
        self.isSend=[aDecoder decodeObjectForKey:@"status"];
        
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.streetID forKey:@"id"];
    [aCoder encodeObject:self.streetName forKey:@"name"];
    [aCoder encodeObject:self.isSend forKey:@"status"];
    
}

@end
