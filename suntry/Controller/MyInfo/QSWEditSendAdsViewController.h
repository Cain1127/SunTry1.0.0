//
//  QSWEditSendAdsViewController.h
//  suntry
//
//  Created by 王树朋 on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWSettingViewController.h"

@class QSUserAddressDataModel;
@interface QSWEditSendAdsViewController : QSWSettingViewController

/**
 *  @author         yangshengmeng, 15-02-13 11:02:53
 *
 *  @brief          根据给定的地址模型，进入地址编辑页面
 *
 *  @param model    地址的数据模型
 *
 *  @return         返回当前创建的地址编辑页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithAddressModel:(QSUserAddressDataModel *)model;

@end
