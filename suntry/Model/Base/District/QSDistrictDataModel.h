//
//  QSDistrictDataModel.h
//  suntry
//
//  Created by 王树朋 on 15/2/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSDistrictDataModel : QSBaseModel

@property (nonatomic,copy) NSString *districtID;//!<区的ID
@property (nonatomic,copy) NSString *val;       //!<区的显示名字
@property (nonatomic,copy) NSString *status;    //!<是否可配送1-可配送

@end
