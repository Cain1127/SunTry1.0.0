//
//  QSWSettingGroup.h
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface QSWSettingGroup : NSObject
@property (copy, nonatomic) NSString *header;//!<组头部
@property (copy, nonatomic) NSString *footer;//!<组脚部
@property (strong, nonatomic) NSArray *items;//!<组数

+ (instancetype)group;
@end
