//
//  QSPPayForOrderViewController.h
//  suntry
//
//  Created by CoolTea on 15/2/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSOrderInfoDataModel.h"

@interface QSPPayForOrderViewController : UIViewController

@property(nonatomic,strong) QSOrderInfoDataModel *orderFormModel;

@property (nonatomic, assign) BOOL returnPrePage;   //返回键 设置返回前一页，默认返回根页面

@end
