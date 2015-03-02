//
//  QSConfigInfoDataListModel.m
//  suntry
//
//  Created by CoolTea on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSConfigInfoDataListModel.h"

@implementation QSConfigInfoDataListModel


//+ (instancetype)ConfigInfoDataModel
//{
//    
//    ///读取本地信息
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/user_info"];
//    
//    ///把地址信息coding在本地
//    NSData *tempData = [NSData dataWithContentsOfFile:path];
//    QSConfigInfoDataListModel *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
//    
//    return userInfo;
//    
//}

- (void)saveConfigInfoData
{
    
//    ///把用信息coding在本地
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/user_info"];
//    
//    ///把地址信息coding在本地
//    NSData *tempData = [NSKeyedArchiver archivedDataWithRootObject:self];
//    [tempData writeToFile:path atomically:YES];
    
}


+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"configList" withMapping:[QSConfigInfoDataModel objectMapping]]];
    return shared_mapping;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        self.configList = [aDecoder decodeObjectForKey:@"configList"];
        
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.configList forKey:@"configList"];
    
}


@end
