//
//  QSPPayForOrderViewController.m
//  suntry
//
//  Created by CoolTea on 15/2/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPPayForOrderViewController.h"
#import "QSBlockButton.h"
#import "ImageHeader.h"
#import "QSLabel.h"
#import "DeviceSizeHeader.h"
#import<CoreText/CoreText.h>
#import "QSPAddNewAddressTextField.h"
#import "QSWForgetPswController.h"
#import "QSPOrderSubmitedStateViewController.h"
#import "QSUserInfoDataModel.h"
#import <CommonCrypto/CommonDigest.h>
#import "QSRequestManager.h"
#import "MBProgressHUD.h"
#import "QSHeaderDataModel.h"
#import "QSResetStoreCardPaypswViewController.h"
#import "QSStoreCardForgetPswViewController.h"
#import "QSUserManager.h"

#define PAY_FOR_ORDER_TITLE_FONT_SIZE       15.
#define PAY_FOR_ORDER_TEXT_COLOR            [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]
#define PAY_FOR_ORDER_LINE_COLOR            [UIColor colorWithRed:206/255. green:208/255. blue:210/255. alpha:1]
#define PAY_FOR_ORDER_COUNT_TEXT_COLOR      [UIColor colorWithRed:0.503 green:0.183 blue:0.236 alpha:1.000]
#define PAY_FOR_ORDER_BUTTON_FONT_SIZE       17.

@interface QSPPayForOrderViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) QSLabel *foodCounLabel;
@property(nonatomic,strong) QSLabel *orderPriceLabel;
@property(nonatomic,strong) QSLabel *userBalanceLabel;
@property(nonatomic,strong) QSPAddNewAddressTextField *payCardPassTextField;

@end

@implementation QSPPayForOrderViewController
@synthesize orderFormModel;

