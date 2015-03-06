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
    
    CGFloat specialPricef = pirce.floatValue;
    
    int beforPointIntNum = (int)specialPricef;
    int afterPointFirstOne = ((int)(specialPricef*10))%10;
    
    if (afterPointFirstOne==0) {
        afterPointFirstOne = 0;
    }else if (afterPointFirstOne>0&&afterPointFirstOne<=5) {
        afterPointFirstOne = 5;
    }else if (afterPointFirstOne>5&&afterPointFirstOne<=9) {
        afterPointFirstOne = 0;
        beforPointIntNum += 1;
    }
    
    NSString *beforPoint = [NSString stringWithFormat:@"%d",beforPointIntNum];
    NSString *afterPoint = [NSString stringWithFormat:@"%d",afterPointFirstOne];
    
    NSString *specialPrice = [NSString stringWithFormat:@"%@.%@",beforPoint,afterPoint];
    return specialPrice;
    
}

@end
