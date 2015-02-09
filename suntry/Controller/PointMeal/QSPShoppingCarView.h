//
//  QSPShoppingCarView.h
//  suntry
//
//  Created by CoolTea on 15/2/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSPShoppingCarView : UIView

+ (instancetype)getshoppingCarView;

- (void)addGood:(id)goodData;

- (void)removeGood:(id)goodData;

- (NSArray*)getGoods;

- (void)clearShoopingCar;

- (void)updateShoppingCar;

@end
