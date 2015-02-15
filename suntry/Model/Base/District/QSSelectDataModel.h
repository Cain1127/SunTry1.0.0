//
//  QSSelectDataModel.h
//  suntry
//
//  Created by 王树朋 on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSBaseModel.h"

@interface QSSelectDataModel : QSBaseModel

@property (nonatomic,copy) NSString *streetID;      //!<区的ID
@property (nonatomic,copy) NSString *streetName;    //!<区的显示名字
@property (nonatomic,copy) NSString *isSend;        //!<是否可配送:1-可配送

@end
