//
//  QSRegisterDataModel.m
//  suntry
//
//  Created by 王树朋 on 15/2/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSRegisterDataModel.h"

@implementation QSRegisterDataModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{
                                  @"account_name" : @"userName",
                                  };
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    return shared_mapping;
    
}
@end
