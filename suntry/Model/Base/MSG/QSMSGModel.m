//
//  QSMSGModel.m
//  suntry
//
//  Created by 王树朋 on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMSGModel.h"

@implementation QSMSGModel

+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    [shared_mapping addAttributeMappingsFromArray:@[@"total_page",
                                                    @"total_num",
                                                    @"page_num",
                                                    @"before_page",
                                                    @"per_page",
                                                    @"next_page"]];
    
    return shared_mapping;
    
}

@end
