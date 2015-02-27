//
//  QSUserInfoDataModel.m
//  suntry
//
//  Created by ysmeng on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSUserInfoDataModel.h"

@implementation QSUserInfoDataModel

+ (instancetype)userDataModel
{

    ///读取本地信息
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/user_info"];
    
    ///把地址信息coding在本地
    NSData *tempData = [NSData dataWithContentsOfFile:path];
    QSUserInfoDataModel *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
    
    return userInfo;

}

- (void)saveUserData
{

    ///把用信息coding在本地
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/user_info"];
    
    ///把地址信息coding在本地
    NSData *tempData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [tempData writeToFile:path atomically:YES];

}

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
                                  @"pay_salt" : @"pay_salt",
                                  @"address_id" : @"addressID",
                                  @"address" : @"address",
                                  @"address_name" : @"receidName",
                                  @"is_buy_card" : @"is_buy_card",
                                  @"balance" : @"balance"};
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
        self.addressID = [aDecoder decodeObjectForKey:@"addressID"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.receidName = [aDecoder decodeObjectForKey:@"receidName"];
        self.is_buy_card = [aDecoder decodeObjectForKey:@"is_buy_card"];
        self.balance = [aDecoder decodeObjectForKey:@"balance"];
        
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
    [aCoder encodeObject:self.addressID forKey:@"addressID"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.receidName forKey:@"receidName"];
    [aCoder encodeObject:self.is_buy_card forKey:@"is_buy_card"];
    [aCoder encodeObject:self.balance forKey:@"balance"];
    
}

#pragma mark - 返回当前用户是否购买过储值卡的标识
///返回当前用户是否已购买过储值卡:YES-购买过
- (BOOL)isBoughtStoreCard
{

    if ([self.is_buy_card intValue] == 1) {
        
        return YES;
        
    }
    
    return NO;

}

@end
