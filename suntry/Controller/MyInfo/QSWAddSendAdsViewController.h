//
//  QSWAddSendAdsViewController.h
//  suntry
//
//  Created by 王树朋 on 15/2/7.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWSettingViewController.h"

@interface QSWAddSendAdsViewController : QSWSettingViewController

@property (nonatomic,copy) void(^addSendAddressCallBack)(BOOL);//!<添加送餐地址后的回调

@end
