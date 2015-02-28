//
//  QSOrderDetailGoodsDataModel.h
//  suntry
//
//  Created by CoolTea on 15/2/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSOrderDetailGoodsDataModel : QSBaseModel

@property (nonatomic,copy) NSString *goodsName;         //!<菜品名称
@property (nonatomic,copy) NSString *goodsCount;        //!<菜品数量
@property (nonatomic,copy) NSString *goodsPrice;        //!<菜品单价

@property (nonatomic,strong) NSArray  *subFoodList;     //!<套餐菜品列表


@end

@interface QSOrderDetailGoodsDataSubModel : QSBaseModel

@property (nonatomic,copy) NSString *goodsName;         //!<菜品名称
@property (nonatomic,copy) NSString *goodsCount;        //!<菜品数量
@property (nonatomic,copy) NSString *goodsPrice;        //!<菜品单价

@end
