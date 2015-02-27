//
//  QSWServiceTermViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWServiceTermViewController.h"
#import "DeviceSizeHeader.h"
#import "ColorHeader.h"

@interface QSWServiceTermViewController ()

@end

@implementation QSWServiceTermViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///标题
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"服务协议"];
    self.navigationItem.titleView = navTitle;
    
    ///自定义返回按钮
    UIBarButtonItem *turnBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(turnBackAction)];
    turnBackButton.tintColor = [UIColor whiteColor];
    
    ///设置返回按钮的颜色
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = turnBackButton;
    
    UILabel *serviceLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0, SIZE_DEVICE_WIDTH-2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT)];
    serviceLabel.text=@"中华人民共和国七升公司香哉饭馆出品,中华人民共和国七升公司香哉饭馆出品,中华人民共和国七升公司香哉饭馆出品,中华人民共和国七升公司香哉饭馆出品,中华人民共和国七升公司香哉饭馆出品";
    serviceLabel.lineBreakMode=0;
    serviceLabel.numberOfLines=0;
    serviceLabel.textColor=COLOR_CHARACTERS_ROOTLINE;
    [self.view addSubview:serviceLabel];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
}

#pragma mark - 返回事件
- (void)turnBackAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
