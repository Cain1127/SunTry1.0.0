//
//  QSAllGoodsDataModel.h
//  suntry
//
//  Created by CoolTea on 15/3/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMSGModel.h"
#import "QSGoodsDataModel.h"

@interface QSAllGoodsDataModel : QSBaseModel

@property (nonatomic,copy) NSString *typeName;          //!<菜品类型名

@property (nonatomic,strong) NSArray  *subGoodsList;    //!<子菜品数组
@property (nonatomic,strong) NSArray  *goodsList;       //!<当前菜品数组

@end


@interface QSAllGoodsSubDataModel : QSBaseModel

@property (nonatomic,copy) NSString *typeName;          //!<菜品类型名

@property (nonatomic,strong) NSArray  *subGoodsList;    //!<子菜品数组
@property (nonatomic,strong) NSArray  *goodsList;       //!<当前菜品数组

@end

@interface QSAllGoodsSubSubDataModel : QSBaseModel

@property (nonatomic,copy) NSString *typeName;          //!<菜品类型名

@property (nonatomic,strong) NSArray  *subGoodsList;    //!<子菜品数组
@property (nonatomic,strong) NSArray  *goodsList;       //!<当前菜品数组

@end
