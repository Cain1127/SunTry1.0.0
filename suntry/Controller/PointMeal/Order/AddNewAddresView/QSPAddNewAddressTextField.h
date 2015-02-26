//
//  QSPAddNewAddressTextField.h
//  suntry
//
//  Created by CoolTea on 15/2/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PLACEHOLDER_TEXT_COLOR      [UIColor colorWithRed:0.710 green:0.655 blue:0.541 alpha:1.000]

@interface QSPAddNewAddressTextField : UITextField

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setPlaceholder:(NSString*)str;

@end
