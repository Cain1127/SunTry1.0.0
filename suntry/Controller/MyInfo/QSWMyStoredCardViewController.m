//
//  QSWMyStoredCardViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWMyStoredCardViewController.h"
#import "QSBlockButton.h"
#import "ImageHeader.h"
#import "QSLabel.h"
#import "DeviceSizeHeader.h"

#define ORDER_LIST_VIEWCONTROLLER_NAV_TITLE_FONT_SIZE   17.
#define ORDER_LIST_VIEWCONTROLLER_CONTENT_COLOR         [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]
#define ORDER_LIST_VIEWCONTROLLER_CONTENT_FONT_SIZE     17.

@interface QSWMyStoredCardViewController ()

@property (nonatomic, strong) UIView *nodataView;

@end

@implementation QSWMyStoredCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的储值卡";
    
    //没有数据时的显示
    self.nodataView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_nodataView];
    
    UIImageView *nodataImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_list_no_data_logo"]];
    [nodataImgView setCenter:self.view.center];
    [nodataImgView setFrame:CGRectMake(nodataImgView.frame.origin.x, 110/667.*SIZE_DEVICE_HEIGHT, nodataImgView.frame.size.width, nodataImgView.frame.size.height)];
    [_nodataView addSubview:nodataImgView];
    
    QSLabel *infoLabel = [[QSLabel alloc] initWithFrame:CGRectMake(20, nodataImgView.frame.origin.y+nodataImgView.frame.size.height+5, SIZE_DEVICE_WIDTH-40, 50)];
    [infoLabel setFont:[UIFont boldSystemFontOfSize:ORDER_LIST_VIEWCONTROLLER_CONTENT_FONT_SIZE]];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [infoLabel setNumberOfLines:2];
    [infoLabel setTextAlignment:NSTextAlignmentCenter];
    [infoLabel setText:@"您的帐号还没有储值卡，请选择需要购买的储值卡"];
    [infoLabel setTextColor:ORDER_LIST_VIEWCONTROLLER_CONTENT_COLOR];
    [_nodataView addSubview:infoLabel];
    
    QSBlockButtonStyleModel *submitBtStyleModel = [QSBlockButtonStyleModel alloc];
    submitBtStyleModel.bgColor  = [UIColor colorWithRed:0.471 green:0.176 blue:0.224 alpha:1.000];;
    submitBtStyleModel.title    = @"赶紧点一份";
    submitBtStyleModel.titleNormalColor = [UIColor whiteColor];
    submitBtStyleModel.cornerRadio = 6.;
    UIButton *submitBt = [UIButton createBlockButtonWithFrame:CGRectMake((SIZE_DEVICE_WIDTH-245./375.*SIZE_DEVICE_WIDTH)/2, infoLabel.frame.origin.y+infoLabel.frame.size.height+5, 245./375.*SIZE_DEVICE_WIDTH, 44) andButtonStyle:submitBtStyleModel andCallBack:^(UIButton *button) {
        
        [self.tabBarController setSelectedIndex:1];
        
    }];
    [_nodataView addSubview:submitBt];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
