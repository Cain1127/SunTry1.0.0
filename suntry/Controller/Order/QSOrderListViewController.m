//
//  QSOrderListViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderListViewController.h"
#import "QSBlockButton.h"
#import "ImageHeader.h"
#import "QSLabel.h"
#import "DeviceSizeHeader.h"

//FIXME: 测试
#import "QSPPayForOrderViewController.h"

#define ORDER_LIST_VIEWCONTROLLER_NAV_TITLE_FONT_SIZE   17.
#define ORDER_LIST_VIEWCONTROLLER_CONTENT_COLOR         [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]
#define ORDER_LIST_VIEWCONTROLLER_CONTENT_FONT_SIZE     17.

@interface QSOrderListViewController ()

@property (nonatomic, strong) UIView *nodataView;

@end

@implementation QSOrderListViewController


- (void)loadView{
    
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:ORDER_LIST_VIEWCONTROLLER_NAV_TITLE_FONT_SIZE]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"外卖订单"];
    self.navigationItem.titleView = navTitle;
    
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
    [infoLabel setText:@"您现在还没有订单，马上点一份"];
    [infoLabel setTextColor:ORDER_LIST_VIEWCONTROLLER_CONTENT_COLOR];
    [_nodataView addSubview:infoLabel];
    
    QSBlockButtonStyleModel *submitBtStyleModel = [QSBlockButtonStyleModel alloc];
    submitBtStyleModel.bgColor  = [UIColor colorWithRed:0.471 green:0.176 blue:0.224 alpha:1.000];;
    submitBtStyleModel.title    = @"赶紧点一份";
    submitBtStyleModel.titleNormalColor = [UIColor whiteColor];
    submitBtStyleModel.cornerRadio = 6.;
    UIButton *submitBt = [UIButton createBlockButtonWithFrame:CGRectMake((SIZE_DEVICE_WIDTH-245./375.*SIZE_DEVICE_WIDTH)/2, infoLabel.frame.origin.y+infoLabel.frame.size.height+5, 245./375.*SIZE_DEVICE_WIDTH, 44) andButtonStyle:submitBtStyleModel andCallBack:^(UIButton *button) {
        
//        [self.tabBarController setSelectedIndex:1];
        //FIXME: 测试
        QSPPayForOrderViewController *pfovc = [[QSPPayForOrderViewController alloc] init];
        [self.navigationController pushViewController:pfovc animated:YES];
        
    }];
    [_nodataView addSubview:submitBt];
    
    //有数据显示
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [_nodataView setHidden:YES];
    
    
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
