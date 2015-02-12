//
//  QSGoodsListReturnData.h
//  suntry
//
//  Created by CoolTea on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGModel.h"

@interface QSGoodsListAllData : QSMSGModel

@property (nonatomic,retain) NSArray *goodsList;//!<菜品数组

@end

@interface QSGoodsListReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSGoodsListAllData *goodsListAllData;//!<msg头信息;

@end
