//
//  QSBannerReturnData.h
//  suntry
//
//  Created by 王树朋 on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGModel.h"

@class QSBannerHeaderData;
@interface QSBannerReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSBannerHeaderData *headerData;//!<所有广告图片数组

@end

@interface QSBannerHeaderData : QSMSGModel

@property (nonatomic,retain) NSArray *bannerList;//!<所有广告图片数组

@end