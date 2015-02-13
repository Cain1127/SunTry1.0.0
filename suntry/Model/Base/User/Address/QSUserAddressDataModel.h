//
//  QSUserAddressDataModel.h
//  suntry
//
//  Created by ysmeng on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSUserAddressDataModel : QSBaseModel

@property (nonatomic,copy) NSString *addressID; //!<地址ID
@property (nonatomic,copy) NSString *userID;    //!<用户ID
@property (nonatomic,copy) NSString *address;   //!<地址
@property (nonatomic,copy) NSString *phone;     //!<手机号码

@property (nonatomic,copy) NSString *company;   //!<公司名

@property (nonatomic,copy) NSString *status;    //!<状态
@property (nonatomic,copy) NSString *is_master; //!<是否默认送餐地址
@property (nonatomic,copy) NSString *userName;  //!<用户名
@property (nonatomic,copy) NSString *gender;    //!<性别

@end
