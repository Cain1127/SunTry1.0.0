//
//  QSPOrderSubmitedStateViewController.m
//  suntry
//
//  Created by CoolTea on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderSubmitedStateViewController.h"
#import "QSBlockButton.h"
#import "ImageHeader.h"
#import "QSLabel.h"
#import "DeviceSizeHeader.h"

#define ORDER_SUBMITED_VIEWCONTROLLER_NAV_TITLE_FONT_SIZE   17.
#define ORDER_SUBMITED_VIEWCONTROLLER_TITLE_FONT_SIZE       28.
#define ORDER_SUBMITED_VIEWCONTROLLER_TITLE_COLOR           [UIColor colorWithRed:0.503 green:0.183 blue:0.236 alpha:1.000]
#define ORDER_SUBMITED_VIEWCONTROLLER_CONTENT_FONT_SIZE     15.
#define ORDER_SUBMITED_VIEWCONTROLLER_CONTENT_COLOR         [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]
#define ORDER_SUBMITED_VIEWCONTROLLER_BUTTON_COLOR          [UIColor colorWithRed:0.471 green:0.176 blue:0.224 alpha:1.000]


@interface QSPOrderSubmitedStateViewController ()

@end

@implementation QSPOrderSubmitedStateViewController

@synthesize paymentSate;

- (void)loadView{
    
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    QSBlockButtonStyleModel *backButtonStyle = [[QSBlockButtonStyleModel alloc] init];
    [backButtonStyle setImagesNormal:IMAGE_NAVIGATIONBAR_BACK_NORMAL];
    [backButtonStyle setImagesHighted:IMAGE_NAVIGATIONBAR_MEINFO_HIGHLIGHTED];
    
    UIButton *backButton = [UIButton createBlockButtonWithFrame:CGRectMake(0, 0, 44, 44) andButtonStyle:backButtonStyle andCallBack:^(UIButton *button) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:ORDER_SUBMITED_VIEWCONTROLLER_NAV_TITLE_FONT_SIZE]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"支付订单"];
    self.navigationItem.titleView = navTitle;
    
    QSLabel *stateLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0, 80, SIZE_DEVICE_WIDTH, 20)];
    [stateLabel setTextColor:ORDER_SUBMITED_VIEWCONTROLLER_TITLE_COLOR];
    [stateLabel setTextAlignment:NSTextAlignmentCenter];
    [stateLabel setFont:[UIFont boldSystemFontOfSize:ORDER_SUBMITED_VIEWCONTROLLER_TITLE_FONT_SIZE]];
    [stateLabel setText:@"订单提交成功！"];
    [self.view addSubview:stateLabel];
    
    UIImageView *succeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_submit_sucess_logo"]];
    [succeView setCenter:self.view.center];
    [succeView setFrame:CGRectMake(succeView.frame.origin.x, stateLabel.frame.origin.y+stateLabel.frame.size.height+20, succeView.frame.size.width, succeView.frame.size.height)];
    [self.view addSubview:succeView];
    
    QSLabel *infoLabel = [[QSLabel alloc] initWithFrame:CGRectMake(20, succeView.frame.origin.y+succeView.frame.size.height+20, SIZE_DEVICE_WIDTH-40, 50)];
    [infoLabel setFont:[UIFont systemFontOfSize:ORDER_SUBMITED_VIEWCONTROLLER_CONTENT_FONT_SIZE]];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [infoLabel setNumberOfLines:2];
    [infoLabel setText:@"订单已提交，请等候受理。每月不能出现2次的无效下单，请珍惜你的信用度。"];
    [infoLabel setTextColor:ORDER_SUBMITED_VIEWCONTROLLER_CONTENT_COLOR];
    [self.view addSubview:infoLabel];
    
    //查看详情-左下按钮
    QSBlockButtonStyleModel *checkOrderBtStyleModel = [QSBlockButtonStyleModel alloc];
    checkOrderBtStyleModel.bgColor  = ORDER_SUBMITED_VIEWCONTROLLER_BUTTON_COLOR;
    checkOrderBtStyleModel.title    = @"查看订单详情";
    checkOrderBtStyleModel.titleNormalColor = [UIColor whiteColor];
    checkOrderBtStyleModel.cornerRadio = 6.;
    UIButton *checkOrderBt = [UIButton createBlockButtonWithFrame:CGRectMake(30/375.*SIZE_DEVICE_WIDTH, infoLabel.frame.origin.y+infoLabel.frame.size.height+16, 150/375.*SIZE_DEVICE_WIDTH, 45) andButtonStyle:checkOrderBtStyleModel andCallBack:^(UIButton *button) {
        
        NSLog(@"checkOrderBtl");
        
        [self.tabBarController setSelectedIndex:2];
        
    }];
    
    [self.view addSubview:checkOrderBt];
    
    //继续订餐-右下按钮
    QSBlockButtonStyleModel *goonOrderBtStyleModel = [QSBlockButtonStyleModel alloc];
    goonOrderBtStyleModel.bgColor  = ORDER_SUBMITED_VIEWCONTROLLER_BUTTON_COLOR;
    goonOrderBtStyleModel.title    = @"继续订餐";
    goonOrderBtStyleModel.titleNormalColor = [UIColor whiteColor];
    goonOrderBtStyleModel.cornerRadio = 6.;
    UIButton *goonOrderBt = [UIButton createBlockButtonWithFrame:CGRectMake((375-30)/375.*SIZE_DEVICE_WIDTH-checkOrderBt.frame.size.width, checkOrderBt.frame.origin.y, checkOrderBt.frame.size.width, checkOrderBt.frame.size.height) andButtonStyle:goonOrderBtStyleModel andCallBack:^(UIButton *button) {
        
        NSLog(@"goonOrderBtl");
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
    [self.view addSubview:goonOrderBt];
    
    if (!paymentSate) {
        
        [stateLabel setText:@"订单支付失败！"];
        [succeView setImage:[UIImage imageNamed:@"失败图片"]];
        [infoLabel setText:@"订单支付失败，您可以在订单查询->订单详情中继续支付您的订单。"];
        [goonOrderBt setTitle:@"重新点餐" forState:UIControlStateNormal];
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
