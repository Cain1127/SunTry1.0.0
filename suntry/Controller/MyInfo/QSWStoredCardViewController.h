//
//  QSWStoredCardViewController.h
//  suntry
//
//  Created by 王树朋 on 15/2/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSWStoredCardViewController : UIViewController

@property (nonatomic,assign) int pageGap;   //!<返回时的间隔

- (IBAction)chargeButton:(id)sender;        //!<充值储存卡按钮事件

- (IBAction)resetPswButton:(id)sender;      //!<重置储存卡按钮事件

- (IBAction)chargeRecord:(id)sender;        //!<充值记录按钮事件

- (IBAction)consumeRecord:(id)sender;       //!<消费记录按钮事件

@end
