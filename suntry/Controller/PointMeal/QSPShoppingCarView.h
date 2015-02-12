//
//  QSPShoppingCarView.h
//  suntry
//
//  Created by CoolTea on 15/2/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

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

//+ (instancetype)getShoppingCarView;
- (instancetype)initShakeFoodView;

- (void)setProcessType:(ProcessType)type;

- (void)addGood:(id)goodData;

- (void)removeGood:(id)goodData;

- (NSArray*)getGoods;

- (void)clearShoopingCar;

- (void)updateShoppingCar;

- (void)changeGoods:(id)goodData withCount:(NSInteger)count;

@end
