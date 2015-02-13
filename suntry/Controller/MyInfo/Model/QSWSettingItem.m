//
//  QSWSettingItem.m
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWSettingItem.h"

@implementation QSWSettingItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subtitle:(NSString *)subtitle
{
    
    QSWSettingItem *item = [self item];
    item.icon = icon;
    item.title = title;
    item.subtitle = subtitle;
    return item;

}

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    
    QSWSettingItem *item = [self item];
    item.icon = icon;
    item.title = title;
    return item;
    
}

+ (instancetype)itemWithTitle:(NSString *)title
{
    
    return [self itemWithIcon:nil title:title];
    
}

+ (instancetype)item
{
    return [[self alloc] init];
}
@end
