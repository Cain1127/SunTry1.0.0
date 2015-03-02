//
//  QSBannerDataModel.h
//  suntry
//
//  Created by 王树朋 on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSBannerDataModel : QSBaseModel

@property (nonatomic,copy) NSString *bannerUrl;     //!<广告图片
@property (nonatomic,copy) NSString *bannerID;      //!<ID
@property (nonatomic,copy) NSString *merID;         //!<商家ID
@property (nonatomic,copy) NSString *goodsName;     //!<名称
@property (nonatomic,copy) NSString *pice;          //!<价钱
@property (nonatomic,copy) NSString *type;          //!<类型
@property (nonatomic,copy) NSString *beginTime;     //!<开始时间
@property (nonatomic,copy) NSString *overTime;      //!<结束时间
@property (nonatomic,copy) NSString *status;        //!<状态

@end
