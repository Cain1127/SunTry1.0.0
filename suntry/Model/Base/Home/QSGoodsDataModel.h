//
//  QSGoodsDataModel.h
//  suntry
//
//  Created by CoolTea on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSGoodsDataModel : QSBaseModel

@property (nonatomic,copy) NSString *shopkeeperID;      //!<商家ID
@property (nonatomic,copy) NSString *goodsID;           //!<菜品ID
@property (nonatomic,copy) NSString *goodsTypeName;     //!<菜品类型名
@property (nonatomic,copy) NSString *goodsTypeID;       //!<菜品类型ID
@property (nonatomic,copy) NSString *goodsName;         //!<菜品名称
@property (nonatomic,copy) NSString *goodsPrice;        //!<原价
@property (nonatomic,copy) NSString *goodsSpecialPrice; //!<折后价/特价
@property (nonatomic,copy) NSString *goodsImageUrl;     //!<菜品图片
@property (nonatomic,copy) NSString *goodsInstockNum;   //!<菜品库存数量
@property (nonatomic,copy) NSString *beginTime;         //!<开始时间
@property (nonatomic,copy) NSString *overTime;          //!<结束时间

@end
