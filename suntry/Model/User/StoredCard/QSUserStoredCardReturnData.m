//
//  QSUserStoredCard.m
//  suntry
//
//  Created by 王树朋 on 15/2/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSUserStoredCardReturnData.h"
#import "QSStoredCardDataModel.h"

@implementation QSUserStoredCardReturnData
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"storedCardListData" withMapping:[QSStoredCardListData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSStoredCardListData

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///mapping字典
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"storedCardList" withMapping:[QSStoredCardDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
