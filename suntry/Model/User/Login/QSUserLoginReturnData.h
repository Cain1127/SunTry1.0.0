//
//  QSUserLoginReturnData.h
//  suntry
//
//  Created by ysmeng on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSUserInfoDataModel.h"

@interface QSUserLoginReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSUserInfoDataModel *userInfo;//!<用户信息

@end