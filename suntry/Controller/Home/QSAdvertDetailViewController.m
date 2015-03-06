//
//  QSAdvertDetailViewController.m
//  suntry
//
//  Created by ysmeng on 15/3/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAdvertDetailViewController.h"

#import "DeviceSizeHeader.h"

#import "QSBlockButton.h"

@interface QSAdvertDetailViewController ()

@property (nonatomic,copy) NSString *advertURL; //!<广告地址
@property (nonatomic,copy) NSString *title;     //!<标题

@end

@implementation QSAdvertDetailViewController

#pragma mark - 初始化
/**
 *  @author     yangshengmeng, 15-03-03 13:03:15
 *
 *  @brief      根据广告的地址，展示广告详情
 *
 *  @param url  广告地址
 *
 *  @return     返回给定地址的广告详情页
 *
 *  @since      1.0.0
 */
- (instancetype)initWithDetailURL:(NSString *)url  andTitle:(NSString *)title
{

    if (self = [super init]) {
        
        self.advertURL = url;
        self.title = title;
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    ///自定义返回按钮
    UIBarButtonItem *turnBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(turnBackAction)];
    turnBackButton.tintColor = [UIColor whiteColor];
    
    ///设置返回按钮的颜色
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = turnBackButton;
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"香哉"];
    self.navigationItem.titleView = navTitle;
    
    ///广告webview
    UIWebView *advertView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 69.0f)];
    advertView.backgroundColor = [UIColor whiteColor];
    advertView.scalesPageToFit = YES;
    
    ///取消滚动条
    for (UIView *obj in [advertView subviews]) {
        
        if ([obj isKindOfClass:[UIScrollView class]]) {
            
            ((UIScrollView *)obj).showsHorizontalScrollIndicator = NO;
            ((UIScrollView *)obj).showsVerticalScrollIndicator = NO;
            
        }
        
    }
    
    [self.view addSubview:advertView];
    
    if (self.advertURL) {
        
        [advertView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.advertURL]]];
        
    }
    
}

#pragma mark - 返回事件
- (void)turnBackAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
