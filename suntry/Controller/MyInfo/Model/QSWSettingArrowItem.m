//
//  QSWSettingArrowItem.m
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//
#import "QSWSettingArrowItem.h"

@implementation QSWSettingArrowItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subtitle:(NSString *)subtitle destVcClass:(Class)destVcClass
{

    QSWSettingArrowItem *item = [self itemWithIcon:icon title:title subtitle:subtitle ];
    item.destVcClass = destVcClass;
    return item;
}

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass
{
    
    QSWSettingArrowItem *item = [self itemWithIcon:icon title:title];
    item.destVcClass = destVcClass;
    return item;
    
}

+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass
{
    
    return [self itemWithIcon:nil title:title destVcClass:destVcClass];
    
}
@end
