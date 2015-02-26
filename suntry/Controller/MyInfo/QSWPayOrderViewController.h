//
//  QSWPayOrderViewController.h
//  suntry
//
//  Created by 王树朋 on 15/2/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSWPayOrderViewController : UIViewController

/**
 *  @author             yangshengmeng, 15-02-23 11:02:17
 *
 *  @brief              根据给定的储值卡ID创建储值卡购买页面
 *
 *  @param storeCarID   当前选择的储值卡ID
 *
 *  @return             返回当前创建的储值卡购买页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithID:(NSString *)storeCarID;

@end
