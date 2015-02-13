//
//  QSUserAddressListReturnData.h
//  suntry
//
//  Created by ysmeng on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSUserAddressDataModel.h"

/**
 *  @author yangshengmeng, 15-02-13 10:02:33
 *
 *  @brief  用户的送餐地址列表数据返回
 *
 *  @since  1.0.0
 */
@interface QSUserAddressListReturnData : QSHeaderDataModel

@property (nonatomic,retain) NSArray *addressList;//!<地址数组

@end
