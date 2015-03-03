//
//  QSPShoppingCarView.h
//  suntry
//
//  Created by CoolTea on 15/2/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSGoodsDataModel.h"

/**
 *  购物车数据单例
 */
@interface QSPShoppingCarData: NSObject

+ (NSArray*)getShoppingCarDataList;

+ (void)setShoppingCarDataListWithArray:(NSArray*)list;

/**
 *  设置购物车数据
 *
 *  @param data  NSDictionary格式：
                     diet : NSArray         套餐菜品列表
                     goods_id : NSString    菜品ID
                     name : NSString        菜品名称
                     num : NSString         菜品数量
                     sale_id : NSString     菜品商家ID
                     sale_money : NSString  菜品售价
                     num_instock : NSString 菜品库存量
 *  @param count 数量。当添加的数据为套餐时，flag=YES： count为增加的量；  flag=NO： count为设置覆盖的量。
 *  @param flag  YES:添加形式增加套餐数据,主要在菜品选择界面时；  NO:设置覆盖形式设置套餐数据，主要在确认下单界面时。
 */
+ (void)setShoppingCarDataListWithData:(NSDictionary*)data withCount:(NSInteger)count AddOrSetPackageData:(BOOL)flag;

+ (void)clearShoopingCar;

+ (CGFloat)getTotalPrice;

+ (NSInteger)getTotalFoodCount;

+ (NSInteger)searchFoodCountInTheCar:(QSGoodsDataModel*)foodData;


@end


/**
 *  购物车视图
 */


@protocol QSPShoppingCarViewDelegate<NSObject>

- (void)orderWithData:(id)foodData;

@end

/**
    两种样式：
    ProcessTypeOnSubmitOrder： 在下单界面时
    ProcessTypeOnSelectedFood：在选择菜品时
 */
typedef enum
{
    
    ProcessTypeOnSubmitOrder = 1,
    ProcessTypeOnSelectedFood
    
}ProcessType;

@interface QSPShoppingCarView : UIView

@property(nonatomic,assign) id<QSPShoppingCarViewDelegate> delegate;

- (instancetype)initShakeFoodView;

- (void)setProcessType:(ProcessType)type;

- (void)updateShoppingCar;

- (void)changeGoods:(id)goodData withCount:(NSInteger)count;

@end
