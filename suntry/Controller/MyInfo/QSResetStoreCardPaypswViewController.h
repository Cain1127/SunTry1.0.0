//
//  QSResetStoreCardPaypswViewController.h
//  suntry
//
//  Created by ysmeng on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSResetStoreCardPaypswViewController : UIViewController

/**
 *  @author                 yangshengmeng, 15-03-05 13:03:34
 *
 *  @brief                  根据返回时执行的block创建储值卡密码设置页
 *
 *  @param turnBackBlock    返回时的回调block
 *
 *  @return                 返回储值卡支付密码设置页面
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithTurnBackBlock:(void(^)(BOOL))turnBackBlock;

@end
