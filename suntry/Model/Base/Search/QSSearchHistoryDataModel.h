//
//  QSSearchHistoryDataModel.h
//  suntry
//
//  Created by ysmeng on 15/2/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSSearchHistoryDataModel : QSBaseModel

@property (nonatomic,copy) NSString *title;     //!<选择的区/街道信息
@property (nonatomic,copy) NSString *key;       //!<对应的街道key

@end
