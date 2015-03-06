//
//  QSBaseModel.m
//  suntry
//
//  Created by 王树朋 on 15/2/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@implementation QSBaseModel

+ (RKObjectMapping *)objectMapping
{

    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    return shared_mapping;

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{

    if (self = [super init]) {
        
        
        
    }
    
    return self;

}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    
    
}


/**
 *  主要用于将价格进行五内递增，规则如下：
 *  12.00 -> 12.0
 *  12.09 -> 12.0
 *  12.49 -> 12.5
 *  12.50 -> 12.5
 *  12.51 -> 13.0
 *  12.99 -> 13.0
 *
 *  @param pirce 要处理的菜品价格
 *
 *  @return 返回处理后的菜品价格
 */
- (NSString*)computePriceWith5:(NSString*)pirce
{
    CGFloat specialPricef = ((int)(pirce.floatValue * 10))*0.1;
    
    NSInteger intTemp = (int)specialPricef;
    
    if (specialPricef < intTemp+0.1) {
        specialPricef = intTemp;
    }else if (specialPricef <= intTemp+0.5) {
        specialPricef = intTemp+0.5;
    }else {
        specialPricef = intTemp+1;
    }
    
    NSString *specialPrice = [NSString stringWithFormat:@"%.1f",specialPricef];

    return specialPrice;
    
}

@end
