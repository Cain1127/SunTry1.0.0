//
//  QSConfigInfoDataListModel.m
//  suntry
//
//  Created by CoolTea on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSConfigInfoDataListModel.h"

@implementation QSConfigInfoDataListModel


+ (instancetype)ConfigInfoDataModel
{
    ///读取本地信息
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/app_configInfo_list"];
    
    ///把地址信息coding在本地
    NSData *tempData = [NSData dataWithContentsOfFile:path];
    QSConfigInfoDataListModel *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
    
    return userInfo;
}

- (void)saveConfigInfoData
{
    ///把用信息coding在本地
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/app_configInfo_list"];
    
    ///把地址信息coding在本地
    NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:self];
    BOOL isSave = [saveData writeToFile:path atomically:YES];
    if (isSave) {
        NSLog(@"本地配置信息更新成功！");
    } else {
         NSLog(@"本地配置信息更新失败！");
    }
}

- (CGFloat)getTabkeOutStartPrice
{
    CGFloat price = 15.;
    if (self.orderConfigList&&[self.orderConfigList isKindOfClass:[NSArray class]])
    {
        for (id item in self.orderConfigList) {
            if ([item isKindOfClass:[QSConfigInfoDataModel class]]) {
                QSConfigInfoDataModel *configData = (QSConfigInfoDataModel*)item;
                if ([configData.tag_name isEqualToString:@"TAKEOUTSTARTMONEY"]) {
                    price = (configData.tag_value).floatValue;
                }
            }
        }
    }
    return price;
}

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"syconfig" toKeyPath:@"syconfigList" withMapping:[QSConfigInfoDataModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"orderConfig" toKeyPath:@"orderConfigList" withMapping:[QSConfigInfoDataModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"payconfig" toKeyPath:@"payconfigList" withMapping:[QSConfigInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    
    if (self = [super initWithCoder:aDecoder]) {
        self.syconfigList = [aDecoder decodeObjectForKey:@"syconfigList"];
        self.orderConfigList = [aDecoder decodeObjectForKey:@"orderConfigList"];
        self.payconfigList = [aDecoder decodeObjectForKey:@"payconfigList"];
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.syconfigList forKey:@"syconfigList"];
    [aCoder encodeObject:self.payconfigList forKey:@"payconfigList"];
    [aCoder encodeObject:self.orderConfigList forKey:@"orderConfigList"];
}


@end
