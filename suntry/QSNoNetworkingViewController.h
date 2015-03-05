//
//  QSNoNetworkingViewController.h
//  suntry
//
//  Created by 王树朋 on 15/3/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSNoNetworkingViewController : UIViewController

- (instancetype)initWithCallBack:(void(^)(void))callBack;

/*!
 *  @author     wangshupeng, 15-03-05 13:03:08
 *
 *  @brief      根据给定的返回步长，创建无网络显示页面
 *
 *  @param step 返回的步长
 *
 *  @return     返回无网络页面
 *
 *  @since      1.0.0
 */
- (instancetype)initWithTurnBackStep:(int)step andRefreshBlock:(void(^)(BOOL flag))refreshCallBack;

@end

