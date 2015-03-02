//
//  QSPShakeFoodView.h
//  suntry
//
//  Created by CoolTea on 15/2/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SHAKEVIEW_BACKGROUND_COLOR                  [UIColor colorWithWhite:0 alpha:0.6]


@class QSPShakeFoodView;

@protocol QSPShakeFoodViewDelegate<NSObject>

- (void)changedWithData:(id)foodData inView:(QSPShakeFoodView*)popFoodView;

@end

typedef enum
{
    FoodDetailPopViewTypeNormal = 0,
    FoodDetailPopViewTypeShake = 1,
}FoodDetailPopViewType;

@interface QSPShakeFoodView : UIView

@property(nonatomic,assign) id<QSPShakeFoodViewDelegate> delegate;

@property(nonatomic,assign) FoodDetailPopViewType currentViewType;

+ (instancetype)getShakeFoodView;

- (void)showShakeFoodView;

- (void)hideShakeFoodView;

- (void)updateFoodData:(id)data;

- (id)getFoodData;

@end
