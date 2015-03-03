//
//  QSPItemSelectePopView.h
//  suntry
//
//  Created by CoolTea on 15/3/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSPItemSelectePopView;
@protocol QSPItemSelectePopViewDelegate<NSObject>

- (void)selectedItem:(id)data withIndex:(NSInteger)index inView:(QSPItemSelectePopView*)view;

@end

@interface QSPItemSelectePopView : UIView

@property(nonatomic,assign) id<QSPItemSelectePopViewDelegate> delegate;

/**
 *  创建初始化选择弹出界面
 *
 *  @return 选择弹出界面
 */
+ (instancetype)getItemSelectePopView;

/**
 *  显示选择弹出界面
 */
- (void)showItemSelectePopView;

/**
 *  隐藏选择弹出界面
 */
- (void)hideItemSelectePopView;

/**
 *  设置选择数据源
 *
 *  @param data 选择的数据源数组
 */
- (void)updateSelectData:(NSArray*)arrayData;


@end
