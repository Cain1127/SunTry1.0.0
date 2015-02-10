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

@interface QSPShoppingCarView : UIView

@property(nonatomic,assign) id<QSPShoppingCarViewDelegate> delegate;

+ (instancetype)getShoppingCarView;

- (void)addGood:(id)goodData;

- (void)removeGood:(id)goodData;

- (NSArray*)getGoods;

- (void)clearShoopingCar;

- (void)updateShoppingCar;

- (void)changeGoods:(id)goodData withCount:(NSInteger)count;

@end
