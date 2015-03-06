//
//  QSBaseModel.h
//  suntry
//
//  Created by 王树朋 on 15/2/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restkit.h"
#import "QSDataMappingManager.h"

@interface QSBaseModel : NSObject <QSDataMappingProtocol,NSCoding>

- (NSString*)computePriceWith5:(NSString*)pirce;

@end
