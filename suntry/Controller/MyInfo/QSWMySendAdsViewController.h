//
//  QSWMySendAdsViewController.h
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWSettingViewController.h"

@class QSUserAddressDataModel;
@interface QSWMySendAdsViewController : QSWSettingViewController

/**
 *  @author                     yangshengmeng, 15-03-04 18:03:38
 *
 *  @brief                      如若是选择地送餐地址，则回调所选择的地址
 *
 *  @param pickAddressAction    选择一个地址时的回调
 *
 *  @return                     返回当前地址列表
 *
 *  @since                      1.0.0
 */
- (instancetype)initWithCallBackBlock:(void(^)(BOOL flag,QSUserAddressDataModel *addressModel))pickAddressAction;

@end
