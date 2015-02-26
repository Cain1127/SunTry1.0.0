//
//  QSPOrderAddNewAddressView.h
//  suntry
//
//  Created by CoolTea on 15/2/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QSPOrderAddNewAddressViewDelegate<NSObject>

- (void)AddNewAddressWithData:(id)data;

@end

@interface QSPOrderAddNewAddressView : UIView<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,assign) id<QSPOrderAddNewAddressViewDelegate> delegate;

/**
 *  创建初始化添加地址界面
 *
 *  @return 添加地址界面
 */
+ (instancetype)getAddNewAddressView;

/**
 *  显示添加地址界面
 */
- (void)showAddNewAddressView;

@end
