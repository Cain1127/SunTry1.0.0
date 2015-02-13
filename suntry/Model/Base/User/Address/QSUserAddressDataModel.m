//
//  QSUserAddressDataModel.m
//  suntry
//
//  Created by ysmeng on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSUserAddressDataModel.h"

@implementation QSUserAddressDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"id" : @"addressID",
                                  @"user_id" : @"userID",
                                  @"address" : @"address",
                                  @"phone" : @"phone",
                                  @"status" : @"status",
                                  @"is_master" : @"is_master",
                                  @"name" : @"userName",
                                  @"sex" : @"gender"};
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    return shared_mapping;
    
    
}

#pragma mark - encoding相关
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    
    if (self = [super init]) {
        
        self.addressID = [aDecoder decodeObjectForKey:@"addressID"];
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.is_master = [aDecoder decodeObjectForKey:@"is_master"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.addressID forKey:@"addressID"];
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.is_master forKey:@"is_master"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    
}

@end
