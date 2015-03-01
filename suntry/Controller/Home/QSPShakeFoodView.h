//
//  QSPShakeFoodView.h
//  suntry
//
//  Created by CoolTea on 15/2/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QSPShakeFoodViewDelegate<NSObject>

- (void)changedWithData:(id)foodData;

@end

@interface QSPShakeFoodView : UIView

@property(nonatomic,assign) id<QSPShakeFoodViewDelegate> delegate;

+ (instancetype)getShakeFoodView;

- (void)showShakeFoodView;

- (void)hideShakeFoodView;

- (void)updateFoodData:(id)data;

- (id)getFoodData;

@end
