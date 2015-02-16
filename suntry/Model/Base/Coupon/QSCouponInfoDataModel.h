//
//  QSCouponInfoDataModel.h
//  suntry
//
//  Created by ysmeng on 15/2/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSCouponInfoDataModel : QSBaseModel

@property (nonatomic,copy) NSString *type;      //!<类型
@property (nonatomic,copy) NSString *goods_name;//!<优惠券名
@property (nonatomic,copy) NSString *parent_id; //!<优惠券ID
@property (nonatomic,copy) NSString *pice;      //!<实现的优惠
@property (nonatomic,copy) NSString *banner;    //!<图片

@end