//
//  QSWSettingItem.h
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^QSWSettingItemOperation)();       //!<回调点击cell的操作
/*!
 *  @author wangshupeng, 15-02-15 10:02:32
 *
 *  @brief  定义tabbleview的基本模型，供其它模型调用
 *
 *  @since 1.0.0
 */
@interface QSWSettingItem : NSObject
@property (nonatomic, copy) NSString *icon;     //!<cell的头像
@property (nonatomic, copy) NSString *title;    //!<cell的标题
@property (nonatomic, copy) NSString *subtitle; //!<cell的子标题
@property (nonatomic, retain) id property;      //!<指向属性

@property (nonatomic, copy) QSWSettingItemOperation operation;

/*!
 *  @author wangshupeng, 15-02-15 10:02:38
 *
 *  @brief  每行cell的处始化方法
 *
 *  @param icon     cell的头像
 *  @param title    主标题
 *  @param subtitle 子标题
 *
 *  @return 返回每行cell的内容
 *
 *  @since 1.0.0
 */
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subtitle:(NSString *)subtitle;
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)item;

@end
