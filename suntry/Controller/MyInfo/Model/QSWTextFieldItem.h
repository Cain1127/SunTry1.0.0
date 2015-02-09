//
//  QSWTextFieldItem.h
//  suntry
//
//  Created by 王树朋 on 15/2/7.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWSettingItem.h"

@interface QSWTextFieldItem :QSWSettingItem

@property (assign, nonatomic) Class destVcClass;

@property (nonatomic,copy) NSString *placeHolder;

+ (instancetype)itemWithPlaceHolder:(NSString *)placeHolderName;

@end
