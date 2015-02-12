//
//  QSAspecialReturnData.h
//  suntry
//
//  Created by 王树朋 on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGModel.h"

/*!
 *  @author wangshupeng, 15-02-11 18:02:10
 *
 *  @brief  每日特价对象数据解析
 *
 *  @since 1.0.0
 */
@class QSAspecialHeaderData;
@interface QSAspecialReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSAspecialHeaderData *aspecialHeaderData;//!<msg头信息

@end

@interface QSAspecialHeaderData : QSMSGModel

@property (nonatomic,retain) NSArray *specialList;//!<优惠信息数组

@end