//
//  QSWSettingViewController.h
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author yangshengmeng, 15-02-13 09:02:35
 *
 *  @brief  所有ViewController的底viewController
 *
 *  @since  1.0.0
 */
@class QSWSettingGroup;
@interface QSWSettingViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *groups;//!<数据源

///UITableView的组
- (QSWSettingGroup *)addGroup;

@end
