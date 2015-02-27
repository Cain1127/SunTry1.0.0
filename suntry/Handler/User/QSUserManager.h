//
//  QSUserManager.h
//  suntry
//
//  Created by ysmeng on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QSUserInfoDataModel;
@interface QSUserManager : NSObject

/**
 *  @author yangshengmeng, 15-02-27 12:02:13
 *
 *  @brief  从服务端更新用户信息
 *
 *  @since  1.0.0
 */
+ (void)updateUserData:(void(^)(BOOL flag))callBack;

/**
 *  @author yangshengmeng, 15-02-27 12:02:39
 *
 *  @brief  返回当前用户的所有信息
 *
 *  @return 反回用户信息
 *
 *  @since  1.0.0
 */
+ (QSUserInfoDataModel *)getCurrentUserData;

@end
