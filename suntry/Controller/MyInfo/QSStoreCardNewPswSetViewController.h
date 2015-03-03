//
//  QSStoreCardNewPswSetViewController.h
//  suntry
//
//  Created by ysmeng on 15/3/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSStoreCardNewPswSetViewController : UIViewController

/**
 *  @author         yangshengmeng, 15-03-02 18:03:30
 *
 *  @brief          根据手机号码和验证码，更新储值卡支付密码
 *
 *  @param phone    手机号码
 *  @param vercode  验证码
 *
 *  @return         返回更新密码页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPhone:(NSString *)phone andVerticode:(NSString *)vercode;

@end
