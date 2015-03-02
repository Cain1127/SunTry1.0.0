//
//  QSBannerReturnData.m
//  suntry
//
//  Created by 王树朋 on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBannerReturnData.h"
#import "QSBannerDataModel.h"

@implementation QSBannerReturnData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    //mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"headerData" withMapping:[QSBannerHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSBannerHeaderData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    //mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"bannerList" withMapping:[QSBannerDataModel objectMapping]]];
    
    
    return shared_mapping;
    
}

@end