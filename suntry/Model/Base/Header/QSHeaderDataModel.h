//
//  QSHeaderDataModel.h
//  suntry
//
//  Created by 王树朋 on 15/2/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSHeaderDataModel : QSBaseModel

@property (nonatomic,assign) BOOL type;     //!<服务端返回标识：YES-成功
@property (nonatomic,copy) NSString *info;  //!<错误信息

@end
