//
//  QSWMyCouponViewController.h
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSCouponInfoDataModel;
@interface QSWMyCouponViewController : UIViewController

/**
 *  @author         yangshengmeng, 15-03-05 10:03:59
 *
 *  @brief          创建一个选择优惠券的优惠卷列表
 *
 *  @param callBack 选择一张优惠券时的回调
 *
 *  @return         返回当前优惠券选择窗口
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPickedCallBack:(void(^)(BOOL flag,QSCouponInfoDataModel *couponModel))callBack;

@end
