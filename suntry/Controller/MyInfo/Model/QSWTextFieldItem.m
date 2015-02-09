//
//  QSWTextFieldItem.m
//  suntry
//
//  Created by 王树朋 on 15/2/7.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWTextFieldItem.h"

@implementation QSWTextFieldItem

+ (instancetype)itemWithPlaceHolder:(NSString *)placeHolderName
{
    QSWTextFieldItem *item = [[QSWTextFieldItem alloc]init];
    item.placeHolder = placeHolderName;
    return item;
}

@end
