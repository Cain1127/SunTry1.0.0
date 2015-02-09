//
//  QSPFoodCountControlView.h
//  suntry
//
//  Created by CoolTea on 15/2/7.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSPFoodCountControlView : UIView

- (instancetype)initControlView;//初始化增加减少菜品数量控件

- (void)setMarginTopRight:(CGPoint)marginTopRight;//设置右上角位置

- (NSInteger)getCount;

@end
