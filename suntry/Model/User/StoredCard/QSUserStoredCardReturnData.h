//
//  QSUserStoredCard.h
//  suntry
//
//  Created by 王树朋 on 15/2/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"

#import "QSMSGModel.h"

@class QSStoredCardListData;
@interface QSUserStoredCardReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSStoredCardListData *storedCardListData;//!<msg头信息;

@end

@interface QSStoredCardListData : QSMSGModel

@property (nonatomic,retain) NSArray *storedCardList;//!<充值卡数组

@end