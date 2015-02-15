//
//  QSWStoredCardCell.h
//  suntry
//
//  Created by 王树朋 on 15/2/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSWStoredCardCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *cTimeLabel;                     //!<时间label
@property (nonatomic, strong) UILabel *cPrcieLabel;                    //!<金额label
@property (nonatomic, strong) UILabel *cBalanceLabel;                  //!<余额label

@end
