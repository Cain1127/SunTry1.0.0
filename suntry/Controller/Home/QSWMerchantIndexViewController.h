//
//  QSWMerchantIndexViewController.h
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSWMerchantIndexViewController : UIViewController

/*!
 *  @author wangshupeng, 15-02-11 17:02:17
 *
 *  @brief  初始化地区ID与地区名称信息
 *
 *  @param distictID    地区ID
 *  @param districtName 地区名称
 *
 *  @return 处始化值
 *
 *  @since 1.0.0
 */
- (instancetype)initWithID:(NSString *)distictID andDistictName:(NSString *)districtName;

///摇一摇按钮事件
- (IBAction)sharkButtonClick:(id)sender;

///美味套餐按钮事件
- (IBAction)packageButtonClick:(id)sender;

///车车去哪儿按钮事件
- (IBAction)carButtonClick:(id)sender;

///客服按钮事件
- (IBAction)customButtonClick:(id)sender;

///更多按钮事件
- (IBAction)moreButtonClick:(id)sender;

@end
