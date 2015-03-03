//
//  QSStoreCarInfoCollectionViewCell.h
//  suntry
//
//  Created by ysmeng on 15/3/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSStoreCarInfoCollectionViewCell : UICollectionViewCell

/**
 *  @author         yangshengmeng, 15-03-03 19:03:05
 *
 *  @brief          根据给定的可购买储值卡信息模型，刷新储值卡信息cellUI
 *
 *  @param model    数据模型
 *
 *  @since          1.0.0
 */
- (void)updateStoreCardInfoCellUI:(id)model;

@end
