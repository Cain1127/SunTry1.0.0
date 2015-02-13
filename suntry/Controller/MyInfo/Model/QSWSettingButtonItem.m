//
//  QSWSettingButtonItem.m
//  suntry
//
//  Created by 王树朋 on 15/2/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWSettingButtonItem.h"

@implementation QSWSettingButtonItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subtitle:(NSString *)subtitle destVcClass:(Class)destVcClass
{
    
    QSWSettingButtonItem *item = [self itemWithIcon:icon title:title subtitle:subtitle ];
    item.destVcClass = destVcClass;
    return item;
}

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass
{
    QSWSettingButtonItem *item = [self itemWithIcon:icon title:title];
    item.destVcClass = destVcClass;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass
{
    return [self itemWithIcon:nil title:title destVcClass:destVcClass];
}
@end
