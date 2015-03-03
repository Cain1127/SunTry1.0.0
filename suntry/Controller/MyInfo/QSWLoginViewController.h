//
//  QSWLoginViewController.h
//  suntry
//
//  Created by 王树朋 on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWSettingViewController.h"

@interface QSWLoginViewController : QSWSettingViewController

///登录成功后的回调
@property (nonatomic,copy) void(^loginSuccessCallBack)(BOOL flag);

@end