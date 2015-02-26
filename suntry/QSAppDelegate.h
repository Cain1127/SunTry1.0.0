//
//  QSAppDelegate.h
//  suntry
//
//  Created by ysmeng on 15/2/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

///支付宝支付的回调block
@property (nonatomic,copy) void(^alixPayCallBack)(NSString *payCode,NSString *payInfo);

@end
