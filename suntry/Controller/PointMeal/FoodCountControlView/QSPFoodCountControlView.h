//
//  QSPFoodCountControlView.h
//  suntry
//
//  Created by CoolTea on 15/2/7.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPFoodCountControlViewDelegate<NSObject>
/**
 *  返回改变后当前的数量
 *
 *  @param count 数量
 */
- (void)changedCount:(NSInteger)count;

@end

@interface QSPFoodCountControlView : UIView

@property(nonatomic,assign) id<SPFoodCountControlViewDelegate> delegate;

- (instancetype)initControlView;//初始化增加减少菜品数量控件

- (void)setMarginTopRight:(CGPoint)marginTopRight;//设置右上角位置

- (NSInteger)getCount;

- (void)setCount:(NSInteger)count;

/**
 *  设置操作过程中是否只显示增加按钮，用在选择菜品列表界面
 *
 *  @param flag YES：只显示增加按钮，NO：默认显示全部按钮
 */
- (void)setOnlyShowAddButton:(BOOL)flag;

@end
