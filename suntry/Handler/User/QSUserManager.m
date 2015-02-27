//
//  QSUserManager.m
//  suntry
//
//  Created by ysmeng on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSUserManager.h"
#import "QSRequestManager.h"

#import "QSUserLoginReturnData.h"
#import "QSUserInfoDataModel.h"

@implementation QSUserManager

/**
 *  @author yangshengmeng, 15-02-27 12:02:13
 *
 *  @brief  从服务端更新用户信息
 *
 *  @since  1.0.0
 */
+ (void)updateUserData:(void(^)(BOOL flag))callBack
{

    [QSRequestManager requestDataWithType:rRequestTypeReloadUserData andParams:nil andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///下载成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///保存本地用户信息
            QSUserLoginReturnData *tempModel = resultData;
            QSUserInfoDataModel *newUserModel = tempModel.userInfo;
            [newUserModel saveUserData];
            
            ///回调
            callBack(YES);
            
        } else {
        
            callBack(NO);
        
        }
        
    }];

}

/**
 *  @author yangshengmeng, 15-02-27 12:02:39
 *
 *  @brief  返回当前用户的所有信息
 *
 *  @return 反回用户信息
 *
 *  @since  1.0.0
 */
+ (QSUserInfoDataModel *)getCurrentUserData
{

    return [QSUserInfoDataModel userDataModel];

}

@end
