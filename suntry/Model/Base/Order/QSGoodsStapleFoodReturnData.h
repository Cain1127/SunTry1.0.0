//
//  QSGoodsStapleFoodReturnData.h
//  suntry
//
//  Created by CoolTea on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSGoodsDataModel.h"

@class QSGoodsStapleFoodHeaderData;
@interface QSGoodsStapleFoodReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSGoodsStapleFoodHeaderData *headerMSG;//!<msg数据

@end

@interface QSGoodsStapleFoodHeaderData : QSBaseModel

@property (nonatomic,retain) NSArray *specialList;  //!<
@property (nonatomic,retain) NSArray *menuPackeList;//!<
@property (nonatomic,retain) NSArray *healthyList;  //!<
@property (nonatomic,retain) NSArray *soupList;     //!<汤品

@end
