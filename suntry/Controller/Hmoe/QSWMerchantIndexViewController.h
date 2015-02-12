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
 *  @brief  <#Description#>
 *
 *  @param distictID    <#distictID description#>
 *  @param districtName <#districtName description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
- (instancetype)initWithID:(NSString *)distictID andDistictName:(NSString *)districtName;

///摇一摇按钮事件
- (IBAction)sharkButtonClick:(id)sender;

///美味套餐按钮事件
- (IBAction)packageButtonClick:(id)sender;

///车车去哪儿按钮事件
- (IBAction)carButtonClick:(id)sender;

- (IBAction)customButtonClick:(id)sender;

- (IBAction)moreButtonClick:(id)sender;

@end
