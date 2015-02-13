//
//  QSWTextFieldItem.h
//  suntry
//
//  Created by 王树朋 on 15/2/7.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWSettingItem.h"

@interface QSWTextFieldItem :QSWSettingItem

@property (nonatomic,assign) id<UITextFieldDelegate> delegate;//!<UITextField的代理

/**
 *  @author         yangshengmeng, 15-02-13 15:02:49
 *
 *  @brief          按给定的代理，创建一个输入框的自定义cell
 *
 *  @param title    textField的placeHold信息
 *  @param delegate textField的代理
 *
 *
 *  @since          1.0.0
 */
+ (instancetype)itemWithTitle:(NSString *)title andDelegate:(id<UITextFieldDelegate>)delegate;

@end
