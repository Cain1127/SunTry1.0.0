//
//  QSPFoodPackageItemView.h
//  suntry
//
//  Created by CoolTea on 15/2/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSPFoodPackageItemGridView.h"

@interface QSPFoodPackageItemView : UIView<QSPFoodPackageItemGridViewDelegate>

- (instancetype)initItemViewWithData:(NSArray*)foodDataList withTypeName:(NSString*)typeName;

- (id)getSelectFoodData;

@end
