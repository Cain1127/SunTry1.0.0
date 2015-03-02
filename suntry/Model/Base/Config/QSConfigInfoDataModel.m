//
//  QSConfigInfoDataModel.m
//  suntry
//
//  Created by CoolTea on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSConfigInfoDataModel.h"

@implementation QSConfigInfoDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //返回字段 eg：
    //[id] => 19
    //[parent_id] => 0
    //[tag_name] => PHONEALIPAYNOTIFYURL
    //[search_times] => 0
    //[use_times] => 0
    //[add_time] => 0
    //[tag_id] => PAYCONFIG
    //[tag_value] => http://test.9dxz.com/appAliPay/NotifyUrl
    //[add_user_id] => 0
    //[priority] => 0
    
    //mapping字典
    NSDictionary *mappingDict = @{@"id" : @"config_id",
                                  @"tag_name" : @"tag_name",
                                  @"tag_id" : @"tag_id",
                                  @"tag_value" : @"tag_value"};
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    return shared_mapping;
    
}

#pragma mark - encoding相关
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    
    if (self = [super init]) {
        
        self.config_id = [aDecoder decodeObjectForKey:@"config_id"];
        self.tag_name = [aDecoder decodeObjectForKey:@"tag_name"];
        self.tag_id = [aDecoder decodeObjectForKey:@"tag_id"];
        self.tag_value = [aDecoder decodeObjectForKey:@"tag_value"];
        
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.config_id forKey:@"config_id"];
    [aCoder encodeObject:self.tag_name forKey:@"tag_name"];
    [aCoder encodeObject:self.tag_id forKey:@"tag_id"];
    [aCoder encodeObject:self.tag_value forKey:@"tag_value"];
    
}


@end