- (void)loadView{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"支付订单"];
    self.navigationItem.titleView = navTitle;
    
    QSBlockButtonStyleModel *backButtonStyle = [[QSBlockButtonStyleModel alloc] init];
    [backButtonStyle setImagesNormal:IMAGE_NAVIGATIONBAR_BACK_NORMAL];
    [backButtonStyle setImagesHighted:IMAGE_NAVIGATIONBAR_MEINFO_HIGHLIGHTED];
    
    UIButton *backButton = [UIButton createBlockButtonWithFrame:CGRectMake(0, 0, 44, 44) andButtonStyle:backButtonStyle andCallBack:^(UIButton *button) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    CGFloat offsetY = 3;
    if ([[UIDevice currentDevice].systemVersion doubleValue] == 7.0) {
        offsetY = 64+3;
    }
    //菜单份数
    QSLabel *foodCountLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, offsetY+(44-17)/2, SIZE_DEVICE_WIDTH-24, 17)];
    [foodCountLabel setFont:[UIFont systemFontOfSize:PAY_FOR_ORDER_TITLE_FONT_SIZE]];
    [foodCountLabel setBackgroundColor:[UIColor clearColor]];
    [foodCountLabel setText:@"菜单份数"];
    [foodCountLabel setTextColor:PAY_FOR_ORDER_TEXT_COLOR];
    [self.view addSubview:foodCountLabel];
    
    self.foodCounLabel = [[QSLabel alloc] initWithFrame:CGRectMake(foodCountLabel.frame.origin.x, foodCountLabel.frame.origin.y, foodCountLabel.frame.size.width-20, foodCountLabel.frame.size.height)];
    [self.foodCounLabel setFont:[UIFont boldSystemFontOfSize:PAY_FOR_ORDER_TITLE_FONT_SIZE]];
    [self.foodCounLabel setBackgroundColor:[UIColor clearColor]];
    [self.foodCounLabel setText:orderFormModel.diet_num];
    [self.foodCounLabel setTextAlignment:NSTextAlignmentRight];
    [self.foodCounLabel setTextColor:PAY_FOR_ORDER_COUNT_TEXT_COLOR];
    [self.view addSubview:self.foodCounLabel];
    
    QSLabel *foodCountLastLabel = [[QSLabel alloc] initWithFrame:foodCountLabel.frame];
    [foodCountLastLabel setFont:[UIFont systemFontOfSize:PAY_FOR_ORDER_TITLE_FONT_SIZE]];
    [foodCountLastLabel setBackgroundColor:[UIColor clearColor]];
    [foodCountLastLabel setText:@"份"];
    [foodCountLastLabel setTextAlignment:NSTextAlignmentRight];
    [foodCountLastLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:foodCountLastLabel];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(12, offsetY+44, SIZE_DEVICE_WIDTH-24, 1)];
    [lineView1 setBackgroundColor:PAY_FOR_ORDER_LINE_COLOR];
    [self.view addSubview:lineView1];

    //订单金额
    QSLabel *orderPriceLabel = [[QSLabel alloc] initWithFrame:CGRectMake(foodCountLabel.frame.origin.x, lineView1.frame.origin.y+lineView1.frame.size.height+(44-17)/2, foodCountLabel.frame.size.width, foodCountLabel.frame.size.height)];
    [orderPriceLabel setFont:[UIFont systemFontOfSize:PAY_FOR_ORDER_TITLE_FONT_SIZE]];
    [orderPriceLabel setBackgroundColor:[UIColor clearColor]];
    [orderPriceLabel setText:@"订单金额"];
    [orderPriceLabel setTextColor:PAY_FOR_ORDER_TEXT_COLOR];
    [self.view addSubview:orderPriceLabel];
    
    self.orderPriceLabel = [[QSLabel alloc] initWithFrame:CGRectMake(orderPriceLabel.frame.origin.x, orderPriceLabel.frame.origin.y, orderPriceLabel.frame.size.width, orderPriceLabel.frame.size.height)];
    [self.orderPriceLabel setFont:[UIFont boldSystemFontOfSize:PAY_FOR_ORDER_TITLE_FONT_SIZE]];
    [self.orderPriceLabel setBackgroundColor:[UIColor clearColor]];
    [self.orderPriceLabel setTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:self.orderPriceLabel];
    
    // 订单价格
    NSString *price = orderFormModel.payPrice;
    NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",price]];
    [priceString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,1)];
    [priceString addAttribute:NSForegroundColorAttributeName value:PAY_FOR_ORDER_COUNT_TEXT_COLOR range:NSMakeRange(1,price.length)];
    [priceString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:PAY_FOR_ORDER_TITLE_FONT_SIZE] range:NSMakeRange(0, 1)];
    [priceString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:PAY_FOR_ORDER_TITLE_FONT_SIZE] range:NSMakeRange(1, price.length)];
    [self.orderPriceLabel setAttributedText:priceString];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(lineView1.frame.origin.x, lineView1.frame.origin.y+lineView1.frame.size.height+44, lineView1.frame.size.width, lineView1.frame.size.height)];
    [lineView2 setBackgroundColor:PAY_FOR_ORDER_LINE_COLOR];
    [self.view addSubview:lineView2];
    
    //储值卡账户余额
    QSLabel *userBalanceLabel = [[QSLabel alloc] initWithFrame:CGRectMake(foodCountLabel.frame.origin.x, lineView2.frame.origin.y+lineView2.frame.size.height+(44-17)/2, foodCountLabel.frame.size.width, foodCountLabel.frame.size.height)];
    [userBalanceLabel setFont:[UIFont systemFontOfSize:PAY_FOR_ORDER_TITLE_FONT_SIZE]];
    [userBalanceLabel setBackgroundColor:[UIColor clearColor]];
    [userBalanceLabel setText:@"储值卡账户余额"];
    [userBalanceLabel setTextColor:PAY_FOR_ORDER_TEXT_COLOR];
    [self.view addSubview:userBalanceLabel];
    
    self.userBalanceLabel = [[QSLabel alloc] initWithFrame:CGRectMake(userBalanceLabel.frame.origin.x, userBalanceLabel.frame.origin.y, userBalanceLabel.frame.size.width, userBalanceLabel.frame.size.height)];
    [self.userBalanceLabel setFont:[UIFont boldSystemFontOfSize:PAY_FOR_ORDER_TITLE_FONT_SIZE]];
    [self.userBalanceLabel setBackgroundColor:[UIColor clearColor]];
    [self.userBalanceLabel setTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:self.userBalanceLabel];
    
    ///用户信息模型
    QSUserInfoDataModel *userModel = [QSUserInfoDataModel userDataModel];
    NSString *balance = userModel.balance;
    NSMutableAttributedString *balanceString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",balance]];
    [balanceString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,1)];
    [balanceString addAttribute:NSForegroundColorAttributeName value:PAY_FOR_ORDER_COUNT_TEXT_COLOR range:NSMakeRange(1,balance.length)];
    [balanceString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:PAY_FOR_ORDER_TITLE_FONT_SIZE] range:NSMakeRange(0, 1)];
    [balanceString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:PAY_FOR_ORDER_TITLE_FONT_SIZE] range:NSMakeRange(1, balance.length)];
    [self.userBalanceLabel setAttributedText:balanceString];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(lineView2.frame.origin.x, lineView2.frame.origin.y+lineView2.frame.size.height+44, lineView2.frame.size.width, lineView2.frame.size.height)];
    [lineView3 setBackgroundColor:PAY_FOR_ORDER_LINE_COLOR];
    [self.view addSubview:lineView3];
    
    self.payCardPassTextField = [[QSPAddNewAddressTextField alloc] initWithFrame:CGRectMake(foodCountLabel.frame.origin.x, lineView3.frame.origin.y+lineView3.frame.size.height+12, foodCountLabel.frame.size.width, 44)];
    [self.payCardPassTextField setPlaceholder:@"请输入您的储值卡支付密码"];
    [self.payCardPassTextField setDelegate:self];
    [self.payCardPassTextField setSecureTextEntry:YES];
    [self.view addSubview:self.payCardPassTextField];

    //忘记支付密码按钮
    QSBlockButtonStyleModel *forgetPassBtStyleModel = [QSBlockButtonStyleModel alloc];
    forgetPassBtStyleModel.title    = @"忘记支付密码，请点这里";
    forgetPassBtStyleModel.titleFont = [UIFont systemFontOfSize:PAY_FOR_ORDER_TITLE_FONT_SIZE];
    forgetPassBtStyleModel.titleNormalColor = PAY_FOR_ORDER_TEXT_COLOR;
    UIButton *forgetPassBt = [UIButton createBlockButtonWithFrame:CGRectMake(lineView1.frame.origin.x, _payCardPassTextField.frame.origin.y+_payCardPassTextField.frame.size.height+2, SIZE_DEVICE_WIDTH-12*2, 44) andButtonStyle:forgetPassBtStyleModel andCallBack:^(UIButton *button) {
        
        NSLog(@"forgetPassBtl");
        QSStoreCardForgetPswViewController *VC = [[QSStoreCardForgetPswViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        
    }];
    [forgetPassBt setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];

    [self.view addSubview:forgetPassBt];
    
    //马上支付按钮
    QSBlockButtonStyleModel *submitBtStyleModel = [QSBlockButtonStyleModel alloc];
    submitBtStyleModel.bgColor  = [UIColor colorWithRed:0.471 green:0.176 blue:0.224 alpha:1.000];;
    submitBtStyleModel.title    = @"马上支付";
    submitBtStyleModel.titleNormalColor = [UIColor whiteColor];
    submitBtStyleModel.cornerRadio = 6.;
    UIButton *submitBt = [UIButton createBlockButtonWithFrame:CGRectMake(lineView1.frame.origin.x, forgetPassBt.frame.origin.y+forgetPassBt.frame.size.height+20, SIZE_DEVICE_WIDTH-12*2, 44) andButtonStyle:submitBtStyleModel andCallBack:^(UIButton *button) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSLog(@"submitBtl");
        NSString *pass = [self.payCardPassTextField text];
        if (!pass || [pass isEqualToString:@""]) {
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入储值卡支付密码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return ;
            
        }
        
        //提交支付所需参数
        NSMutableDictionary *tempParams = [[NSMutableDictionary alloc] init];
        [tempParams setObject:userModel.userID forKey:@"user_id"];
        NSString *pay = [NSString stringWithFormat:@"%@%@",userModel.pay_salt,pass];
        /*私有密钥+密码 进行 MD5加密*/
        [tempParams setObject:[self paramsMD5Encryption:pay] forKey:@"pay"];
        [tempParams setObject:orderFormModel.payPrice forKey:@"balance"];
        [tempParams setObject:orderFormModel.order_id forKey:@"order_id"];
        
        [QSRequestManager requestDataWithType:rRequestTypePayJudgeBalanceData andParams:tempParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///隐藏HUD
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            ///支付成功
            if (rRequestResultTypeSuccess == resultStatus) {
                
                ///刷新用户数据
                [QSUserManager updateUserData:nil];
                
                NSLog(@"订单：%@ 支付成功",orderFormModel.order_id);
                //支付成功跳转：
                QSPOrderSubmitedStateViewController *ossVc = [[QSPOrderSubmitedStateViewController alloc] init];
                [ossVc setPaymentSate:YES];
                QSOrderDetailDataModel *orderResultData = [[QSOrderDetailDataModel alloc] init];
                orderResultData.order_id = orderFormModel.order_id;
                orderResultData.order_desc = orderFormModel.des;
                [ossVc setOrderData:orderResultData];
                [self.navigationController pushViewController:ossVc animated:YES];
                
            } else {
                
                QSHeaderDataModel *tempModel = resultData;
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:(tempModel ? ([tempModel.info length] > 0 ? tempModel.info : @"支付失败") : @"支付失败") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [av show];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [av dismissWithClickedButtonIndex:0 animated:YES];
                    
                    //支付失败跳转
                    QSPOrderSubmitedStateViewController *ossVc = [[QSPOrderSubmitedStateViewController alloc] init];
                    [ossVc setPaymentSate:NO];
                    QSOrderDetailDataModel *orderResultData = [[QSOrderDetailDataModel alloc] init];
                    orderResultData.order_id = orderFormModel.order_id;
                    orderResultData.order_desc = orderFormModel.des;
                    [ossVc setOrderData:orderResultData];
                    [self.navigationController pushViewController:ossVc animated:YES];
                    
                });
                
            }
        }];
        
    }];
    [self.view addSubview:submitBt];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self checkHadPayPassWord];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.payCardPassTextField resignFirstResponder];
    return YES;
}

#pragma mark - MD5加密
///MD5加密请求参数
- (NSString *)paramsMD5Encryption:(NSString *)params
{
    
    const char *cStr = [params UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
}

#pragma mark - 判断当前是否有储值卡支付密码
- (void)checkHadPayPassWord
{
    
    QSUserInfoDataModel *userInfoData = [QSUserInfoDataModel userDataModel];
    if (!userInfoData.pay_salt || [userInfoData.pay_salt isEqualToString:@""]) {
        
        //没有支付密码
        QSResetStoreCardPaypswViewController *nopassVc=[[QSResetStoreCardPaypswViewController alloc] init];
        nopassVc.turnBackStep = 3;
        [self.navigationController pushViewController:nopassVc animated:YES];
        
    }
    
}

@end
