//
//  QSAdvertDetailViewController.h
//  suntry
//
//  Created by ysmeng on 15/3/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSAdvertDetailViewController : UIViewController

/**
 *  @author     yangshengmeng, 15-03-03 13:03:15
 *
 *  @brief      根据广告的地址，展示广告详情
 *
 *  @param url  广告地址
 *
 *  @return     返回给定地址的广告详情页
 *
 *  @since      1.0.0
 */
- (instancetype)initWithDetailURL:(NSString *)url andTitle:(NSString *)title;

@end
