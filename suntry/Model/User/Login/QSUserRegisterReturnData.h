//
//  QSUserRegisterReturnData.h
//  suntry
//
//  Created by 王树朋 on 15/2/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSRegisterDataModel.h"
@interface QSUserRegisterReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSRegisterDataModel *RegisterList;//!<地址数组

@end
