//
//  QSStoredCardDataModel.h
//  suntry
//
//  Created by 王树朋 on 15/2/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSStoredCardDataModel : QSBaseModel

@property (nonatomic, copy) NSString *userID;     //!<用户ID
@property (nonatomic, copy) NSString *remark;     //!<余额
@property (nonatomic, copy) NSString *merID;      //!<商家ID
@property (nonatomic, copy) NSString *createTime; //!<充值时间
@property (nonatomic, copy) NSString *amount;     //!<充值金额
@property (nonatomic, copy) NSString *type;       //!<类型

@end
