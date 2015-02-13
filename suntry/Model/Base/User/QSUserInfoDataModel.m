//
//  QSUserInfoDataModel.m
//  suntry
//
//  Created by ysmeng on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSUserInfoDataModel.h"

@implementation QSUserInfoDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"id" : @"userID",
                                  @"account_name" : @"loginName",
                                  @"real_name" : @"realName",
                                  @"email" : @"email",
                                  @"phone" : @"phone",
                                  @"qq" : @"userQQ",
                                  @"type" : @"type",
                                  @"status" : @"status",
                                  @"sex" : @"gender",
                                  @"company" : @"company",
                                  @"pay" : @"pay",
                                  @"pay_salt" : @"pay_salt"};
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    return shared_mapping;
    
}

#pragma mark - encoding相关
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    
    if (self = [super init]) {
        
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
        self.loginName = [aDecoder decodeObjectForKey:@"loginName"];
        self.realName = [aDecoder decodeObjectForKey:@"realName"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.userQQ = [aDecoder decodeObjectForKey:@"userQQ"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.company = [aDecoder decodeObjectForKey:@"company"];
        self.pay = [aDecoder decodeObjectForKey:@"pay"];
        self.pay_salt = [aDecoder decodeObjectForKey:@"pay_salt"];
        
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.loginName forKey:@"loginName"];
    [aCoder encodeObject:self.realName forKey:@"realName"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.userQQ forKey:@"userQQ"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.company forKey:@"company"];
    [aCoder encodeObject:self.pay forKey:@"pay"];
    [aCoder encodeObject:self.pay_salt forKey:@"pay_salt"];
    
}

@end
