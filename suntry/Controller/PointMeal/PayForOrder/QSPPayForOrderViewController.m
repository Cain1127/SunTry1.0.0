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

#define PAY_FOR_ORDER_TITLE_FONT_SIZE       17.
#define PAY_FOR_ORDER_TEXT_COLOR            [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]
#define PAY_FOR_ORDER_LINE_COLOR            [UIColor colorWithRed:206/255. green:208/255. blue:210/255. alpha:1]
#define PAY_FOR_ORDER_COUNT_TEXT_COLOR      [UIColor colorWithRed:0.503 green:0.183 blue:0.236 alpha:1.000]

@interface QSPPayForOrderViewController ()

@property(nonatomic,strong) QSLabel *foodCounLabel;
@property(nonatomic,strong) QSLabel *orderPriceLabel;
@property(nonatomic,strong) QSLabel *userBalanceLabel;

@end

@implementation QSPPayForOrderViewController

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
        [self.tabBarController setSelectedIndex:0];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    CGFloat offsetY = 3;
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
    [self.foodCounLabel setText:@"5"];
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

    QSLabel *orderPriceLabel = [[QSLabel alloc] initWithFrame:CGRectMake(foodCountLabel.frame.origin.x, lineView1.frame.origin.y+lineView1.frame.size.height+(44-17)/2, foodCountLabel.frame.size.width, foodCountLabel.frame.size.height)];
    [orderPriceLabel setFont:[UIFont systemFontOfSize:PAY_FOR_ORDER_TITLE_FONT_SIZE]];
    [orderPriceLabel setBackgroundColor:[UIColor clearColor]];
    [orderPriceLabel setText:@"订单金额"];
    [orderPriceLabel setTextColor:PAY_FOR_ORDER_TEXT_COLOR];
    [self.view addSubview:orderPriceLabel];
    
    self.orderPriceLabel = [[QSLabel alloc] initWithFrame:CGRectMake(orderPriceLabel.frame.origin.x, orderPriceLabel.frame.origin.y, orderPriceLabel.frame.size.width, orderPriceLabel.frame.size.height)];
    [self.orderPriceLabel setFont:[UIFont boldSystemFontOfSize:PAY_FOR_ORDER_TITLE_FONT_SIZE]];
    [self.orderPriceLabel setBackgroundColor:[UIColor clearColor]];
//    [self.orderPriceLabel setText:@"￥5"];
    [self.orderPriceLabel setTextAlignment:NSTextAlignmentRight];
//    [self.orderPriceLabel setTextColor:PAY_FOR_ORDER_COUNT_TEXT_COLOR];
    [self.view addSubview:self.orderPriceLabel];
    
    NSString *price = @"68";
    NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",price]];
    [priceString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)[UIColor blackColor].CGColor
                        range:NSMakeRange(0, 1)];
    [priceString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)PAY_FOR_ORDER_COUNT_TEXT_COLOR.CGColor
                        range:NSMakeRange(2, 2)];
//    [priceString addAttribute:(NSString *)kCTFontAttributeName
//                        value:(id)CTFontCreateWithName((CFStringRef)[UIFont boldSystemFontOfSize:14].fontName,
//                                                       14,
//                                                       NULL)
//                        range:NSMakeRange(0, 4)];
    [self.orderPriceLabel setAttributedText:priceString];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(lineView1.frame.origin.x, lineView1.frame.origin.y+lineView1.frame.size.height+44, lineView1.frame.size.width, lineView1.frame.size.height)];
    [lineView2 setBackgroundColor:PAY_FOR_ORDER_LINE_COLOR];
    [self.view addSubview:lineView2];
    
//    self.userBalanceLabel = [[QSLabel alloc] initWithFrame:CGRectMake(foodCountLabel.frame.origin.x, foodCountLabel.frame.origin.y, foodCountLabel.frame.size.width-20, foodCountLabel.frame.size.height)];
//    [self.userBalanceLabel setFont:[UIFont boldSystemFontOfSize:PAY_FOR_ORDER_TITLE_FONT_SIZE]];
//    [self.userBalanceLabel setBackgroundColor:[UIColor clearColor]];
//    [self.userBalanceLabel setText:@"5"];
//    [self.userBalanceLabel setTextAlignment:NSTextAlignmentRight];
//    [self.userBalanceLabel setTextColor:PAY_FOR_ORDER_COUNT_TEXT_COLOR];
//    [self.view addSubview:self.userBalanceLabel];
//    
//    QSLabel *userBalanceLastLabel = [[QSLabel alloc] initWithFrame:foodCountLabel.frame];
//    [userBalanceLastLabel setFont:[UIFont systemFontOfSize:PAY_FOR_ORDER_TITLE_FONT_SIZE]];
//    [userBalanceLastLabel setBackgroundColor:[UIColor clearColor]];
//    [userBalanceLastLabel setText:@"份"];
//    [userBalanceLastLabel setTextAlignment:NSTextAlignmentRight];
//    [userBalanceLastLabel setTextColor:[UIColor blackColor]];
//    [self.view addSubview:userBalanceLastLabel];
//    
//    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(12, offsetY+44, SIZE_DEVICE_WIDTH-24, 1)];
//    [lineView3 setBackgroundColor:PAY_FOR_ORDER_LINE_COLOR];
//    [self.view addSubview:lineView3];
    
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
