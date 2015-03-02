//
//  QSCarPostionDataModel.h
//  suntry
//
//  Created by 王树朋 on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@class QSCarPostionDataSubModel;
@interface QSCarPostionDataModel : QSBaseModel

@property (nonatomic,copy) NSString *ID;             //!<ID
@property (nonatomic,copy) NSString *carName;        //!<餐车名称
@property (nonatomic,copy) NSString *merID;          //!<商家ID
@property (nonatomic,copy) NSString *status;         //!<状态
@property (nonatomic,copy) NSString *carNum;         //!<餐车号码
@property (nonatomic,copy) NSString *maxNum;         //!<餐车最大号码

@property (nonatomic,strong) QSCarPostionDataSubModel  *postionList;  //!<餐车坐标数据
@end


@interface QSCarPostionDataSubModel : QSBaseModel

@property (nonatomic,copy) NSString *carPostionID;      //!<餐车ID
@property (nonatomic,copy) NSString *carID;             //!<餐车ID
@property (nonatomic,assign) CGFloat latitude;          //!<餐车纬度
@property (nonatomic,assign) CGFloat longitude;         //!<餐车经度
@property (nonatomic,copy) NSString *carTime;           //!<时间



@end
