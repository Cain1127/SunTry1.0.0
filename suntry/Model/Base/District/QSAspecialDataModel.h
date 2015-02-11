//
//  QSAspecialDataModel.h
//  suntry
//
//  Created by 王树朋 on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSAspecialDataModel : QSBaseModel

@property (nonatomic,copy) NSString *merID;//!<商家ID
@property (nonatomic,copy) NSString *goodsID;       //!<特价菜品ID
@property (nonatomic,copy) NSString *goodsName;  //!<特价菜品名称
@property (nonatomic,copy) NSString *goodsPrice;  //!<原价价钱
@property (nonatomic,copy) NSString *specialPrice;  //!<特价价钱
@property (nonatomic,copy) NSString *goodsImage;  //!<特价菜品图片
@property (nonatomic,copy) NSString *beginTime;  //!<开始时间
@property (nonatomic,copy) NSString *overTime;  //!<结束时间

@end
