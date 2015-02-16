//
//  QSUserInfoDataModel.h
//  suntry
//
//  Created by ysmeng on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSUserInfoDataModel : QSBaseModel

+ (instancetype)userDataModel;

- (void)saveUserData;

@property (nonatomic,copy) NSString *userID;        //!<用户名
@property (nonatomic,copy) NSString *loginName;     //!<登录名
@property (nonatomic,copy) NSString *realName;      //!<真名
@property (nonatomic,copy) NSString *email;         //!<邮件
@property (nonatomic,copy) NSString *phone;         //!<手机号码
@property (nonatomic,copy) NSString *userQQ;        //!<QQ
@property (nonatomic,copy) NSString *type;          //!<用户类型
@property (nonatomic,copy) NSString *status;        //!<账号状态
@property (nonatomic,copy) NSString *gender;        //!<性别
@property (nonatomic,copy) NSString *company;       //!<所在公司名
@property (nonatomic,copy) NSString *pay;           //!<支付密码
@property (nonatomic,copy) NSString *pay_salt;      //!<支付密钥

@property (nonatomic,copy) NSString *addressID;     //!<默认送餐地址ID
@property (nonatomic,copy) NSString *address;       //!<送餐地址
@property (nonatomic,copy) NSString *receidName;    //!<收餐人姓名

@end
