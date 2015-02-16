//
//  QSUserCouponListReturnData.h
//  suntry
//
//  Created by ysmeng on 15/2/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGModel.h"

@class QSUserCouponListHeaderData;
@interface QSUserCouponListReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSUserCouponListHeaderData *couponListHeader;//!<优惠券列表msg数据

@end

@interface QSUserCouponListHeaderData : QSMSGModel

@property (nonatomic,retain) NSArray *couponList;//!<优惠券列表数据

@end