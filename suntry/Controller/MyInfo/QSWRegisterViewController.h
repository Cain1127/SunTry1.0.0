//
//  QSWRegisterViewController.h
//  suntry
//
//  Created by 王树朋 on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWSettingViewController.h"

@interface QSWRegisterViewController : QSWSettingViewController

///注册成功时的回调
@property (nonatomic,copy) void(^registCallBack)(BOOL flag,NSString *userName,NSString *psw);

@end
