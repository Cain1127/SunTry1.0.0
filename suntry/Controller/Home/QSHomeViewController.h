//
//  QSHomeViewController.h
//  SunTry
//
//  Created by 王树朋 on 15/1/31.
//  Copyright (c) 2015年 wangshupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSDistrictDataModel.h"
#import "QSDistrictReturnData.h"

@interface QSHomeViewController : UIViewController

@property (nonatomic,assign) int isFirstLaunch;//!<是否从appdelegate进入
///选择地区后的回调
@property (nonatomic,copy) void(^districtPickedCallBack)(NSString *key,NSString *val);

@end
